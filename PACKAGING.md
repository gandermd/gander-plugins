# PACKAGING — gander-plugins

**Status:** draft packaging only. **Not submitted** to Claude / Cursor / Grok / Cline / skills.sh directories or marketplaces.

Fence for listing copy: point at [https://gander.md](https://gander.md) (homepage/docs), not the CLI README.

## Target → path → validate

| Target | Repo | Path | Validate |
|--------|------|------|----------|
| skills.sh | [`gandermd/gander-skill`](https://github.com/gandermd/gander-skill) | `.agents/skills/gander/SKILL.md` | `npx skills add gandermd/gander-skill --list` (discoverable under `.agents/skills/`) |
| Cline Marketplace | `gandermd/gander-skill` | same skill; entry fields for Scout | Skill installs via `npx skills add` / `gander skill`; marketplace PR **not** filed here |
| Claude plugin | [`gandermd/gander-plugins`](https://github.com/gandermd/gander-plugins) | `claude/` | `claude plugin validate ./claude` |
| Cursor plugin | `gandermd/gander-plugins` | `cursor/` | Layout vs [Cursor plugins reference](https://cursor.com/docs/reference/plugins); local install from GitHub URL |
| Grok plugin | `gandermd/gander-plugins` | `grok/` | Layout checklist for remote `url` + SHA pin; marketplace PR **not** filed here |

## MCP bundling (v1)

Claude + Cursor plugins include `.mcp.json` / `mcp.json` launching `gander mcp` (stdio). Grok includes the same `.mcp.json` (clean parallel to Claude’s plugin MCP file). Binary is **not** vendored — CLI must be on `PATH`.

## Tag policy

Annotated tag `dirs-2026-09-22` only after validate clearly passes (owner confirm at cut time). Do not move the tag.

## Explicitly not done

- No merge to default without owner
- No directory / marketplace form submits
- No PRs to `xai-org/plugin-marketplace` or `cline/marketplace`
- No invented traction metrics
