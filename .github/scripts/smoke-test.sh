#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SITE="$ROOT/_site"
INDEX="$SITE/index.html"

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "ok: $1"; }

[ -f "$INDEX" ] && [ -s "$INDEX" ] || fail "index.html missing or empty"
pass "index.html present"

CNAME="$(cat "$SITE/CNAME")"
[ "$CNAME" = "morolee.life" ] || fail "CNAME is '$CNAME', expected morolee.life"
pass "CNAME is morolee.life"

for anchor in home details timeline travel rsvp; do
  grep -q "id=\"$anchor\"" "$INDEX" || fail "missing section anchor #$anchor"
done
pass "all section anchors present: home details timeline travel rsvp"

for marker in "Elisabeth" "27th July 2027" "We are best contacted via WhatsApp."; do
  grep -q -- "$marker" "$INDEX" || fail "missing content marker: $marker"
done
pass "content markers present"

[ -f "$SITE/feed.xml" ] && [ -s "$SITE/feed.xml" ] || fail "feed.xml missing or empty"
pass "feed.xml present"

PORT=4000
LOG="$(mktemp)"
BASEURL="$(ruby -ryaml -e 'puts (YAML.load_file(ARGV[0])["baseurl"] || "").to_s' "$ROOT/_config.yml")"
TARGET="http://localhost:$PORT${BASEURL%/}/"
bundle exec jekyll serve \
  --source "$ROOT" \
  --destination "$SITE" \
  --port "$PORT" \
  --skip-initial-build \
  --no-watch \
  >"$LOG" 2>&1 &
SERVER_PID=$!
cleanup() { kill "$SERVER_PID" 2>/dev/null || true; }
trap cleanup EXIT

for i in $(seq 1 30); do
  if curl -fsS -o /dev/null "$TARGET"; then
    pass "homepage serves HTTP 200 at $TARGET"
    exit 0
  fi
  sleep 1
done

echo "server log:" >&2
cat "$LOG" >&2
fail "homepage did not serve within 30s at $TARGET"