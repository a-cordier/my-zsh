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
source $HOME/.zsh/ssl_trust.zsh
source $HOME/.zsh/emsdk.zsh
source $HOME/.zsh/autojump.zsh

# temporary
[ -d "$HOME/.zsh/lm" ] && source $HOME/.zsh/lm/lm.zsh

PATH="$PATH:$HOME/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/acordier/exec -l /bin/zsh/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/acordier/exec -l /bin/zsh/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/acordier/exec -l /bin/zsh/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/acordier/exec -l /bin/zsh/google-cloud-sdk/completion.zsh.inc'; fi

function nvm_configure() {
  export NVM_DIR="/Users/acordier/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}

GOPATH=$(go env GOPATH)
