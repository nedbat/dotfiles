#!/bin/bash
# Idempotent per-machine setup for the shared Claude config.
set -euo pipefail

config_dir="$HOME/.config/claude"
claude_md="$HOME/.claude/CLAUDE.md"
settings="$HOME/.claude/settings.json"
include_line="@~/.config/claude/nedbat-main.md"
hook_cmd='$HOME/.config/claude/session-end-summary.sh'

command -v jq > /dev/null || { echo "jq is required" >&2; exit 1; }
mkdir -p "$HOME/.claude"

if grep -qsxF "$include_line" "$claude_md"; then
    echo "CLAUDE.md: already includes shared file"
else
    echo "$include_line" >> "$claude_md"
    echo "CLAUDE.md: added include line"
fi

[ -s "$settings" ] || echo '{}' > "$settings"

if jq -e --arg cmd "$hook_cmd" \
    '[.hooks.SessionEnd[]?.hooks[]? | select(.command == $cmd)] | length > 0' \
    "$settings" > /dev/null; then
    echo "settings.json: SessionEnd hook already present"
else
    tmp=$(mktemp)
    jq --arg cmd "$hook_cmd" \
        '.hooks.SessionEnd += [{"matcher": "", "hooks": [{"type": "command", "command": $cmd, "timeout": 10}]}]' \
        "$settings" > "$tmp"
    mv "$tmp" "$settings"
    echo "settings.json: added SessionEnd hook"
fi
