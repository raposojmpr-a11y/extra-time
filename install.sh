#!/data/data/com.termux/files/usr/bin/bash
# install.sh — installs EXTRA TIME (agent squad) (shared memory + delegate + usage-report)
# Run it in Termux or inside proot-distro Ubuntu. It never deletes anything: existing files are kept
# and the instruction blocks are only appended once.
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
TH=${SQUAD_HOME:-/data/data/com.termux/files/home}
TP=${SQUAD_PREFIX:-/data/data/com.termux/files/usr}
SH=$TH/shared
MARK="<!-- agent-squad -->"

if [ "${container:-}" = proot-distro ]; then CLAUDE_DIR=/root/.claude
else CLAUDE_DIR=$TP/var/lib/proot-distro/containers/ubuntu/rootfs/root/.claude; fi
[ -n "${SQUAD_CLAUDE_DIR:-}" ] && CLAUDE_DIR=$SQUAD_CLAUDE_DIR

echo "→ Shared memory in $SH"
mkdir -p "$SH/topics" "$SH/archive" "$SH/bin"
for f in delegate usage-report balance; do
  if [ -f "$SH/bin/$f" ] && ! cmp -s "$HERE/bin/$f" "$SH/bin/$f"; then
    cp "$SH/bin/$f" "$SH/bin/$f.old"; echo "  (previous version kept as $SH/bin/$f.old)"; fi
  install -m 755 "$HERE/bin/$f" "$SH/bin/$f"
done
[ -f "$SH/MEMORY.md" ] || cp "$HERE/templates/MEMORY.md" "$SH/MEMORY.md"
[ -f "$SH/topics/token-usage.md" ] || cp "$HERE/templates/topics/token-usage.md" "$SH/topics/"

block() {  # block <agent> <emoji> <name>
  sed -e "s/{AGENT}/$1/g" -e "s/{EMOJI}/$2/g" -e "s/{NAME}/$3/g" "$HERE/templates/agent-block.md"
}
append() {  # append <file> <text>
  local F=$1; mkdir -p "$(dirname "$F")"; touch "$F"
  if grep -qF "$MARK" "$F"; then echo "  $F already has the block — unchanged"; return; fi
  printf '\n%s\n%s\n' "$MARK" "$2" >> "$F"; echo "  block appended to $F"
}

echo "→ Agent instructions"
append "$TH/.codex/AGENTS.md" "At the start of every session read $SH/MEMORY.md.
$(block codex 🟢 Codex)"
append "$TH/.gemini/GEMINI.md" "@$SH/MEMORY.md
$(block gemini 🔵 Gemini)"
if [ -d "$(dirname "$CLAUDE_DIR")" ]; then
  append "$CLAUDE_DIR/CLAUDE.md" "@$SH/MEMORY.md
$(block claude 🟠 Claude)"
else
  echo "  proot-distro Ubuntu not found — Claude instructions not installed (set SQUAD_CLAUDE_DIR)"
fi
echo "✔ Done. Edit $SH/MEMORY.md (User and Environment sections) and try: $SH/bin/delegate --status"
