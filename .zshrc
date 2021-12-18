#!/bin/zsh

eval "$(starship init zsh)"

autoload -Uz compinit

typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)

if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist

source $HOME/.zsh/history.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/key-bindings.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/git_plugin.zsh
source $HOME/.zsh/completion.zsh
source $HOME/.zsh/utils.zsh
source $HOME/.zsh/emsdk.zsh
source $HOME/.zsh/autojump.zsh
source $HOME/.zsh/fnm.zsh
source $HOME/.zsh/kube.zsh

[ -d "$HOME/.zsh/lm" ] && source $HOME/.zsh/lm/lm.zsh

GOPATH=$(go env GOPATH)

PATH="$PATH:$HOME/bin:$GOPATH/bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:/usr/local/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/acordier/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/acordier/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/acordier/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/acordier/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/acordier/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/opt/libpq/bin:$PATH"

DL=$HOME/Downloads

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

