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

if [ -n "$VIM_TERMINAL" ]; then
	__vim_term_pwd__() {
		printf '\033]51;["call", "Tapi_lcd", "%q"]\007' "$PWD"
	}
	PROMPT_COMMAND=__vim_term_pwd__
fi

shopt -s checkjobs
shopt -s checkwinsize

alias ls='ls -F'
