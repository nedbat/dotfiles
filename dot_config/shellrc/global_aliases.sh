if [[ $SHELL_TYPE == zsh ]]; then
    alias -g ,G='| egrep '
    alias -g ,L='| wc -l'
    alias -g ,Q='2>/dev/null'
    # For those odd times we want to debug configuration that gets confused by XDG_* variables
    alias -g ,X='XDG_CONFIG_HOME= XDG_CACHE_HOME= XDG_DATA_HOME= XDG_STATE_HOME= '
    alias -g ,11='| head -n $(($(tput lines)-4))'
    alias -g ,1='--color=always ,11'
fi
