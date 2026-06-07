#!/usr/bin/env bash
# discover.sh <base-dir>... — find candidate scope folders for SCOPES.md.
# For each direct child of a base dir, report whether it looks like a
# scope (contains multiple projects) or a single project, plus counts.
set -euo pipefail

for base in "$@"; do
  base="${base%/}"
  [ -d "$base" ] || { echo "WARN: $base not found" >&2; continue; }
  echo "# $base"
  for dir in "$base"/*/; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    case "$name" in node_modules|.git|.claude) continue ;; esac

    # Count direct children that are git repos, and memory files at both levels
    repos=0 children=0 mem=0
    for sub in "$dir"*/; do
      [ -d "$sub" ] || continue
      case "$(basename "$sub")" in node_modules|.git|.claude) continue ;; esac
      children=$((children + 1))
      [ -e "$sub/.git" ] && repos=$((repos + 1))
      { [ -e "$sub/CLAUDE.md" ] || [ -e "$sub/AGENTS.md" ]; } && mem=$((mem + 1))
    done

    root_git="no"; [ -e "$dir/.git" ] && root_git="yes"
    root_mem="no"
    { [ -e "$dir/CLAUDE.md" ] || [ -e "$dir/AGENTS.md" ]; } && root_mem="yes"

    # Classify: scope = multiple project-like children; project = git repo itself
    if [ "$repos" -ge 2 ]; then kind="scope"
    elif [ "$root_git" = "yes" ]; then kind="project"
    elif [ "$children" -ge 2 ]; then kind="scope?"
    else kind="?"
    fi

    printf '%s\t%s\tchildren=%s\trepos=%s\tmemory-files=%s\troot-git=%s\troot-memory=%s\n' \
      "$name/" "$kind" "$children" "$repos" "$mem" "$root_git" "$root_mem"
  done
done
