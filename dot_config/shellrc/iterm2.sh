# iTerm2 aliases.

#alias i2clear="printf '\e]50;ClearScrollback\a'"
#alias i2focus="printf '\e]50;StealFocus\a'"
#alias i2profile="printf '\e]50;SetProfile=%s\a'"
#i2toast() {
#    echo -ne "\033]9;$@\007"
#}

if [[ -n "$ITERM_PROFILE" || "$LC_TERMINAL"x == "iTerm2x" ]]; then
    alias k="printf '\e]50;ClearScrollback\a'"
else
    alias k='clear'
fi

alias sep='printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n========================================================================================================================\n"'
