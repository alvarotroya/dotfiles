# --------------------------------------------------
# Powerlevel10k instant prompt (MUST stay at top)
# --------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------------------------------------------
# History & shell behavior
# --------------------------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

setopt autocd extendedglob nomatch notify globdots
unsetopt beep
bindkey -v

# --------------------------------------------------
# Completion paths (MINIMAL – Carapace does the work)
# --------------------------------------------------
fpath=(
  $HOME/.zfunc
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

# --------------------------------------------------
# Completion system
# --------------------------------------------------
autoload -Uz compinit edit-command-line
compinit -C

zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Completion UX (keep these – they affect Carapace too)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  '' \
  'm:{[:lower:]}={[:upper:]}' \
  'r:|[._-]=** r:|=**'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order \
  'main commands' \
  'alias commands' \
  'external commands'

# --------------------------------------------------
# Prompt
# --------------------------------------------------
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --------------------------------------------------
# Plugins & tools
# --------------------------------------------------
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zshenv ]] && source ~/.zshenv

# Autosuggestions
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# --------------------------------------------------
# Carapace (SOLE completion provider)
# --------------------------------------------------
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)

# --------------------------------------------------
# Keybindings
# --------------------------------------------------
bindkey '^H' backward-word
bindkey '^ ' forward-word

# --------------------------------------------------
# Node / NVM (lazy-loaded, fast startup)
# --------------------------------------------------
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() { nvm exec node "$@"; }
npm()  { nvm exec npm  "$@"; }
npx()  { nvm exec npx  "$@"; }

# --------------------------------------------------
# Cargo
# --------------------------------------------------
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# --------------------------------------------------
# Misc
# --------------------------------------------------
export BAT_THEME="base16"
