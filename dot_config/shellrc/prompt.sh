# Set shell prompt, if we're interactive.
if [[ -n $PS1 ]]; then
    if command -v starship >/dev/null; then
        export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship.toml
        plain_prompt() {
            export PS1=$(printf "\n$ ")
        }
        fancy_prompt() {
            eval "$(starship init $SHELL_TYPE)"
        }
    else
        plain_prompt() {
            true
        }
        fancy_prompt() {
            true
        }
    fi
    fancy_prompt
fi
