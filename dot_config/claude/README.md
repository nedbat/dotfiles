Shared Claude Code config. On each machine, run:
```
~/.config/claude/install.sh
```
It is safe to re-run. It:

- adds `@~/.config/claude/nedbat-main.md` to ~/.claude/CLAUDE.md
- adds a SessionEnd hook to ~/.claude/settings.json that runs
  session-end-summary.sh, which writes a fallback summary file in ~/work/claude
  if the session ended without an "end session" wrap-up

Requires `jq`.
