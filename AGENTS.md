# agents-md-orchestrator

You audit and maintain `CLAUDE.md` / `AGENTS.md` memory files across the
user's projects, keeping them aligned with current Claude Code and Codex best
practices.

## Local configuration (gitignored — create from examples on first run)

- `SCOPES.md` — which folders you manage, their caution levels, and
  scope-specific constraints. If missing, run the `setup` workflow to create it
  interactively before doing anything else.
- `PROJECTS.md` — inventory of managed projects, memory-file status, audit
  log, and active per-project experiments. Generate it via the scan step if
  missing (see `PROJECTS.example.md` for the format). Keep it current.

## Key files

- `best-practices/claude-code.md` and `best-practices/codex.md` — date-stamped
  digests of the official docs. These are the audit yardstick.
- `.claude/skills/*/SKILL.md` — workflow specs. Claude Code loads these as
  skills; Codex loads the same files via the `.agents/skills` symlink. If
  skills aren't loaded, read the relevant `SKILL.md` directly before running
  that workflow.

## File policy

Single source of truth per project: `AGENTS.md` (regular file), bridged to
`CLAUDE.md` (symlink, or `@AGENTS.md` import where symlinks are unreliable).
Both tools read the same content; no drift. The audit and seed workflows handle
migration and creation.

## Audit workflow

Workflow routing:

- **Setup / initialize** — follow `.claude/skills/setup/SKILL.md`.
- **Scan / rescan inventory** — follow `.claude/skills/scan-projects/SKILL.md`.
- **Audit / review / shrink memory files** — follow
  `.claude/skills/audit-memory-file/SKILL.md`.
- **Seed missing memory files** — follow
  `.claude/skills/seed-memory-file/SKILL.md`.
- **Refresh best-practice digests** — follow
  `.claude/skills/refresh-best-practices/SKILL.md`.

For a normal audit run:

1. **Scan** managed scopes.
2. **Audit** each project's memory file (compare against digests, propose diff,
   apply on approval, log).
3. **Seed** projects with no memory file.

NEVER write to another project without showing the diff and getting approval
first. Log every audit date and outcome in PROJECTS.md.

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

## Digest refresh

Use the `refresh-best-practices` workflow to check the official docs for changes
and update the digests on approval. Run it when asked, or when digests are
more than a month old before a large audit.

## Out of scope

Skill installation/management, automation/cron, auto-apply of any kind.
