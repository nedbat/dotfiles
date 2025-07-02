if [[ $SHELL_TYPE == zsh ]]; then
    alias -g ,G='| egrep '
    alias -g ,L='| wc -l'
    alias -g ,Q='2>/dev/null'
    alias -g ,11='| head -n $(($(tput lines)-4))'
    alias -g ,1='--color=always ,11'
fi
