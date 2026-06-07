# Claude Code — Memory File Best Practices (digest)

Source: https://code.claude.com/docs/en/best-practices
Last refreshed: 2026-06-07

## Core principle

Context is the scarce resource. CLAUDE.md loads every session — every line costs
tokens in every conversation. Bloated files cause Claude to ignore the rules
that matter. Litmus test per line: *"Would removing this cause Claude to make
mistakes?"* If not, cut it.

## Include

- Bash commands Claude can't guess (build, test, lint invocations)
- Code style rules that differ from language defaults
- Testing instructions and preferred test runners (prefer single tests over full suite)
- Repository etiquette (branch naming, PR conventions)
- Architectural decisions specific to the project
- Dev environment quirks (required env vars)
- Common gotchas / non-obvious behaviors

## Exclude

- Anything Claude can figure out by reading the code
- Standard language conventions
- Detailed API docs (link instead)
- Frequently-changing information
- File-by-file codebase descriptions
- Self-evident advice ("write clean code")

## Structure & mechanics

- Short, human-readable markdown; no required format. Headed sections
  (`# Code style`, `# Workflow`) work well.
- `@path/to/file` imports compose files (e.g. shared core + tool extras).
- Locations: `~/.claude/CLAUDE.md` (global), `./CLAUDE.md` (shared, in git),
  `./CLAUDE.local.md` (personal, gitignored), parent/child dirs for monorepos
  (child files load on demand).
- Emphasis ("IMPORTANT", "YOU MUST") improves adherence — use sparingly.
- Domain knowledge or sometimes-relevant workflows belong in **skills**
  (`.claude/skills/`), not CLAUDE.md — they load on demand.
- Rules that must hold 100% of the time belong in **hooks**, not CLAUDE.md —
  memory instructions are advisory; hooks are deterministic.

## Maintenance signals

- Claude ignores a rule that exists → file is too long; prune.
- Claude asks questions answered in the file → phrasing is ambiguous; rewrite.
- Claude already does X correctly without the rule → delete the rule.
- Treat it like code: review when things go wrong, prune regularly, verify
  changes actually shift behavior.

## Adjacent practices worth propagating

- Give Claude a verification loop (test command, build, lint) in the file.
- `/init` generates a starter CLAUDE.md; refine from there.
- Custom compaction instructions can live in CLAUDE.md
  (e.g. "When compacting, preserve the list of modified files").
