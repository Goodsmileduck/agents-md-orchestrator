# Claude Code — Memory File Best Practices (digest)

Sources: https://code.claude.com/docs/en/memory (primary),
https://code.claude.com/docs/en/best-practices
Last refreshed: 2026-06-07

## Core principle

Context is the scarce resource. CLAUDE.md loads every session — every line costs
tokens in every conversation. Official target: **under 200 lines per file**;
longer files reduce adherence. Litmus test per line: *"Would removing this cause
Claude to make mistakes?"* If not, cut it.

**Right altitude** (second failure mode): a rule can be useful but too brittle —
hardcoded step-by-step logic trees break on the first unanticipated case. Write
strong heuristics, not scripts. Both too-vague and too-prescriptive fail.

## Include

- Bash commands Claude can't guess (build, test, lint invocations)
- Code style rules that differ from language defaults
- Testing instructions and preferred test runners (prefer single tests over full suite)
- Repository etiquette (branch naming, PR conventions)
- Architectural decisions specific to the project
- Dev environment quirks (required env vars)
- Common gotchas / non-obvious behaviors
- A verification loop (test/build/lint command) so the agent can self-check

## Exclude

- Anything Claude can figure out by reading the code
- Standard language conventions
- Detailed API docs (link instead)
- Frequently-changing information
- File-by-file codebase descriptions
- Self-evident advice ("write clean code")
- Discovered/ephemeral facts — those belong in **auto memory** (below)

## Structure & mechanics

- Short, human-readable markdown; no required format. Headed sections
  (`# Code style`, `# Workflow`) work well.
- `@path/to/file` imports load eagerly every session — avoid them for
  reference material (prefer plain-path pointers); the only sanctioned use
  is the root shim (see File bridging).
- Locations & precedence: managed policy (`/etc/claude-code/CLAUDE.md`, non-
  excludable) > `~/.claude/CLAUDE.md` (user) > `./CLAUDE.md` (project, in git)
  > `./CLAUDE.local.md` (personal, gitignored). Parent/child dirs for
  monorepos — child files load when Claude reads files there.
- `claudeMdExcludes` (settings glob array) skips irrelevant ancestor
  CLAUDE.md/rules files — useful in monorepos and shared scopes where you
  can't edit the ancestor file.
- **Compaction asymmetry**: the project-root CLAUDE.md is re-injected after
  `/compact`; nested CLAUDE.md files are NOT (until a file there is read
  again). Durable instructions belong in the root file.
- Block-level HTML comments (`<!-- … -->`) are stripped before loading — they
  cost zero tokens (good for provenance/review-date stamps).
- Emphasis ("IMPORTANT", "YOU MUST") improves adherence — use sparingly.

## Where guidance belongs (four tiers)

1. **CLAUDE.md** — always-relevant rules; loads every session, costs always.
2. **`.claude/rules/*.md`** — topic rules; with YAML `paths:` glob frontmatter
   (e.g. `src/api/**/*.{ts,tsx}`) a rule loads only when Claude touches
   matching files — zero cost otherwise. Without `paths:` they load at launch
   like CLAUDE.md. User-level rules: `~/.claude/rules/`. Preferred home for
   file-type/subtree-specific guidance.
3. **Skills** (`.claude/skills/`) — sometimes-relevant workflows and domain
   knowledge; load on trigger.
4. **Hooks** — rules that must hold 100% of the time; memory instructions are
   advisory, hooks are deterministic.

## CLAUDE.md vs auto memory

Since v2.1.59 Claude keeps its own machine-local memory
(`~/.claude/projects/<project>/memory/`, `MEMORY.md` index — first 200 lines /
25 KB loaded per session, topic files on demand). Division of labor:
CLAUDE.md = human-authored durable rules; auto memory = Claude-discovered
commands, debugging insights, preferences. A thin CLAUDE.md is fine — Claude
captures the rest itself. Toggle: `/memory`, `autoMemoryEnabled`.

## Maintenance signals

- First check the file actually loads: `/memory` lists every instruction file
  loaded this session; the `InstructionsLoaded` hook logs which load and why.
  Don't diagnose "rule ignored" before confirming the rule was even in context.
- Claude ignores a rule that exists and loads → file is too long; prune.
- Claude asks questions answered in the file → phrasing is ambiguous; rewrite.
- Claude already does X correctly without the rule → delete the rule.
- Same mistake a second time → add a rule from the actual friction point.
- Treat it like code: review when things go wrong, prune regularly, verify
  changes actually shift behavior.

## File bridging (AGENTS.md interop)

Claude Code reads `CLAUDE.md`, not `AGENTS.md`. With AGENTS.md as the
canonical file, the sanctioned bridges are: `ln -s AGENTS.md CLAUDE.md`
(symlink), or a one-line `CLAUDE.md` containing `@AGENTS.md` (optionally with
Claude-only rules appended below). On Windows, symlinks need Admin/Developer
Mode — prefer the `@AGENTS.md` import there. `/init` generates a starter file
and also ingests `.cursorrules`/`.windsurfrules`/`.github/copilot-instructions.md`.

## Adjacent practices worth propagating

- Custom compaction instructions can live in CLAUDE.md
  (e.g. "When compacting, preserve the list of modified files").
- Community heuristic (non-official): numbered procedural workflows and one
  real code snippet outperform prose; auto-generated boilerplate sections are
  a liability.
