[ -t 0 ] && stty -ixon
[ -f /usr/share/bash_completion ] && . /usr/share/bash_completion

HISTCONTROL=ignoreboth
PROMPT_COMMAND=
PS1='\h:\W \$ '
TITLE=

case "$TERM" in
dumb)
	set +o emacs
	export GIT_PAGER=''
	export PAGER=''
	;;
xterm*|screen*)
	PS1='\[\e]0;$TITLE\a\]'"$PS1"
	;;
esac

if [ -n "$ACMEVIMBUF" ]; then
	prompt_command() {
		if [ "$AWD" != "$PWD" ]; then
			AWD="$PWD"
			avim -d "$ACMEVIMBUF" "$AWD"
		fi
	}
	PROMPT_COMMAND=prompt_command
fi

shopt -s checkjobs
shopt -s checkwinsize
shopt -s histappend

alias ls='ls -F'
