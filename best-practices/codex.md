# Codex — AGENTS.md Best Practices (digest)

Sources: https://developers.openai.com/codex/learn/best-practices,
https://developers.openai.com/codex/guides/agents-md
Last refreshed: 2026-06-07

## Core principle

"A short, accurate AGENTS.md is more useful than a long file full of vague
rules." Start minimal; expand only when the agent makes the same mistake
repeatedly — evidence-based growth, not speculative rules.

## Essential sections

- Repository layout and important directories (only where non-obvious — a
  layout `ls` already reveals earns no lines)
- How to run the project
- Build, test, and lint commands
- Engineering conventions and PR expectations
- Constraints — strongest pattern (GitHub's 2,500-repo analysis): a three-tier
  **Always / Ask-first / Never** block, not one flat do-not list. Always:
  read, single-file lint/typecheck/test. Ask-first: installs, commits/pushes,
  deletes, full builds. Never: secrets, force-push main.
- Definition of "done" and how to verify it

## Size limits

Codex caps combined AGENTS.md content at **32 KiB** (`project_doc_max_bytes`),
concatenating root-to-leaf and **silently dropping** whatever exceeds the cap.
Treat 32 KiB total as a hard audit threshold; fix by shrinking or raising the
limit in `config.toml`.

## Hierarchy

- `~/.codex/AGENTS.md` — global personal defaults
- `./AGENTS.md` — repository-level shared standards
- Subdirectory `AGENTS.md` — local rules; **more specific files take precedence**

## Anti-patterns

- Cramming durable guidance into prompts instead of AGENTS.md
- Long files with vague constraints
- Omitting build/test/lint commands (kills the agent's ability to self-verify)

## Improvement workflow

- Same mistake twice → run a retrospective, update AGENTS.md from the actual
  friction point.
- File getting long → keep the main file concise; reference task-specific
  markdown files (code review guide, architecture decisions) from it.

## Config (outside AGENTS.md)

- `~/.codex/config.toml` — personal defaults
- `.codex/config.toml` — repo-specific settings
- Profiles for per-context overrides

## Convergence with Claude Code

Both tools agree: short, concrete, command-rich, evidence-grown files.
AGENTS.md is now a Linux Foundation–governed standard read natively by 20+
tools — a single shared `AGENTS.md` (bridged to `CLAUDE.md` via symlink or
`@AGENTS.md` import) is the standards-aligned setup; the content guidance is
nearly identical.
