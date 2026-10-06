#!/usr/bin/env bash
# Rewrite a vendored gander-skill tree's install-source default.
# Usage: rewrite-install-source.sh <skill-dir> <plugin-claude|plugin-cursor|plugin-grok>
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "usage: rewrite-install-source.sh <skill-dir> <source>" >&2
  exit 2
fi

dir="$1"
src="$2"
case "$src" in
  plugin-claude|plugin-cursor|plugin-grok) ;;
  *)
    echo "error: install source must be plugin-claude, plugin-cursor, or plugin-grok" >&2
    exit 2
    ;;
esac

files=()
if [ -f "$dir/SKILL.md" ]; then
  files+=("$dir/SKILL.md")
fi
if [ -d "$dir/scripts" ]; then
  for f in "$dir/scripts/"*.sh; do
    [ -f "$f" ] || continue
    files+=("$f")
  done
fi
if [ ${#files[@]} -eq 0 ]; then
  echo "error: no SKILL.md or scripts under $dir" >&2
  exit 1
fi

python3 - "$src" "${files[@]}" <<'PY'
import pathlib, sys
src = sys.argv[1]
for raw in sys.argv[2:]:
    path = pathlib.Path(raw)
    text = path.read_text()
    text = text.replace("${GANDER_SOURCE:-skill}", "${GANDER_SOURCE:-%s}" % src)
    text = text.replace("GANDER_SOURCE=skill", "GANDER_SOURCE=%s" % src)
    path.write_text(text)
PY
