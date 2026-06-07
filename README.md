# globalO — Memory-File Orchestrator

A meta-project for [Claude Code](https://code.claude.com) (and Codex) that
audits and maintains the `CLAUDE.md` / `AGENTS.md` memory files across all
your other projects, keeping them aligned with current best practices.

Memory files rot: best practices shift, files bloat until the model ignores
them, and every project drifts in its own direction. globalO gives you one
place to scan, audit, and fix them — with an inventory, an audit log, and
date-stamped best-practice digests as the yardstick.

## How it works

Open this folder in Claude Code. The orchestrator instructions (`AGENTS.md`)
drive a propose-then-approve workflow:

1. **Scan** your managed folders for projects and their memory files
2. **Compare** each against the digests in `best-practices/`
3. **Propose** a diff per project — nothing is written without your approval
4. **Apply** approved diffs
5. **Log** the outcome in your inventory

## Setup

```bash
git clone https://github.com/<you>/globalO
cd globalO
cp SCOPES.example.md SCOPES.md   # fill in your project folders
claude                            # then: "run an audit"
```

`SCOPES.md` (your folder list) and `PROJECTS.md` (your inventory) are
gitignored — your project names stay private. The orchestrator generates
`PROJECTS.md` on first scan.

## What's in the box

| File | Purpose |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md` symlink) | Orchestrator instructions: workflow, safety rules |
| `best-practices/claude-code.md` | Digest of the official Claude Code guidance |
| `best-practices/codex.md` | Digest of the official Codex AGENTS.md guidance |
| `SCOPES.example.md` | Template for your managed-folder config |
| `PROJECTS.example.md` | Inventory format reference |

## Opinions baked in

- **One source of truth per project:** `AGENTS.md` as the file, `CLAUDE.md`
  as a symlink to it — Claude Code and Codex read the same content, no drift.
- **Propose-then-approve, always.** The orchestrator never edits another
  project silently.
- **Relocate, don't delete.** Oversized memory files get split: always-needed
  rules stay, reference material moves to `docs/` behind plain-path pointers
  (not `@imports`, which load eagerly).
- **Caution levels.** Work/client repos get per-project diffs and a
  `no-new-files` constraint — guidance lives at scope root, outside the repos.
- **Evidence-grown files.** Rules get added when the agent actually makes the
  mistake, not speculatively (per both vendors' guidance).

## License

MIT
