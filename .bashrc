[ -t 0 ] && stty -ixon
[ -f /usr/share/bash_completion ] && . /usr/share/bash_completion

PS1='\h:\W \$ '
unset HISTFILE PROMPT_COMMAND TITLE

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

if [ -n "$ACMEVIMOUTBUF" ]; then
	prompt_command() {
		if [ "$AWD" != "$PWD" ]; then
			AWD="$PWD"
			avim -w "$ACMEVIMOUTBUF" "$AWD"
		fi
	}
	PROMPT_COMMAND=prompt_command
fi

shopt -s checkjobs
shopt -s checkwinsize

alias ls='ls -F'
