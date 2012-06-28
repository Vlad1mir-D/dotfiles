# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell
# save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist
shopt -s no_empty_cmd_completion

#disable Ctrl+s freeze
stty -ixon
# this is for delete words by ^W
tty -s && stty werase ^- 2>/dev/null

if [[ $OSTYPE =~ "linux" || $OSTYPE =~ "cygwin" ]]; then
	alias ls="ls --color=auto"
	alias duh='du -h --max-depth=0'
	alias free='free -m'
elif [[ $OSTYPE =~ "freebsd" ]]; then
	#bsd colorize
	export CLICOLOR=1
	export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"

	alias duh='du -h -d 0'
	alias llw='ls -liahW'
fi

alias ll='ls -liahs'
alias rmrf='rm -rf'
alias cls="clear"
#alias :q="exit"
#alias ..="cd .."
alias killa='killall -KILL'
alias killk='kill -KILL'
alias sudo='sudo ' #to respect all aliases
alias tracert="sudo traceroute -I"

# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

# don't put duplicate lines in the history
export HISTCONTROL=ignoreboth,erasedups
# set history length
HISTFILESIZE=1000000000
HISTSIZE=1000000

# grep colorize
export GREP_OPTIONS="--color=auto"

export EDITOR="vim"

#X11 && X11Forwarding handling
if [[ -z $DISPLAY ]]; then
	[[ -n $SSH_TTY ]] && export DISPLAY="localhost:10.0" || export DISPLAY=":0"
fi
[[ -z $XAUTHORITY && -n $SSH_TTY ]] && export XAUTHORITY=$HOME/.Xauthority

# setup color variables
color_is_on=
color_red=
color_green=
color_yellow=
color_blue=
color_white=
color_gray=
color_bg_red=
color_off=
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_is_on=true
	color_red="$(/usr/bin/tput setaf 1)"
	color_green="$(/usr/bin/tput setaf 2)"
	color_yellow="$(/usr/bin/tput setaf 3)"
	color_blue="$(/usr/bin/tput setaf 6)"
	color_white="$(/usr/bin/tput setaf 7)"
	color_gray="$(/usr/bin/tput setaf 8)"
	color_off="$(/usr/bin/tput sgr0)"
	color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
	color_error_off="$(/usr/bin/tput sgr0)"
fi

#sync stuff
up_environ_(){
	if [[ $forbid_environ_up_ -gt 0 ]]; then
		echo "Environment update forbidden!" >&2
		return 1
	fi

	local cwd=$PWD rnd=$RANDOM rights="" dst=
	local src="https://www.lnetw.ru/environ.tar.bz2"
	local dst="lnetw_environ_$rnd.tar.bz2"

	cd ~
	if [[ $OSTYPE =~ "freebsd" ]]; then
		rights=$(stat -f '%p' ./ | rev | sed -E 's/([[:digit:]]{4}).*/\1/' | rev)
	else
		rights=$(stat -c '%a' ./)
	fi

	wget -c -O "$dst" "$src"
	if [ -s $dst ]; then
		tar jxfv "$dst" --no-same-permissions --no-same-owner
		. ~/.bash_profile
		[[ -n $rights ]] && $(chmod $rights ./)
	else
		echo "Failed to retrieve $src" 1>&2
	fi

	[ -f "$dst" ] && rm "$dst"
	cd "$cwd"
}

#some stuff
md(){ mkdir -p "$@" && cd "$@"; }
[[ $OSTYPE =~ "cygwin" ]] || ps(){ /bin/ps "$@" -ww; }

function update_PS_ {
	if [[ -z $dlen_ ]]; then
		dlen_=$(date +"%a, %d.%m.%y %T %z" | wc -m)
	fi

	local ucolor="\e[32m"
	if [[ "${USER}" == "root" ]]; then
		ucolor="\e[31m"
	fi
	local hcolor="\e[32m"
	[[ -n $SSH_TTY && -z $is_local_ ]] && hcolor="\e[36m"
	local time="\e[$(($COLUMNS-$dlen_))G(\D{%a, %d.%m.%y %T %z})"
	local mainPrompt="[${ucolor}\u${hcolor}@\h:\e[33m\w\e[0m] ($(($SHLVL-1)):\#)$time"
	local flen=${#mainPrompt}
	local termTitle=""
	[[ $TERM != "linux" ]] && termTitle="\[\e]0;[\u@\h:\w]$\a"
	export PS1="${termTitle}\n${mainPrompt}\n# "
}

function prompt_command_ {
	update_PS_
	if [[ $OSTYPE != "cygwin" && 0 -ne 0 ]]; then
		# get cursor position and add new line if we're not in first column
		exec < /dev/tty
		local OLDSTTY=$(stty -g)
		stty raw -echo min 0
		echo -en "\033[6n" > /dev/tty && read -sdR CURPOS
		stty $OLDSTTY
		[[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"
	fi
}
PROMPT_COMMAND=prompt_command_

# bash local
ls -1 ~/.bash_local.* > /dev/null 2>&1
if [ $? -eq 0  ]; then
	for bash_local_ in ~/.bash_local.*; do . "$bash_local_"; done
fi

if [ -f ~/.bash_local ]; then
	. ~/.bash_local
fi

