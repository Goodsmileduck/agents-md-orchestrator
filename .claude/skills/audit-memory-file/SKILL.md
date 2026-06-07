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
     (NOT `@imports` — they load eagerly and defeat the purpose; the only
     sanctioned import is the one-line `@AGENTS.md` bridge shim used where
     symlinks are unreliable)
   - **Cut** — generic advice, things inferable from code, stale info
   - **Rewrite** — rules at the wrong altitude: brittle step-by-step logic
     trees → strong heuristics
   - **Missing** — no build/test/lint commands, no verification step
   Flag breaches of the hard size limits stated in the digests (Claude
   line ceiling, Codex byte cap).
4. **Verify claims against the repo** (cheap, catches rot the yardstick
   can't): every path the file mentions exists; every referenced command
   (`npm run X`, make/just targets) is actually defined in
   package.json/Makefile/etc. Flag stale claims for Cut or fix. If the
   inventory row carries an `other:` flag (GEMINI.md,
   copilot-instructions.md, …), skim those files for contradictions with
   the memory file and propose consolidating them into it. If the user reports a
   rule being ignored, first confirm the file loads at all (`/memory` lists
   loaded instruction files) before diagnosing length.
5. **Structural fixes** to include in the proposal when applicable:
   - **Bridge migration**: target state is `CLAUDE.md` (file) +
     `AGENTS.md → CLAUDE.md` (symlink). Migrate:
     `git mv AGENTS.md CLAUDE.md && ln -s CLAUDE.md AGENTS.md`
     (plain `mv` outside git). Where symlinks are unreliable (Windows),
     reverse the pair: keep `AGENTS.md` as the file with a `CLAUDE.md`
     containing `@AGENTS.md` — Codex cannot import, so AGENTS.md must hold
     the real content there. Stage but never commit.
   - **Oversized file**: relocate, don't delete — always-needed rules stay;
     file-type/subtree-specific rules → `.claude/rules/*.md` with `paths:`
     frontmatter (load only when matching files are touched); reference
     material → `docs/`; dated reports → `docs/<topic>-YYYY-MM.md`
     snapshots. In `no-new-files` scopes, relocated content goes to the
     scope-root `docs/` instead of inside the repo.
6. **Propose** the full diff and a one-line score summary
   (structure / conciseness / specificity / altitude / completeness /
   staleness). Wait for approval.
7. **Apply** only what was approved. Optionally stamp provenance as a
   zero-cost HTML comment (`<!-- audited YYYY-MM-DD by agents-md-orchestrator -->`).
8. **Log** in PROJECTS.md: set `Last audit` to today, update the
   CLAUDE.md/AGENTS.md state columns, add a short note for anything notable
   (including stale claims found in step 4).

## Score quickly, don't ceremonialize

The score exists to justify the proposal in one line ("4/10 — 600 lines of
reference data loaded every session"), not to produce a report. Spend the
effort on the diff.
