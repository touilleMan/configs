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

if [ -d "$HOME/bin" ]
  set -gx PATH $HOME/bin $PATH
end

if [ -x "/usr/bin/most" ]
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
    eval $venv_p -m venv $venv_name
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

# stolen from https://github.com/joseluisq/gitnow
# git clone shortcut for Github repos
function gh -d "git clone shortcut for GitHub repos"
  set -l repo

  if count $argv > /dev/null
    if test (count $argv) -gt 1
      set repo $argv[1]/$argv[2]
    else if echo $argv | grep -q -E '^([a-zA-Z0-9\_\-]+)\/([a-zA-Z0-9\_\-]+)$'
      set repo $argv
    else
      set -l user (git config --global user.github)
      set repo $user/$argv
    end

    git clone git@github.com:$repo.git
  else
    echo
    echo "Repository name is required!"
    echo "E.g: gh your-repo-name"
    echo
    echo "Usages:"
    echo
    echo "  a) gh username/repo-name"
    echo "  b) gh username repo-name"
    echo "  c) gh repo-name"
    echo "     For this, it's necessary to set your Github username (login)"
    echo "     to global config before. You can type: "
    echo "     git config --global user.github \"your-github-username\""
    echo
  end
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
