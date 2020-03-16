# dotfiles
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
2. Run ```cd ~/.vim/bundle/YouCompleteMe && python3 install.py --clang-completer`

### Packages

- yadm, xcape, vim-gnome, chromium-browser, google-chrome
