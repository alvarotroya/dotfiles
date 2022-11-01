# If you come from bash you might have to change your $PATH.
export PATH=$PATH:~/.local/bin/:/usr/sbin

# Path to your oh-my-zsh installation.
export ZSH="/home/alvaro/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
ZSH_THEME="random"

# Blacklist ugly themes
ZSH_THEME_RANDOM_BLACKLIST=(aussiegeek bira darkblood dogenpunk duellj fino-time funky jonathan kiwi mikeh rkj rkj-repos rixius xiong-chiamiov-plus)

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
plugins=(git vi-mode)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
