# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
zstyle :compinstall filename '/home/alvaro/.zshrc'

# ------------------------------
# Completion paths (FIRST)
# ------------------------------
fpath=(
  $HOME/.docker/completions
  $HOME/.zsh/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

# ------------------------------
# Init completion system
# ------------------------------
autoload -Uz compinit
compinit -C

autoload -U edit-command-line
zle -N edit-command-line 
bindkey -M vicmd v edit-command-line

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt autocd extendedglob nomatch notify globdots
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zshenv ] && source ~/.zshenv
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# [ -f ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh ] && source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# ZSH autosuggestions config
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^H' backward-word
bindkey '^ ' forward-word

# Cargo
[ -f ~/.cargo/env ] && source ~/.cargo/env

export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() { nvm exec node "$@"; }
npm()  { nvm exec npm  "$@"; }
npx()  { nvm exec npx  "$@"; }

zstyle ':completion:*' menu select
fpath+=~/.zfunc

source <(fzf --zsh)

# kubectl completion
source <(kubectl completion zsh)

export BAT_THEME="base16"

. "$HOME/.cargo/env"
FPATH="$HOME/.docker/completions:$FPATH"
FPATH="$HOME/.zsh/zsh-completions:$FPATH"

# ${UserConfigDir}/zsh/.zshrc
autoload -U compinit && compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

# Setup zoxide
eval "$(zoxide init zsh)"
