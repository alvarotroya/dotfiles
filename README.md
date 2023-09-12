# dotfiles

My configuration files, always a WIP.

## Setting things up

Clone down this directory and stow the config files you're interested in, e.g.

```
stow zsh -t ~/
```

will stow the zsh config files.

For zsh:
- Install powerline10K from here: https://github.com/romkatv/powerlevel10k
- Install zsh-autosuggestions from here: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone

## Everything below is outdated ^^

My dotfiles. i3gaps + vim + oh-my-zsh + tmux + dunst + arrow keys on home row.

## Personalization

### Set default terminal

1. `sudo update-alternatives --config x-terminal-emulator` 
2. sudo update-alternatives --config editor
3. gsettings set org.gnome.Terminal.Legacy.Settings confirm-close false

### Set customkeymaps

1. Right click on US-Flag and choose keyboard settings.
2. Enter custom setxkbmap options in input control.
3. Log out and in again.
4. Comment out the setxkbmap lines in the bin/customkeymaps file

### Vundle

1. Do `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
2. Start vim and run `:PluginInstall`

### YouCompleteMe

1. Install dependencies `sudo apt install build-essential cmake python3-dev`
2. Run `cd ~/.vim/bundle/YouCompleteMe && python3 install.py --clang-completer`

### Packages

- yadm, xcape, vim-gnome, chromium-browser, google-chrome

# vm-dotfiles
Dotfiles for local vm development environment

## Steps to automate

Install jetbrains-toolbox

`curl -s https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash`

Increase file watch

`sudo echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf && sudo sysctl -p --system`

Make gnome-terminal the default terminal emulator
`sudo update-alternatives --config x-terminal-emulator`

Install tmux

`sudo apt install tmux`

Install tpm

`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

Install vim-gnome

`sudo apt install vim-gnome`

Install vundle

`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

Create symbolic links for config files

Here, $CLONED_DIR stands for the **absolute path** of the directory where this repository has been cloned to.
`ln -s $CLONED_DIR/.ideavimrc ~/`

`ln -s $CLONED_DIR/.tmux.conf ~/`

`ln -s $CLONED_DIR/.bash_aliases ~/`

`ln -s $CLONED_DIR/.vimrc ~/`

Install gtk arc-dark theme

`sudo dpkg -i $CLONED_DIR/arc-theme/arc-theme_1488477732.766ae1a-0_all.deb`

Install openbox arc-dark theme

`obconf` and select *.obt file under `arc-theme`

# TODO

- [ ] Rewrite ideavimrc
- [ ] Include FiraCode font
- [ ] Include MacOS dotfiles
- [ ] Include X230 dotfiles
- [ ] Improve zsh setup
- [ ] Clean up README and bash_aliases
- [ ] Update README

