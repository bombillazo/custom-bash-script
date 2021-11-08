# !! WARNING !!
# ENSURE this file only uses LF new lines, NOT CRLF
# Make sure your terminal as login shells
# Ubuntu Terminal: Preferences -> Profiles -> Command -> 'Run comand as login shell'

# Editing shortcuts
alias v='vim'
#alias sublime='open -a "/Applications/Sublime Text.app"'
#npp() {
#		# Verify you Notepad++ installation directory
#        /mnt/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe $* &
#}

# Openning a directory from terminal
open() {
	if [[ "$@" == "" ]]; then
		nautilus . &>/dev/null
		return
	fi
	nautilus "$@" &>/dev/null
}


# Listing files shorcuts
alias mv='mv -i'
alias rm='rm -i'
alias l='ls -al'
alias ltr='ls -ltr'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'

# Composer shortcuts
#alias composer="php /usr/local/bin/composer.phar"

# Docker shortcuts
alias dkcb='docker-compose build'
alias dkclogs='docker-compose logs'
alias dkcu='docker-compose up'
# entity based aliases
alias dki='docker image'
alias dkc='docker container'
alias dkn='docker network'
alias dkv='docker volume'
alias dkp='docker port'
# command based aliases
alias dkb='docker build'
alias dkatt='docker attach'
alias dkcr='docker create'
alias dkrun='docker run'
alias dkstart='docker start'
alias dkrestart='docker restart'
alias dkstop='docker stop'
alias dkkill='docker kill'
alias dkps='docker push'
alias dkpl='docker pull'
alias dkrm='docker rm'
alias dkins='docker inspect'
alias dkdiff='docker diff'

# Git shortcuts
#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function current_branch() {
  git_current_branch
}

# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}

# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo develop
}

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcsm='git commit -s -m'
alias gcas='git commit -a -s'
alias gcasm='git commit -a -s -m'
alias gcb='git checkout -b'
alias gcf='git config --list'

function gccd() {
  command git clone --recurse-submodules "$@"
  [[ -d "$_" ]] && cd "$_" || cd "${${_:t}%.git}"
}

alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dffx'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout $(git_develop_branch)'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gcss='git commit -S -s'
alias gcssm='git commit -S -s -m'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'

function gdnolock() {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}

function gdv() {
  git diff -w "$@" | view -
}

alias gf='git fetch'
alias gfo='git fetch origin'

alias gfg='git ls-files | grep'

alias gg='git gui citool'
alias gga='git gui citool --amend'

function ggf() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force origin "${b:=$1}"
}

function ggfl() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force-with-lease origin "${b:=$1}"
}

function ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}

function ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}

function ggpnp() {
  if [[ "$#" == 0 ]]; then
    ggl && ggp
  else
    ggl "${*}" && ggp "${*}"
  fi
}

function ggu() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}

alias ggpur='ggu'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

alias ghh='git help'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

alias gk='\gitk --all --branches &!'
alias gke='\gitk --all $(git log -g --pretty=%h) &!'

alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp="_git_log_prettily"

alias gm='git merge'
alias gmom='git merge origin/$(git_main_branch)'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'
alias gma='git merge --abort'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpr='git pull --rebase'
alias gpu='git push upstream'
alias gpv='git push -v'

alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'

alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'

alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gstall='git stash --all'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch -c'
alias gswm='git switch $(git_main_branch)'
alias gswd='git switch $(git_develop_branch)'

alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'
alias glum='git pull upstream $(git_main_branch)'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

# Terraform shortcuts
#alias tfe='terraform'

# Python shortcuts
alias python=python3
alias pip=pip3

## HELP for shortcuts

shortcuts ()
{
	BLUE='\033[38;5;45m'
	NC='\033[0m' # No Color
	BOLD='\033[1m'
	echo ''
	echo -e '** Keyboard Shortcuts **'
	echo -e "$BOLD$BLUE VS Code $NC: CTRL + ] and CTRL + [ : Switch terminals (when focused in terminal)"
	echo ''
}

## BASTION CONNECT

# bastion echo environment
bee ()
{
  echo $BASTION_ACCOUNT
}

# bastion change environment
bce ()
{
  if [[ $BASTION_ACCOUNT == "production" ]]; then
    echo "Switching bastion env to development";
    . ~/.aws/bastion_dev;
  else
    echo "Switching bastion env to production";
    . ~/.aws/bastion_prod;
  fi
}

# bastion key push
bkp ()
{
  echo "Pushing key to bastion: $BASTION_PROFILE - $BASTION_ACCOUNT ...";
  kp $BASTION_PROFILE $BASTION_INSTANCE_ID $BASTION_AZ
}

# key push
kp ()
{
  aws-okta exec $1 -- aws ec2-instance-connect send-ssh-public-key --region us-east-1 --instance-id $2 --availability-zone $3 --instance-os-user ec2-user --ssh-public-key file://~/.ssh/id_rsa.pub
}

# connect to bastion instance
bc ()
{
  echo "Connecting to bastion: $BASTION_PROFILE - $BASTION_ACCOUNT ...";
  ssh -i my_rsa_key $BASTION_USER@$BASTION_DNS
}

# connect to RDS Aurora
ssh-a ()
{
  sshuttle -r $BASTION_USER@$BASTION_DNS 0.0.0.0/0:3306 -v
}

# connect to RedShift
ssh-r ()
{
  sshuttle -r $BASTION_USER@$BASTION_DNS 0.0.0.0/0:5439 -v
}

## DOCKER

# docker entity initialization
declare -A docker_entities=(
	["c"]="container"
	["i"]="image"
	["n"]="network"
	["v"]="volume"
)

# docker commands info
dk-info()
{
	echo "Valid Docker entities:"
	for i in "${!docker_entities[@]}"; do 
	  printf "%s = %s\n" "$i" "${docker_entities[$i]}"
	done
}

# docker list
dk-ls ()
{
	if [[ "$1" == "" ]]; then
		echo "Error:"
		echo "\"dk-ls\" requires a first argument specifying the docker entity."
		dk-info
		return
	fi

	entity=${docker_entities[$1]}

	if [[ "$entity" == "" ]]; then
		echo "Error:"
		echo "$1 is not a supported \"dk-ls\" entity."
		dk-info
	elif [[ "$1" == "c" || "$1" == "i" ]]; then
		docker $entity ls -a $2
	else
		docker $entity ls $2
	fi
}

# docker list quiet
dk-lsq ()
{
	dk-ls $1 -q
}

# docker stop all containers
dk-stc()
{
	docker container stop $(dk-lsq c)
}

# docker remove all containers
dk-rmc()
{
	dk-rm c -a
}

# docker remove all images
dk-rmi()
{
	dk-rm i -a
}

# docker inspect
dk-in() {
	if [[ "$1" == "" ]]; then
		echo "Error:"
		echo "\"dk-in\" requires a first argument specifying the docker entity."
		dk-info
		return
	fi

	entity=${docker_entities[$1]}

	if [[ "$entity" == "" ]]; then
		echo "Error:"
		echo "$1 is not a supported \"dk-in\" entity."
		dk-info
		return
	fi

	if [[ "$2" != "" ]]; then
		docker $entity inspect $2
	else
		docker $entity inspect $(dk-lsq $1)
	fi
}

# docker remove
dk-rm() {
	if [[ "$1" == "" ]]; then
		echo "Error:"
		echo "\"dk-rm\" requires a first argument specifying the docker entity."
		dk-info
		return
	fi

	entity=${docker_entities[$1]}

	if [[ "$entity" == "" ]]; then
		echo "Error:"
		echo "$1 not a supported \"dk-rm\" entity."
		dk-info
	fi

	if [[ "$2" == "-a" ]]; then
		docker $entity rm $(dk-lsq $1)
	elif [[ "$2" != "" ]]; then
		docker $entity rm $2
	else
		echo "Error:"
		echo "\"dk-rm\" requires a second argument specifying the $entity to be removed."
		echo "Run \"dk-rm $1 -a\" to remove all available ${entity}s"
	fi
}

# docker prune
dk-pr() {
	entity=${docker_entities[$1]}

	if [[ "$entity" == "" ]]; then
		docker system prune -af --volumes
	else
		docker $entity prune -f
	fi
}

## TERMINAL CUSTOMIZATION

# COLOR STRINGS
HOST_COLOR="\[\e[38;5;70m\]"
USER_COLOR="\[\e[1;97m\]"
PATH_COLOR="\[\e[0;38;5;123m\]"
 GIT_COLOR="\[\e[1;38;5;220m\]"

function gitprompt () {
	local gitbranch=$(git branch 2>&1 | grep '\*' | sed -e 's/\* //g')
	if [[ "$gitbranch" != "" ]]; then
      PS1="${HOST_COLOR}\h ${USER_COLOR}[\u] ${PATH_COLOR}\w ${GIT_COLOR}(${gitbranch}) \[\e[00m\]\n$ "
    else
      PS1="${HOST_COLOR}\h ${USER_COLOR}[\u] ${PATH_COLOR}\w \[\e[00m\]\n$ "
    fi
}
PROMPT_COMMAND=gitprompt

## ENVIRONMENT SETUP
# Must reinstall global packages if nvm node version changes
# e.g. nvm install v6.9.2 --reinstall-packages-from=v4.4.5 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

NODE_VERSION=$(node -v)
PATH=/usr/local/n/versions/node/$NODE_VERSION/bin:$PATH

YARN_PATH=$(yarn global bin)
PATH=$YARN_PATH:$PATH

# For MacOS
#if [ -f `brew --prefix`/etc/bash_completion ]; then
#    . `brew --prefix`/etc/bash_completion
#fi
