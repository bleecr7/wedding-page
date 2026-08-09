# AGENTS.md — Working Instructions

Guidance for AI coding agents working in this repository. Follow these rules
for every task.

## Project overview

Jekyll static site (wedding page) published via GitHub Pages at `morolee.life`.
See [`.notes/ARCHITECTURE.md`](.notes/ARCHITECTURE.md) for the full directory
map, DNS/deployment context, and current to-do list.

## Key commands

```sh
# Install gems (needs network; currently deferred)
bundle install

# Build the site (writes _site/)
bundle exec jekyll build

# Serve locally (http://localhost:4000)
bundle exec jekyll serve --livereload

# Boot the podman machine (required before the devcontainer will launch)
.vscode/setup-podman.sh
```

## Working rules

### 1. Present a plan for review before executing

Before making changes, state the execution plan explicitly and get approval.
Do not jump straight into edits — especially for anything that renames, moves,
removes, or restructures existing files, or that touches the devcontainer /
`.vscode` / build configuration. On approval, execute and then summarise.

### 1b. Write plans and intermediary output to `.notes/`

Use `.notes/` as the scratchpad for iteration. Write the plan there before
execution (or link to it), and append/update progress notes as you go. This
lets the user and future agents track decisions, options considered, and the
current state mid-task — not just the final result. Update the relevant
`.notes/` file at each meaningful step rather than only at the end.

### 2. Present recommendations based on inferred intent

As part of planning, infer what the user is trying to achieve and offer
concrete recommendations (with a recommended option called out first). Surface
relevant decisions the user may not have considered — e.g. tradeoffs, version
pinning, DNS/deploy implications, or clean-up of dead code.

### 3. Always test code before confirming completion

Do not report a task complete on the strength of writing files alone. Verify:

- Run the relevant test/build command (see above) or an equivalent check.
- If a check requires resources that are unavailable (e.g. slow/blocked
  network for `bundle install`, podman machine not booted), say so explicitly,
  record the exact pending verification steps in `.notes/` for the next agent,
  and do not claim success.
- Validate config files you touch (e.g. JSON/YAML) where a quick local check
  is possible.

## General conventions

- Do not commit or push unless explicitly asked.
- Do not create documentation files unless asked (AGENTS.md and
  `.notes/ARCHITECTURE.md` are the canonical working docs — keep them current
  when architecture changes).
- `.notes/` is gitignored working space: use it for planning notes, deferred
  tests, and agent hand-off notes.
- Follow the existing file structure and minimal style; do not add comments
  to code unless asked.
