# Sourced for all interactive shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

# Source files in .config/shellrc, .config/work/shellrc, and .config/local/shellrc

for subdir in '' work local; do
    if [[ -d $XDG_CONFIG_HOME/$subdir/shellrc ]]; then
        for MODULE in $XDG_CONFIG_HOME/$subdir/shellrc/*.sh; do
            source $MODULE
        done
    fi
done

# Read a local file if it exists.

if [[ -f ~/.rc_local.sh ]]; then
    source ~/.rc_local.sh
fi
