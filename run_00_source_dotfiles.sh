#!/bin/sh
#
# Source our own dotfiles from the real ones.
for f in ~/.config/nedbat/.[a-z]*; do
    homef=~/$(basename $f)
    if ! grep -q "cznedbat" $homef 2>/dev/null; then
        echo "Sourcing $f from $homef"
        echo "source $f # cznedbat " >> $homef
    fi
done
