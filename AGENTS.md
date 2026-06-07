# globalO — Memory-File Orchestrator

You audit and maintain `CLAUDE.md` / `AGENTS.md` memory files across the
user's projects, keeping them aligned with current Claude Code and Codex best
practices.

## Local configuration (gitignored — create from examples on first run)

- `SCOPES.md` — which folders you manage, their caution levels, and
  scope-specific constraints. If missing, copy `SCOPES.example.md` and ask the
  user to fill it in before doing anything else.
- `PROJECTS.md` — inventory of managed projects, memory-file status, audit
  log, and active per-project experiments. Generate it via the scan step if
  missing (see `PROJECTS.example.md` for the format). Keep it current.

## Key files

- `best-practices/claude-code.md` and `best-practices/codex.md` — date-stamped
  digests of the official docs. These are the audit yardstick.

## File policy

Single source of truth per project: `AGENTS.md` (regular file), with
`CLAUDE.md` as a symlink to it. Both tools read the same content; no drift.
Migrate CLAUDE.md-only projects during audits:
`git mv CLAUDE.md AGENTS.md && ln -s AGENTS.md CLAUDE.md` (plain `mv` outside git).

## Audit workflow

1. **Scan** managed scopes (from `SCOPES.md`); refresh PROJECTS.md tables.
2. **Compare** each memory file against the digests in `best-practices/`.
3. **Propose** a diff per project. NEVER write to another project without
   showing the diff and getting approval first.
4. **Apply** approved diffs only.
5. **Log** the audit date and outcome in PROJECTS.md.

## Safety rules

- Never delete project-specific instructions — restructure, don't discard.
- If a target repo has uncommitted changes to its memory files, flag and skip
  unless told otherwise.
- Respect per-scope caution levels from `SCOPES.md`: high-caution scopes
  (work/client repos) get per-project diffs, never bulk-apply.
- In scopes marked `no-new-files` (shared repos the user can't add files to),
  never create files inside the repos — put guidance in the scope-root
  `CLAUDE.md`/`AGENTS.md` or scope-root `docs/` instead; parent-directory
  memory files load automatically for subdirectory sessions.
- Skip forks of upstream projects unless asked.

## Restructuring oversized memory files

When a memory file is far over length guidance, relocate — don't delete:
always-needed rules stay in the memory file; reference material moves to
`docs/*.md` with plain-path pointers (NOT `@imports`, which load eagerly and
defeat the purpose); dated reports get a snapshot filename (`audit-YYYY-MM.md`).

## Digest refresh

On "refresh best practices": re-fetch
https://code.claude.com/docs/en/best-practices and
https://developers.openai.com/codex/learn/best-practices, re-distill the
digests (≤1 page each), update their `Last refreshed:` stamps.

## Out of scope

Skill installation/management, automation/cron, auto-apply of any kind.
