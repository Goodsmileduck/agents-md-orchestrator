---
name: audit-memory-file
description: Audit one project's CLAUDE.md/AGENTS.md against the best-practice digests - score it, classify content, propose a diff (including symlink migration and oversized-file restructuring), apply on approval, and log the result. Use when the user asks to audit, review, fix, or shrink a specific project's memory file, or for each project during an audit run.
---

# Audit Memory File

NEVER write to the target project without showing the diff first.

## Workflow

1. **Safety check.** If the project is a git repo and its memory files have
   uncommitted changes, flag and skip unless told otherwise. Check the
   project's scope in `SCOPES.md` for caution level, constraints
   (`no-new-files` etc.), and the `Never touch` / fork-skip lists — skip
   listed projects unless explicitly asked.
2. **Read the yardstick**: `best-practices/claude-code.md` and
   `best-practices/codex.md`.
3. **Read the target** memory file(s) and assess each line against the
   litmus test: *would removing this cause the agent to make mistakes?*
   Classify content:
   - **Keep** — commands, project-specific rules, gotchas, env quirks
   - **Relocate** — reference material, per-subproject detail, dated reports
     → move to the project's `docs/*.md` with plain-path pointers
     (NOT `@imports` — they load eagerly and defeat the purpose)
   - **Cut** — generic advice, things inferable from code, stale info
   - **Missing** — no build/test/lint commands, no verification step
4. **Structural fixes** to include in the proposal when applicable:
   - **Symlink migration**: target state is `AGENTS.md` (file) +
     `CLAUDE.md → AGENTS.md` (symlink). Migrate:
     `git mv CLAUDE.md AGENTS.md && ln -s AGENTS.md CLAUDE.md`
     (plain `mv` outside git). Stage but never commit.
   - **Oversized file**: relocate, don't delete — always-needed rules stay;
     reference material → `docs/`; dated reports → `docs/<topic>-YYYY-MM.md`
     snapshots. In `no-new-files` scopes, relocated content goes to the
     scope-root `docs/` instead of inside the repo.
5. **Propose** the full diff and a one-line score summary
   (structure / conciseness / specificity / completeness). Wait for approval.
6. **Apply** only what was approved.
7. **Log** in PROJECTS.md: set `Last audit` to today, update the
   CLAUDE.md/AGENTS.md state columns, add a short note for anything notable.

## Score quickly, don't ceremonialize

The score exists to justify the proposal in one line ("4/10 — 600 lines of
reference data loaded every session"), not to produce a report. Spend the
effort on the diff.
