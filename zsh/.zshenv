export GOPATH=/usr/local/bin/go
export DAVID_TENGO_BIN=$HOME/repos/tengo
export GOLIAT=$HOME/repos/qm/goliat
export PR_BRANCH=$HOME/repos/qm/pr_branch
export DOTFILES=$HOME/repos/mine/dotfiles
export PATH=$PATH:$GOLIAT

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
