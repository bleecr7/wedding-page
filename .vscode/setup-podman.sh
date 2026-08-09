#!/usr/bin/env bash
set -euo pipefail

# Detects the host OS and prepares Podman for use with
# the VS Code Dev Containers extension / devcontainer CLI.

if ! command -v podman >/dev/null 2>&1; then
  echo "ERROR: podman not found. Install it first (e.g. 'brew install podman' on macOS)." >&2
  exit 1
fi

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

setup_macos() {
  if ! podman machine list --format '{{.Name}}' 2>/dev/null | grep -q .; then
    echo "No podman machine found. Initializing..."
    podman machine init
  fi

  local running
  running="$(podman machine list --format '{{.Name}} {{.Running}}' 2>/dev/null || true)"
  echo "$running" | while read -r name state; do
    if [ "$state" = "true" ]; then
      echo "Machine '$name' is already running."
    else
      echo "Starting machine '$name'..."
      podman machine start "$name"
    fi
  done

  local sock="$HOME/.podman/podman-machine-default/podman.sock"
  echo
  echo "Podman machine socket: $sock"
  echo "Export this for the devcontainer CLI if needed:"
  echo "  export DOCKER_HOST=unix://$sock"
}

setup_linux() {
  if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root; enabling system podman socket..."
    systemctl enable --now podman.socket
  else
    systemctl --user enable --now podman.socket
    echo
    echo "Podman socket: $XDG_RUNTIME_DIR/podman/podman.sock"
    echo "If running as a non-root user, export for the devcontainer CLI:"
    echo "  export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  fi
}

setup_windows() {
  echo "Native Windows detected. Run Podman via WSL2 and run this script inside WSL." >&2
  echo "Alternatively, use 'podman machine init && podman machine start' from PowerShell." >&2
  exit 1
}

case "$(detect_os)" in
  macos)   setup_macos ;;
  linux)   setup_linux ;;
  windows) setup_windows ;;
  *)
    echo "ERROR: unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

echo
echo "Done. You can now run:  devcontainer up --workspace-folder ."
