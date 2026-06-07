---
name: setup
description: First-run interactive setup - discover the user's project folders, interview them about caution levels and exclusions, write SCOPES.md, then generate the initial PROJECTS.md inventory. Use when the user asks to set up, configure, onboard, initialize, or get started with the orchestrator, or when SCOPES.md is missing and any other workflow needs it.
---

# Setup

Build SCOPES.md and the first PROJECTS.md interactively, so a new user never
edits config tables by hand. Discover first, ask second.

## Workflow

1. **Check for existing config.** If `SCOPES.md` already exists, ask whether
   to add a new scope to it or rebuild from scratch — never silently overwrite.
2. **Ask for the base folder(s)** where their projects live (e.g.
   `~/projects`, `~/code`, `~/work`). One open question; accept several paths.
3. **Run discovery**:
   ```bash
   .claude/skills/setup/scripts/discover.sh <base-dir>...
   ```
   Each direct child is classified: `scope` (≥2 git repos inside), `project`
   (a git repo itself), `scope?` (several children, no repos), `?` (unclear).
   Counts of children/repos/memory-files (plus root git/memory-file flags)
   show what would be managed.
4. **Interview per candidate** — keep it short, multiple-choice, with
   defaults pre-filled from heuristics:
   - Include this folder? (default: yes for `scope`, ask for `?`)
   - Caution level: **normal** (personal) or **high** (work/client —
     per-project diffs, never bulk-apply). Names like `work/`, `clients/`,
     or an employer name suggest high.
   - For high-caution scopes: can new files be committed to these repos?
     If not → mark `no-new-files` (guidance goes in scope-root memory
     file / docs instead).
   - Any folders to skip entirely (archives, forks of upstream projects)?
   - For `scope?` folders with no repos: is this one project at the scope
     root, or a group of non-git projects?
5. **Write `SCOPES.md`** in the `SCOPES.example.md` format and show it for
   review. It is gitignored — project names stay private.
6. **Generate the inventory**: invoke the `scan-projects` skill to create
   PROJECTS.md from the new SCOPES.md.
7. **Report headline numbers**: N projects, M with memory files, K already
   symlinked, J candidates for seeding — and suggest the natural next step
   (usually "run an audit" or seeding the bare projects).

## Notes

- This skill only writes inside this repo (SCOPES.md, PROJECTS.md — both
  gitignored), so no propose-then-approve ceremony beyond showing SCOPES.md.
- Don't interrogate: a base folder with 3 obvious scopes should take ~3
  questions total, not 3 per scope. Batch where the answer is likely uniform.
