# https://github.com/ajeetdsouza/zoxide
#
# Needs:
#   % brew install zoxide fzf

if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi
