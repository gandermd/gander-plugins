# gander-plugins

Public **plugin wrappers** for [Gander](https://gander.md) — Claude Code, Cursor, and Grok Build packages that ship the Gander skill plus the `gander mcp` server entry.

The skill-native install surface (skills.sh / Cline) stays at [`gandermd/gander-skill`](https://github.com/gandermd/gander-skill). This repo is packaging only.

> **Not submitted.** These packages are **not** listed in Claude / Cursor / Grok / Cline directories or marketplaces yet. Do not treat this repo as a marketplace listing.

Product + docs (fence — prefer this over the CLI README): **[https://gander.md](https://gander.md)**

## Layout

| Path | Target |
|------|--------|
| `claude/` | Claude Code plugin (`.claude-plugin/plugin.json` + skill + `.mcp.json`) |
| `cursor/` | Cursor plugin (`.cursor-plugin/plugin.json` + skill + `mcp.json`) |
| `grok/` | Grok Build plugin shape (`.grok-plugin/plugin.json` + skill + `.mcp.json`) |
| `scripts/sync-skill.sh` | Re-vendor skill content from `gandermd/gander-skill` |
| `PACKAGING.md` | Target → path → validate matrix |

## Prerequisites

Install the Gander CLI first (plugins launch `gander mcp` over stdio; they do not vendor the binary):

```bash
brew tap gandermd/gander && brew install gander
# or
curl -fsSL https://release.gander.md/install.sh | bash
gander signup --email you@example.com
```

See [gander.md docs](https://gander.md/docs) and [MCP](https://gander.md/docs/mcp).

## Install (local / from GitHub URL)

### Claude Code

```bash
# From a clone of this repo
claude plugin validate ./claude
# Load for one session (example)
claude --plugin-dir ./claude
```

Or install from the public tree once a release SHA/tag exists (see `PACKAGING.md`). Marketplace submit is **out of scope** here.

### Cursor

Point Cursor at the `cursor/` directory (Customize → Plugins / local plugin install from GitHub path `gandermd/gander-plugins` → `cursor/`). Requires a valid `.cursor-plugin/plugin.json` (present).

### Grok Build

Suitable for an `xai-org/plugin-marketplace` **remote** entry that SHA-pins this repo (or a subdirectory clone of `grok/`). **Do not open that marketplace PR from this packaging work.**

### Skill-only (skills.sh / Cline)

Prefer the canonical skill repo:

```bash
npx skills add gandermd/gander-skill
# or: gander skill
```

## MCP shape (real CLI)

Per [gander.md/docs/mcp](https://gander.md/docs/mcp), agent harnesses launch:

```bash
gander mcp
```

Each plugin’s MCP config is therefore:

```json
{
  "mcpServers": {
    "gander": {
      "command": "gander",
      "args": ["mcp"]
    }
  }
}
```

Tools exposed by that server: `gander_list_comments`, `gander_reply_comment`, `gander_resolve_thread`, `gander_unresolve_thread`.

## Sync skill content

```bash
./scripts/sync-skill.sh
```

Copies `.agents/skills/gander/` from `gandermd/gander-skill` into `claude/`, `cursor/`, and `grok/` skill trees and records the source commit in `.skill-source-sha`.

## License

MIT — matches [`gandermd/gander-skill`](https://github.com/gandermd/gander-skill).
