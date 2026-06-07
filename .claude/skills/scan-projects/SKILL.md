---
name: scan-projects
description: Regenerate the PROJECTS.md inventory by scanning the managed scopes from SCOPES.md for projects and their CLAUDE.md/AGENTS.md state (file, symlink, or absent) plus git presence. Use when the user asks to scan, rescan, refresh or generate the inventory, when PROJECTS.md is missing, or as step 1 of an audit run.
---

# Scan Projects

Regenerate PROJECTS.md from the filesystem while preserving the human-curated
columns (Last audit, Notes) and the Experiments table.

## Workflow

1. **Read `SCOPES.md`** for the scope list. If it doesn't exist, run the
   `setup` workflow first so the user gets an interactive first-run path
   instead of hand-editing tables.
2. **Run the scan script** with all scope paths:
   ```bash
   .claude/skills/scan-projects/scripts/scan.sh <base>/<scope1> <base>/<scope2> ...
   ```
   It emits one markdown table per scope with detected CLAUDE.md/AGENTS.md
   state and git presence, with `never`/empty in the Last-audit/Notes columns.
3. **Merge with the existing PROJECTS.md** (if any): carry over each project's
   `Last audit` and `Notes` values and the entire `## Experiments` section.
   Exception: any `other:` token in Notes reflects current disk state — keep
   the freshly scanned one, appended to the carried-over human note.
   New projects keep `never`/empty. Projects that vanished from disk: drop the
   row but mention the removal to the user.
4. **Apply scope annotations from SCOPES.md**: caution labels in scope
   headings (e.g. `## work/ (high caution)`), and for scopes marked "single
   project at scope root", replace the per-subdir rows with one row for the
   scope itself. Drop rows matching the `Never touch` list; keep rows for
   known forks but mark them `fork — skip` in Notes so audits pass over them.
5. **Write PROJECTS.md** with today's date in the `Scanned:` line, and report
   a short delta summary (new / removed / state-changed projects).

## Notes

- The script skips `node_modules`, `.git`, `.claude` directories; it does not
  recurse below one level — projects are direct children of a scope.
- A `(root)` row is emitted when the scope folder itself has memory files
  (e.g. a work scope with one shared root CLAUDE.md).
- **Cross-tool drift**: the script flags other agent-config files
  (`GEMINI.md`, copilot-instructions, etc. — see its `OTHER_FILES` list) as
  `other:` in Notes. Those tools read their own file first, silently
  overriding the shared memory file; the audit skill checks flagged files for
  contradictions (Gemini CLI can be pointed at the shared file via
  `context.fileName` instead — useful in no-new-files scopes).
