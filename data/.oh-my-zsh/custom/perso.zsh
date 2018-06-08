# Put your fun stuff here.eval
`gnome-keyring-daemon --start`

#export EDITOR='subl -n -w'

alias ul='ls --color=auto --classify -lh'
alias ua='ls --color=auto --classify -a'
alias u='ls --color=auto --classify'
alias p='cd'

alias -s pdf="okular "
alias -s txt="nano "
alias -s avi="vlc "
alias -s mkv="vlc "

alias -s jpg="eom "
alias -s jpeg="eom "
alias -s png="eom "

alias clean='find . -name "*~" -delete -print'
alias prince='dosbox -c "cd PRINCE" -c "PRINCE.EXE"'
alias prince2='dosbox -c "cd PRINCOP2" -c "PRINCE.EXE"'
alias tie='dosbox -c "cd TIE" -c "TIE.EXE"'
alias duke='cd ~/.eduke32/ && ./eduke32'

alias fullgit='git fetch && git stash && git rebase && git stash pop'

alias todo2='todo2 --file=$HOME/.config/todo2'

alias tc='truecrypt ~/Documents/.emmanuel_crypted_big.tc ~/tc'
alias tck='truecrypt -d && touch ~/Documents/.emmanuel_crypted_big.tc'

alias httpserver='twistd -no web --path=. -p 8000'

alias web='chromium-browser'

# add custom script to program list
export PATH="$PATH:$HOME/.scripts"
# export PYTHONPATH=/usr/local/lib/python2.7/dist-packages
export GOPATH=$HOME/.gopath
export PATH="$PATH:$HOME/projects/go/bin"
export PATH=$PATH:$HOME/.config/delation

### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/heroku/bin"
export PATH="$PATH:$HOME/.config/npm/bin"

### Awesome sam&max stuff !
export PYTHONSTARTUP=$HOME/.config/python_shell_conf.py

export PATH=$HOME/.config/bin:$PATH

alias godot=$HOME/.godot/godot

# finally colour output for gcc !
export GCC_COLORS=yes

alias wifuck='sudo systemctl restart network-manager.service'

# Stop closing term with ^D
set -o ignoreeof

alias mkvenv='virtualenv -p /usr/bin/python3 venv && . ./venv/bin/activate'
alias venv='. ./venv/bin/activate'

alias vpn='cd ~/.config/vpn && sudo ./airvpn_linux_x64_portable/airvpn'
alias upy=~/projects/micropython/unix/micropython

alias tdp="td n '[PARSEC]' $@"
alias httpserver="twistd -no web --path=."
