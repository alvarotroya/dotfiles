# Git
alias gs='git status'
alias gcm='git checkout master'
alias gc='git checkout'
alias gpm='git checkout master && git pull && git checkout -'

# Usual repositories in the gradle workspace (e.g. for git commands)
alias cda='cd ${GRADLE_WORKSPACE}/au-timemanagement'
alias cdab='cd ${GRADLE_WORKSPACE}/au-absencemanagement'
alias cdbs='cd ${GRADLE_WORKSPACE}/build-system'

# Usual submodules in au-absencemanagement (e.g. for OPA tests)
alias cdas='cd ${GRADLE_WORKSPACE}/au-absencemanagement/au-absencemanagement-sapui5-web'
alias cdap='cd ${GRADLE_WORKSPACE}/au-absencemanagement/au-absencemanagement-sap.sf.timemanagement.payoutAndPurchase-web/'
alias cdac='cd $(find $GRADLE_WORKSPACE/au-absencemanagement -maxdepth 1 ! -iname ".*" -type d -name "*sap*" | sort | fzf --header="Change to au-absencemanagement subdirectory")'

# Docker shortcuts
alias stop-all-docker-containers='docker stop $(docker ps -qa)'
alias remove-all-docker-containers='docker rm $(docker ps -qa)'
alias pause-all-docker-containers='docker pause $(docker ps -qa)'
alias unpause-all-docker-containers='docker unpause $(docker ps -qa)'

# Upgrade and migrate
alias upgrade-and-migrate-tomcat='gw upgradeTomcat -Dargs='"'"'-c attime -devMode'"'"' && gw migrateTomcat -Dargs='"'"'-c attime -devMode'"'"''

# K8s shortcuts
alias wpods='watch kubectl get pods'
alias cfpod='kubectl get pods | awk '"'"'{print $1}'"'"' | grep mybizx-cf'

# Common directories
alias cdrps='cd $(find $HOME/repos -maxdepth 1 ! -iname ".*" -type d | sort | fzf --header="Change to repos subdirectory")'
alias home='cd $(find $HOME -maxdepth 1 ! -iname ".*" \( -type l -o -type d \) | sort | fzf --header="Change to home subdirectory")'

# Commands with default options
alias xclip='xclip -selection c' # allows to paste from clipboard with <C-v>
alias aliasconfig='vim /home/alvaro-uni/.bash_aliases'
alias zshconfig='vim .zshrc'
alias gt='gnome-terminal'
alias polybarconfig='vim /home/alvaro-uni/.config/polybar/config'
alias rangerconfig='vim /home/alvaro-uni/.config/ranger/rc.conf'
alias rifleconf='vim /home/alvaro-uni/.config/ranger/rifle.conf'
alias vimconfig='vim /home/alvaro-uni/.vimrc'
alias work='ssh -p 42022 atroya@riemann.iwr.uni-heidelberg.de'
alias work2='ssh atroya@mnemosyne.iwr.uni-heidelberg.de'
alias open='xdg-open'
alias i3config='vim /home/alvaro-uni/.i3/config'
alias hibernate='sudo systemctl hibernate'
alias weather='curl wttr.in/Heidelberg'
alias weatherCompareFahrenheit="curl 'wttr.in/Heidelberg?u' && curl 'wttr.in/NewYork?u' && curl 'wttr.in/Quito?u'"
alias weatherCompareCelcius="curl 'wttr.in/Heidelberg?m' && curl 'wttr.in/NewYork?m' && curl 'wttr.in/Quito?m'"
alias findfile='sudo find . -type f -iname'
alias merge='sejda-console merge -f'
alias ..='cd ..'
alias ...='cd ...'
alias c++='clang++ -Weverything -g -std=c++11'
alias headphones="a2dp.py A4:15:66:5F:98:85"
alias rtbluetooth="rfkill unblock bluetooth && sleep 2 && sudo service bluetooth restart"
alias hci="sudo hciconfig hci0 up"
alias rtbluetoothOld="sudo service bluetooth restart"
#alias i3config="vim .config/i3/config"
alias modForms="cd ~/Dropbox/Modular\ forms/"
alias master="cd ~/Dropbox/Masterarbeit/src/"
alias mvim="vim --servername thesis.tex ~/Dropbox/Masterarbeit/src/thesis.tex"
alias Linvariant="cd /home/alvaro-uni/Dropbox/Modular\ forms/Linvariant/Linvariant"
#alias vim="gvim"
#alias vvim="vim"
alias f='find * -type f | fzf > selected'
#alias fluxAlias='xflux -l 49.3988 -g 8.6724 -k 2000'
alias tables='cd /home/alvaro-uni/Dropbox/Modular\ forms/Linvariant/Linvariant/notes/tables'
alias presentation="cd /home/alvaro-uni/Dropbox/Modular\ forms/Linvariant/Linvariant/notes/presentation"
alias fzy='ls -l $(find -type f | fzy)'
alias k='killall'
alias c='clear'
alias polybarhome='~/.config/polybar/launchhome.sh'
alias polybaruni='~/.config/polybar/launchuni.sh'
alias polybarlaptop='~/.config/polybar/launchlaptop.sh'
#alias ipadhome='~/bin/ipad.sh -r -h'
#alias ipadsala='~/ipadsala.sh -b -h'
#alias ipaduni='~/ipad.sh -r -v'
alias ipadlaptop='~/bin/ipad.sh -r -l'
alias screenlayouthome='~/.screenlayout/home.sh'
alias screenlayoutuni='~/.screenlayout/uni.sh'
alias screenlayoutlaptop='~/.screenlayout/laptop.sh'
alias rofiAlias='rofi -combi-modi window,drun -show combi -color-window "#000000, #000000, #000000" -color-normal "#000000, #b3e774, #000000, #b3e774, #000000" -color-active "#000000, #b3e774, #000000, #b3e774, #000000" -color-urgent "#000000, #b3e774, #000000, #b3e774, #000000"'

aur() {
    git clone https://aur.archlinux.org/"$1".git
}

###############fzf-finder-scripts############################I
p () {
    local DIR open
    declare -A already
    DIR="${HOME}/.cache/pdftotext"
    mkdir -p "${DIR}"
    if [ "$(uname)" = "Darwin" ]; then
        open=open
    else
        open="zathura"
    fi

    {
    ag -g ".pdf$" --ignore ~/Dropbox/Natalia; # fast, without pdftotext
    ag -g ".pdf$" --ignore ~/Dropbox/Natalia  \
    | while read -r FILE; do
        local EXPIRY HASH CACHE
        HASH=$(md5sum "$FILE" | cut -c 1-32)
        # Remove duplicates (file that has same hash as already seen file)
        [ ${already[$HASH]+abc} ] && continue # see https://stackoverflow.com/a/13221491
        already[$HASH]=$HASH
        EXPIRY=$(( 86400 + $RANDOM * 20 )) # 1 day (86400 seconds) plus some random
        CMD="pdftotext -f 1 -l 1 '$FILE' - 2>/dev/null | tr \"\n\" \"_\" "
        CACHE="$DIR/$HASH"
        test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "$CACHE" +%s)) -le $EXPIRY ] || eval "$CMD" > "${CACHE}"
        echo -e "$FILE\t$(cat ${CACHE})"
    done
    } | fzf -e  -d '\t' \
        --preview-window up:75% \
        --preview '
                v=$(echo {q} | tr " " "|");
                echo {1} | grep -E "^|$v" -i --color=always;
                pdftotext -f 1 -l 1 {1} - | grep -E "^|$v" -i --color=always' \
        | awk 'BEGIN {FS="\t"; OFS="\t"}; {print "\""$1"\""}' \
        | xargs $open > /dev/null 2> /dev/null
} 

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# cf - fuzzy cd from anywhere
cf() {
  local file

  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
