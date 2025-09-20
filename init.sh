#!/bin/bash

function installStarship() {
    curl -fsSL https://starship.rs/install.sh | sh
}

function cloneModules() {
    pushd .zsh || exit
        git clone git@github.com:zdharma/fast-syntax-highlighting.git
        rm -rf fast-syntax-highlighting/.git
        git clone git@github.com:zsh-users/zsh-autosuggestions.git
        rm -rf zsh-autosuggestions/.git
    popd || exit
}

function main() {
    installStarship && cloneModules
}

main