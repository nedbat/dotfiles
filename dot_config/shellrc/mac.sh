if [[ "$(uname)" == 'Darwin' ]]; then
    zzz() {
        osascript -e 'tell application "System Events" to sleep'
    }
fi
