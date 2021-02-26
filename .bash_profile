# !! WARNING !!
# ENSURE this file only uses LF new lines, NOT CRLF

# Editing shortcuts
alias v='vim'
#alias sublime='open -a "/Applications/Sublime Text.app"'
#npp() {
#		# Verify you Notepad++ installation directory
#        /mnt/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe $* &
#}

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
alias g='git'
alias gk='git checkout'
alias gkb='git checkout -b'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v -a'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gm='git merge'
alias gdh='git diff HEAD'
alias gb='git branch'
alias gba='git branch -a' # list all
alias gbd='git branch -D' # delete branch
alias gbm='git branch -m' # rename branch
alias gcp='git commit -v -a && git push'
alias gpp='git pull; git push'
alias gf='git-flow'
alias gt='git stash'
alias gtl='git stash list'
alias gtc='git stash clear'
alias gtp='git stash push'
alias gta='git stash apply'
alias gto='git stash pop'
alias gsd='git svn dcommit'
alias gsr='git svn rebase'

# Terraform shortcuts
#alias tfe='terraform'

# Python shortcuts
alias python=python3
alias pip=pip3

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

# Must reinstall global packages if nvm node version changes
# e.g. nvm install v6.9.2 --reinstall-packages-from=v4.4.5 

NODE_VERSION=$(node -v)
PATH=/usr/local/n/versions/node/$NODE_VERSION/bin:$PATH

YARN_PATH=$(yarn global bin)
PATH=$YARN_PATH:$PATH

# For MacOS
#if [ -f `brew --prefix`/etc/bash_completion ]; then
#    . `brew --prefix`/etc/bash_completion
#fi
