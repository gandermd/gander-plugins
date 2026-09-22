#!/usr/bin/env bash
# Sync skill content from gandermd/gander-skill into plugin trees.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_URL="${GANDER_SKILL_URL:-https://github.com/gandermd/gander-skill.git}"
TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Cloning $SRC_URL …"
git clone --depth 1 "$SRC_URL" "$TMP/gander-skill"
SRC="$TMP/gander-skill/.agents/skills/gander"
if [[ ! -f "$SRC/SKILL.md" ]]; then
  echo "error: SKILL.md not found at $SRC" >&2
  exit 1
fi

SHA="$(git -C "$TMP/gander-skill" rev-parse HEAD)"
echo "$SHA" > "$ROOT/.skill-source-sha"

for dest in claude/skills/gander cursor/skills/gander grok/skills/gander; do
  mkdir -p "$ROOT/$dest/scripts"
  cp "$SRC/SKILL.md" "$ROOT/$dest/SKILL.md"
  if [[ -d "$SRC/scripts" ]]; then
    cp "$SRC/scripts/"*.sh "$ROOT/$dest/scripts/" 2>/dev/null || true
    chmod +x "$ROOT/$dest/scripts/"*.sh 2>/dev/null || true
  fi
  echo "synced → $dest"
done

echo "Done. Source commit: $SHA"
