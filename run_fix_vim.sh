#!/bin/sh

# If vim doesn't look in .config/ then symlink to get our stuff.
if ! vim --version | grep -q XDG_CONFIG; then
    ln -sf ~/.config/vim/vimrc ~/.vimrc
    ln -sf ~/.config/vim ~/.vim
fi
vim --not-a-term +PlugInstall +PlugUpdate +qall
