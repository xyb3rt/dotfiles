[ -t 0 ] && stty -ixon
[ -f /usr/share/bash_completion ] && . /usr/share/bash_completion

HISTCONTROL=ignoreboth
PROMPT_COMMAND=
PS1='\h:\W \$ '
TITLE=

case "$TERM" in
xterm*|screen*)
	PS1='\[\e]0;$TITLE\a\]'"$PS1"
	PS1='\[\e]7;file://$PWD\e\\\]'"$PS1"
	;;
esac

shopt -s checkjobs
shopt -s checkwinsize
shopt -s histappend

alias ls='ls -F'
