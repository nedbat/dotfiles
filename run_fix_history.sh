#!/bin/zsh

# If we had shell history in the home directory, move it to the XDG locations.
if [ -f ~/.history ]; then
    mv -v ~/.history $XDG_STATE_HOME/shell_history
fi
