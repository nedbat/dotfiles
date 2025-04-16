#!/bin/zsh

# If we had vim state in the home directory, move it to the XDG locations.
if [ -d ~/.backup ]; then
    mkdir -p $XDG_STATE_HOME/vim
    mv -v ~/.backup $XDG_STATE_HOME/vim/backup
fi

if [ -d ~/.vimundo ]; then
    mkdir -p $XDG_STATE_HOME/vim
    mv -v ~/.vimundo $XDG_STATE_HOME/vim/undo
fi

if [ -f ~/.viminfo ]; then
    mkdir -p $XDG_STATE_HOME/vim
    mv -v ~/.viminfo $XDG_STATE_HOME/vim/viminfo
fi

# If vim doesn't look in .config/ then symlink to get our stuff.
if ! vim --version | grep -q XDG_CONFIG_HOME; then
    echo linking vim config from home
    ln -sf $XDG_CONFIG_HOME/vim/vimrc ~/.vimrc
    ln -sf $XDG_CONFIG_HOME/vim ~/.vim
fi

# Install and/or update all the plugins.
vim --not-a-term +PlugInstall +PlugUpdate +qall
