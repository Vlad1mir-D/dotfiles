# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell
# save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist

#disable Ctrl+s freeze
stty -ixon
# this is for delete words by ^W
tty -s && stty werase ^- 2>/dev/null

alias ll='ls -liahs --color=auto'
alias rmrf='rm -rf'
alias duh='du -h --max-depth=0'
#alias fclzma='fusecompress -o fc_c:lzma,nonempty,allow_other'
alias cls="clear"
alias :q="exit"
alias ..="cd .."

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
export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PERL5LIB="$HOME/perl5/lib/perl5/x86_64-linux-thread-multi:$HOME/perl5/lib/perl5";
export PATH="$HOME/perl5/bin:$PATH";
export DISPLAY=localhost:10.0
export XAUTHORITY=$HOME/.Xauthority

mvln(){
	mv $1 $2
	ln -s $2$1 ./
}

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
    color_red="\[$(/usr/bin/tput setaf 1)\]"
    color_green="\[$(/usr/bin/tput setaf 2)\]"
    color_yellow="\[$(/usr/bin/tput setaf 3)\]"
    color_blue="\[$(/usr/bin/tput setaf 6)\]"
    color_white="\[$(/usr/bin/tput setaf 7)\]"
    color_gray="\[$(/usr/bin/tput setaf 8)\]"
    color_off="\[$(/usr/bin/tput sgr0)\]"
    color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
    color_error_off="$(/usr/bin/tput sgr0)"
fi

function prompt_command {
    # get cursor position and add new line if we're not in first column
    exec < /dev/tty
    local OLDSTTY=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty && read -sdR CURPOS
    stty $OLDSTTY
    [[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"
}
PROMPT_COMMAND=prompt_command

# bash local
if [ -f ~/.bash_local ]; then
	. ~/.bash_local
fi

