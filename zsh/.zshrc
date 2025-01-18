# ZELLIJ
# eval "$(zellij setup --generate-auto-start zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -v TMUX && $TERM_PROGRAM != "vscode" ]]; then
	tmux_chooser && exit
fi

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
zstyle :compinstall filename '/home/alvaro/.zshrc'

autoload -U edit-command-line
zle -N edit-command-line 
bindkey -M vicmd v edit-command-line

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
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
bindkey '^L' forward-word

# Cargo
[ -f ~/.cargo/env ] && source ~/.cargo/env

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/alvaro/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/alvaro/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/alvaro/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/alvaro/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/alvaro/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/home/alvaro/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# UV base environment
[ -f ~/.venv/bin/activate ] && source ~/.venv/bin/activate


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm zsh_completion

zstyle ':completion:*' menu select
fpath+=~/.zfunc

source <(fzf --zsh)

export BAT_THEME="base16"

. "$HOME/.cargo/env"
FPATH="$HOME/.docker/completions:$FPATH"
autoload -Uz compinit
compinit
