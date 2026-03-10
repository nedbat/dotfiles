if [[ "$(uname)" == "Linux" ]]; then
    # On mac, more is already less, but on linux it's not, so alias it.
    alias more='less'
    export LESS_IS_MORE=1
fi
