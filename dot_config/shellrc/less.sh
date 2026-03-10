# Make less more friendly.

export LESS=-isFJRQWX
export LESSHISTFILE=$XDG_STATE_HOME/lesshst

# On mac, more is already less, but on linux it's not, so alias it.
# Check the sizes of the files: if they are different, we need the alias.
if [ $(wc -c $(command -v less)) -ne $(wc -c $(command -v more)) ]; then
    alias more='less'
    export LESS_IS_MORE=1
fi
