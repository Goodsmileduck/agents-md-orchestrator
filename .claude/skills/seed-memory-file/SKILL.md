---
name: seed-memory-file
description: Bootstrap a minimal AGENTS.md (with CLAUDE.md symlink) for a project that has no memory file yet, by exploring the codebase for commands, structure, and conventions. Use when the user asks to seed, bootstrap, init, or create a memory file / AGENTS.md / CLAUDE.md for a project, or for inventory rows where both files are absent.
---

# Seed Memory File

Create a first AGENTS.md for a project that has none. Short and
evidence-based: a new memory file earns lines from what's actually in the
repo, not from speculation.

## Workflow

1. **Safety check.** Check the project's scope in `SCOPES.md`: in
   `no-new-files` scopes do NOT create files inside the repo — propose adding
   a section to the scope-root memory file instead. Skip projects on the
   `Never touch` / fork-skip lists unless explicitly asked.
2. **Explore the project** (keep it cheap — README, manifests, CI config,
   Makefile/justfile, top-level layout):
   - How to build, test, lint, run — exact commands
   - Tech stack and versions that aren't obvious from a glance
   - Non-obvious conventions or quirks (env vars, ports, codegen steps)
3. **Draft AGENTS.md**, target ≤40 lines:
   - 1–2 sentence project description
   - `## Commands` — build/test/lint/run with inline comments
   - `## Structure` — only if the layout is non-obvious; a few key dirs max
   - `## Rules` — only constraints with evidence (e.g. CI enforces a
     formatter, a dir is generated code)
   - Omit any section with nothing non-obvious to say. Never include generic
     advice, file-by-file descriptions, or restated language defaults.
4. **Propose** the draft. Wait for approval.
5. **Create on approval**: write `AGENTS.md`, then
   `ln -s AGENTS.md CLAUDE.md`. In git repos, stage both but never commit.
6. **Log** in PROJECTS.md: state columns to `link`/`file`, `Last audit` to
   today, note "seeded".

## Anti-patterns

- Don't pad a thin project to make the file look complete — a 10-line
  AGENTS.md for a simple repo is correct.
- Don't document what `ls` and the README already make obvious.
- Don't guess commands — verify they exist in manifests/CI before writing
  them down.
