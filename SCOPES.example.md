# Managed Scopes

Copy this file to `SCOPES.md` (gitignored) and fill in your own folders.

Base directory: `~/projects/` <!-- where your projects live -->

| Scope | Caution | Constraints |
|---|---|---|
| `personal/` | normal | — |
| `work/` | high (work) | `no-new-files`; NEVER git commit/push there |
| `clients/` | high (client) | `no-new-files` |

Caution levels:
- **normal** — propose diffs, apply on approval.
- **high** — per-project diffs only, never bulk-apply; extra constraints apply.

Constraints:
- `no-new-files` — never create files inside these repos (shared repos you
  can't commit personal tooling to); guidance goes in the scope-root memory
  file or scope-root `docs/` instead.

Never touch: `archive/` <!-- folders the orchestrator must ignore -->

Known forks to skip: <!-- upstream forks where memory files don't belong -->
