#!/bin/bash

function dir() {
    pushd "$(dirname "$0")" > /dev/null || exit
        pwd
    popd > /dev/null || exit
}

CURRENT_DIR="$(dir)"

ln -s "$CURRENT_DIR/.zshrc" "$HOME/.zshrc"
ln -s "$CURRENT_DIR/.zsh" "$HOME/.zsh"
