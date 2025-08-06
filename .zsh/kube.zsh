alias k="kubectl"
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"
alias kdl="kubectl delete"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kn="kubens"
alias kx="kubectx"
alias kedit="kubectl edit"
alias krsd="kubectl rollout restart deployment"

export dry="-o yaml -dry-run=client"

source <(kubectl completion zsh)
