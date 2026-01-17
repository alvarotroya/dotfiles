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
# Always write history instantly (important for Atuin)
setopt inc_append_history
setopt share_history

setopt autocd extendedglob nomatch notify globdots
unsetopt beep
bindkey -v
# --------------------------------------------------
# Cursor shape for vi-mode (Powerlevel10k compatible)
# --------------------------------------------------

function _set_cursor_block() {
  printf '\033[2 q'
}

function _set_cursor_beam() {
  printf '\033[6 q'
}

function _vi_cursor_hook() {
  case $KEYMAP in
    vicmd) _set_cursor_block ;;
    viins|main) _set_cursor_beam ;;
  esac
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget keymap-select _vi_cursor_hook
add-zle-hook-widget line-init _set_cursor_beam

# Always fix cursor before each prompt (tmux + Ctrl-C safe)
precmd() {
  _set_cursor_beam
}

# Disable ':' execute prompt in vi normal mode
bindkey -M vicmd ':' undefined-key


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

# Keybindings for autosuggestions (AFTER plugin load)
if (( ${+widgets[autosuggest-accept-word]} )); then
  bindkey '^F' autosuggest-accept-word
  bindkey '^E' autosuggest-accept
fi

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
bindkey '^F' forward-word
bindkey '^G' forward-char

# Word-wise navigation (Meta / Option)
bindkey '^[b' backward-word
bindkey '^[f' forward-word

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

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh --disable-up-arrow)"
