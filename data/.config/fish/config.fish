
#set fish_greeting ""

if [ -d "/snap/bin" ]
  set -g fish_user_paths $fish_user_paths /snap/bin
end

if [ -d "$HOME/.scripts" ]
  set -gx PATH $HOME/.scripts $PATH
end

if [ -d "$HOME/.cargo/bin" ]
  set -gx PATH $HOME/.cargo/bin $PATH
end

if [ -d "$HOME/.local/bin" ]
  set -gx PATH $HOME/.local/bin $PATH
end

if [ -d "$HOME/bin" ]
  set -gx PATH $HOME/bin $PATH
end

if type -q bat
  set -gx PAGER bat
else if type -q most
  set -gx PAGER most
end

if [ -d "$HOME/.pyenv" ]
  set -gx PATH $PATH $HOME/.pyenv/bin
  status --is-interactive; and source (pyenv init - | psub); and source (pyenv virtualenv-init - | psub)
end

alias p "cd"
alias u "ls"
alias ul "ls -lh"
alias ua "ls -lha"

#alias vpn 'cd ~/.config/vpn; and sudo ./airvpn_linux_x64_portable/airvpn'
alias vpn 'cd ~/.config/vpn/eddie-ui_2.16.3_linux_x64_portable; and sudo ./eddie-ui'
alias httpserver "twistd -no web --path=."
# alias wifuck 'sudo systemctl restart network-manager.service'

# Fix GPG password prompt dialog for Windows subsystem for linux
if [ (set -q WSLENV) ]
  set -g GPG_TTY (tty)
end

# finally colour output for gcc !
set -xg GCC_COLORS yes

# pyenv
if [ -d "$HOME/.pyenv" ]
  set -gx PATH $PATH $HOME/.pyenv/bin
  status --is-interactive; and source (pyenv init - | psub); and source (pyenv virtualenv-init - | psub)
end

# Rust
if [ -d "$HOME/.cargo/bin" ]
  set -gx PATH $HOME/.cargo/bin $PATH
end

# nvm
set NODE_VERSION v16.15.0
if [ -d "$HOME/.nvm" ]
  set -gx PATH $HOME/.nvm $PATH

  if [ -d "$HOME/.nvm/versions/node/$NODE_VERSION" ]
    set -gx PATH "$HOME/.nvm/versions/node/$NODE_VERSION/bin" $PATH
  end

end

### Bootstrap fisherman
# if not functions -q fisher
#     set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
#     curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
#     fish -c fisher
# end

### Sublime text auto-open .sublime-project files ###

alias subll (which subl)
function subl_autoload_project
  if test (count $argv) -eq 0
    set -l expected_project_file_name (basename (pwd)).sublime-project
    if test -e $expected_project_file_name
      subll $expected_project_file_name
      return $status
    end
  end
  subll $argv
  return $status
end

alias subl subl_autoload_project

### Virtual env is life ###

function ve
  set -l venv_name "venv"
  set -l venv_p "/usr/bin/python3"
  if test $argv[2]
      set venv_p $argv[1]
      set venv_name $argv[2]
  else
    if test $argv[1]
      set venv_name $argv[1]
    end
  end
  echo $venv_name

  if not test -d $venv_name
    echo "Creating $venv_name..."
    eval $venv_p -m venv $venv_name
    echo "Updating $venv_name..."
    eval $venv_name/bin/python -m pip install -U pip setuptools wheel
  end
  . ./$venv_name/bin/activate.fish
end

### Git ###

if not set -q __git_abbrs_initialized__
  set -U __git_abbrs_initialized__
  echo -n Setting GIT abbreviations... 

  abbr kk "kill %1; and fg" # Not git but whatever...

  abbr g "git"
  abbr ga "git add"
  abbr gc "git commit"
  abbr gcm "git commit -m"
  abbr gcam "git commit -am"
  abbr gcaa "git commit --amend --no-edit"
  abbr gsw "git show"
  abbr gr "git remote"
  abbr gf "git fetch"
  abbr gcl "git clone"
  abbr gcp "git cherry-pick"
  abbr gd "git diff"
  abbr gst "git stash"
  abbr gs "git status"
  abbr gpl "git pull"
  abbr gps "git push"
  abbr gr "git rebase"
  abbr gf "git fetch"
  abbr gm "git merge"
  abbr gco "git checkout"
  abbr gcb "git checkout -b"
  abbr gb "git branch --sort=-committerdate"
  abbr gbl "git blame"
  abbr gt "git tag"
  abbr gl 'git log'
  abbr gll 'git lg'
  abbr gll2 'git lg2'

  echo 'Done'
end

# Display disk

function disktree -d "Display directory usage"
  set -l path "."

  if count $argv > /dev/null
    if test (count $argv) -eq 1
      set path $argv[1]
    else
      echo "usage disktree [path]"
      return
    end
  end

  for x in $path/*
    du -sh $x
  end
end
