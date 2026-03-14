if [[ -n $PS1 ]]; then
    # https://github.com/cantino/mcfly
    #if command -v mcfly >/dev/null; then
    #    export MCFLY_RESULTS=30
    #    export MCFLY_HISTORY_LIMIT=50000
    #    eval "$(mcfly init $SHELL_TYPE)"
    #fi

    eval "$(atuin init $SHELL_TYPE)"
    # https://til.simonwillison.net/macos/atuin
    # updated to work on Linux over ssh
    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end
    # Works on Linux:
    bindkey "${terminfo[kcuu1]}" history-beginning-search-backward-end
    bindkey "${terminfo[kcud1]}" history-beginning-search-forward-end
    # Works on Mac:
    bindkey "^[[A" history-beginning-search-backward-end
    bindkey "^[[B" history-beginning-search-forward-end
fi
