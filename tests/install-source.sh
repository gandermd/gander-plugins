#!/usr/bin/env bash
# Vendored skills tag hosted signup/share/watch with the plugin source.
# The rewriter turns the skill repo's `skill` default into that source
# without touching the word "skill" elsewhere.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

assert_tree() {
  local dir="$1"
  local src="$2"
  local f
  for f in "$dir/SKILL.md" "$dir/scripts/save-plan.sh" "$dir/scripts/watch-markdown.sh"; do
    if grep -q -F '${GANDER_SOURCE:-skill}' "$f" || grep -q -F 'GANDER_SOURCE=skill' "$f"; then
      echo "$f still defaults to skill" >&2
      fail=1
    fi
  done
  if ! grep -q -F "\${GANDER_SOURCE:-$src}" "$dir/SKILL.md"; then
    echo "$dir/SKILL.md missing $src" >&2
    fail=1
  fi
  if ! grep -q -F "\${GANDER_SOURCE:-$src}" "$dir/scripts/save-plan.sh"; then
    echo "$dir/scripts/save-plan.sh missing $src" >&2
    fail=1
  fi
  if ! grep -q -F "\${GANDER_SOURCE:-$src}" "$dir/scripts/watch-markdown.sh"; then
    echo "$dir/scripts/watch-markdown.sh missing $src" >&2
    fail=1
  fi
  if grep -E -q "GANDER_SOURCE.*gander README|GANDER_SOURCE.*gander --watch README" "$dir/SKILL.md"; then
    echo "$dir local preview must not set GANDER_SOURCE" >&2
    fail=1
  fi
}

assert_tree "$ROOT/claude/skills/gander" plugin-claude
assert_tree "$ROOT/cursor/skills/gander" plugin-cursor
assert_tree "$ROOT/grok/skills/gander" plugin-grok

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts"
printf '%s\n' 'GANDER_SOURCE="${GANDER_SOURCE:-skill}" gander share --silent' 'keep the word skill' > "$tmp/SKILL.md"
printf '%s\n' 'export GANDER_SOURCE="${GANDER_SOURCE:-skill}"' > "$tmp/scripts/watch-markdown.sh"
"$ROOT/scripts/rewrite-install-source.sh" "$tmp" plugin-grok
if ! grep -q -F '${GANDER_SOURCE:-plugin-grok}' "$tmp/SKILL.md"; then
  echo "rewriter missed SKILL.md" >&2
  fail=1
fi
if ! grep -q -F 'keep the word skill' "$tmp/SKILL.md"; then
  echo "rewriter changed the word skill" >&2
  fail=1
fi
if grep -q -F '${GANDER_SOURCE:-skill}' "$tmp/scripts/watch-markdown.sh"; then
  echo "rewriter left skill default in the script" >&2
  fail=1
fi
if "$ROOT/scripts/rewrite-install-source.sh" "$tmp" skill >/dev/null 2>&1; then
  echo "rewriter should reject a non-plugin source" >&2
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi
echo "ok"
