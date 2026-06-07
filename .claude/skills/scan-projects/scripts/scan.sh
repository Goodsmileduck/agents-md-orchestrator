#!/usr/bin/env bash
# scan.sh <scope-dir>... — emit fresh PROJECTS.md inventory rows per scope.
# Detects CLAUDE.md/AGENTS.md state (file / link / —) and git presence.
# Merging Notes and Last-audit columns from the previous inventory is the
# caller's job; this script always emits "never" and an empty Notes cell.
set -euo pipefail

state() {
  if [ -L "$1" ]; then echo "link"
  elif [ -f "$1" ]; then echo "file"
  else echo "—"; fi
}

for base in "$@"; do
  [ -d "$base" ] || { echo "WARN: $base not found" >&2; continue; }
  echo "## $(basename "$base")/"
  echo
  echo "| Project | CLAUDE.md | AGENTS.md | Git | Last audit | Notes |"
  echo "|---|---|---|---|---|---|"
  c=$(state "$base/CLAUDE.md"); a=$(state "$base/AGENTS.md")
  if [ "$c" != "—" ] || [ "$a" != "—" ]; then
    g=$([ -d "$base/.git" ] && echo yes || echo no)
    echo "| (root) | $c | $a | $g | never | |"
  fi
  for d in "$base"/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    case "$name" in node_modules|.git|.claude) continue ;; esac
    c=$(state "${d}CLAUDE.md"); a=$(state "${d}AGENTS.md")
    g=$([ -d "${d}.git" ] && echo yes || echo no)
    echo "| $name | $c | $a | $g | never | |"
  done
  echo
done
