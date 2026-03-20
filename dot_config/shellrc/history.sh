if [[ -n $PS1 ]]; then
    if command -v atuin >/dev/null; then
        eval "$(atuin init $SHELL_TYPE)"
        if [[ $SHELL_TYPE == zsh ]]; then
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
        if [[ $SHELL_TYPE == bash ]]; then
            bind '"\e[A": history-search-backward'
        fi
    fi
fi
