---
name: refresh-best-practices
description: Check whether the official Claude Code and Codex best-practices docs have changed since the digests in best-practices/ were last refreshed, report the differences, and update the digests on approval. Use when the user asks to refresh best practices, check for doc updates, asks "are the digests current?", or before a large audit run when the digests are more than a month old.
---

# Refresh Best Practices

Compare the live vendor docs against the local digests and update them on
approval. The digests are the audit yardstick — stale digests mean audits
enforce outdated guidance.

## Sources and targets

| Live doc | Local digest |
|---|---|
| https://code.claude.com/docs/en/memory (primary) | `best-practices/claude-code.md` |
| https://code.claude.com/docs/en/best-practices | `best-practices/claude-code.md` |
| https://developers.openai.com/codex/learn/best-practices | `best-practices/codex.md` |
| https://developers.openai.com/codex/guides/agents-md | `best-practices/codex.md` |

## Workflow

1. **Read both digests** and note their `Last refreshed:` dates.
2. **Fetch both live docs** (WebFetch, in parallel). Prompt for: all guidance
   on writing memory/instructions files — recommended content, structure,
   length, anti-patterns, maintenance signals — plus any new features that
   change where guidance belongs (e.g. skills vs memory file vs hooks).
3. **Compare** fetched content against each digest. Classify findings:
   - **New guidance** — advice the digest doesn't cover
   - **Changed guidance** — advice that contradicts the digest
   - **Removed guidance** — digest content no longer in the docs
   - **Cosmetic** — rewording with no substantive change (ignore)
4. **Report** the findings per digest. If nothing substantive changed, say so,
   update only the `Last refreshed:` stamps, and stop.
5. **On approval**, rewrite the affected digest(s): keep them ≤1 page,
   actionable, structured as include/exclude lists plus maintenance signals.
   Update the `Last refreshed:` stamp to today.
6. **Flag downstream impact**: if changed guidance invalidates advice already
   propagated to managed projects, list which audit findings should be
   revisited (check PROJECTS.md audit log if present).

## Rules

- Never update a digest without showing the substantive changes first
  (stamp-only updates after a no-change check are fine).
- Digests are distillations in this project's own words — do not paste large
  verbatim excerpts from the vendor docs.
- If a fetch fails or redirects, report it rather than silently keeping the
  old digest; the URL may have moved and AGENTS.md needs updating.
