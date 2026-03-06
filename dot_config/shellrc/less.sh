# Make less more friendly.

export LESS=-isFJRQWX
export LESSHISTFILE=$XDG_STATE_HOME/lesshst

# On mac, more is already less, but on linux it's not, so alias it.
alias more='less'
export LESS_IS_MORE=1
