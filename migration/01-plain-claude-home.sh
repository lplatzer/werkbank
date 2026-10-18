#!/usr/bin/env bash
# Flip ~/.claude to a plain Claude Code home. LifeOS keeps running from its own
# profile at ~/.claude-lifeos (launch with `lifeos`).
#
# Run this with every Claude Code session closed: a live session keeps reading
# hooks and settings from ~/.claude, and its transcript would be split across
# the old and new directory.
#
# Nothing is deleted. The old ~/.claude is renamed to ~/.claude.pre-werkbank-<ts>
# and ~/.claude.json is backed up next to it before MCP servers are stripped.
set -euo pipefail

ts="$(date +%Y%m%d-%H%M%S)"
archive="$HOME/.claude.pre-werkbank-$ts"

[[ -f "$HOME/.claude-lifeos/settings.json" ]] || { echo "~/.claude-lifeos missing — migrate LifeOS first" >&2; exit 1; }
[[ -d "$HOME/.claude" && ! -L "$HOME/.claude" ]] || { echo "~/.claude is not a plain directory, nothing to flip" >&2; exit 1; }

if pgrep -x claude >/dev/null; then
  echo "Claude Code is still running:" >&2
  pgrep -xl claude >&2
  read -r -p "Continue anyway? [y/N] " ans
  [[ "$ans" == [yY] ]] || exit 1
fi

mv "$HOME/.claude" "$archive"
mkdir "$HOME/.claude"
echo "archived old ~/.claude -> $archive"

# ~/.claude.json carries the login account, onboarding state and project trust,
# which plain claude keeps. MCP servers and per-project tool allowlists go.
cp -p "$HOME/.claude.json" "$archive/claude.json.home-backup"
python3 - "$HOME/.claude.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as f:
    d = json.load(f)
removed = list(d.pop("mcpServers", {}) or {})
for proj in (d.get("projects") or {}).values():
    for key in ("mcpServers", "enabledMcpjsonServers", "disabledMcpjsonServers", "allowedTools"):
        proj.pop(key, None)
with open(path, "w") as f:
    json.dump(d, f, indent=2)
print("stripped MCP servers:", ", ".join(removed) or "none")
PY

echo
echo "Done. Check with:"
echo "  claude    # plain Claude Code, no hooks/skills/CLAUDE.md"
echo "  lifeos    # LifeOS; run /login once (separate keychain entry)"
echo "Once lifeos works, the archive can go: rm -rf '$archive'"
