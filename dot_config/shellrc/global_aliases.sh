if [[ $SHELL_TYPE == zsh ]]; then
    alias -g ,G='| egrep '
    alias -g ,L='| wc -l'
    alias -g ,Q='2>/dev/null'
fi
