# Codex — AGENTS.md Best Practices (digest)

Source: https://developers.openai.com/codex/learn/best-practices
Last refreshed: 2026-06-07

## Core principle

"A short, accurate AGENTS.md is more useful than a long file full of vague
rules." Start minimal; expand only when the agent makes the same mistake
repeatedly — evidence-based growth, not speculative rules.

## Essential sections

- Repository layout and important directories
- How to run the project
- Build, test, and lint commands
- Engineering conventions and PR expectations
- Constraints and do-not rules
- Definition of "done" and how to verify it

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
This is why a single shared `AGENTS.md` (with `CLAUDE.md` symlinked to it)
works — the content guidance is nearly identical.
