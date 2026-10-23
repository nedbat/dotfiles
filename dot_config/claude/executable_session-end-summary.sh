#!/bin/bash
# SessionEnd hook: write a fallback summary when the session ended without the
# "end session" wrap-up (which writes a summary containing the session id).

out_dir="$HOME/work/claude"
input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

[ -n "$session_id" ] || exit 0
mkdir -p "$out_dir"

if grep -qsF "$session_id" "$out_dir"/*.txt; then
    exit 0
fi

short_id=${session_id:0:8}
cat > "$out_dir/$(date +%F)-abrupt-exit-$short_id.txt" <<EOF
Session ended without a wrap-up; this summary was written automatically.
Directory: $cwd
Resume: claude --resume $session_id
EOF
