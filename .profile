export BUILDKIT_PROGRESS=plain
export COMPOSE_ANSI=never
export EDITOR=vim
export LC_COLLATE=C
export LESS=-X
export MANWIDTH=80
export NO_COLOR=1

for _ in "$HOME/.vim/pack/xyb3rt/start/acme.vim/bin" "$HOME/.local/bin"; do
	case "$PATH" in
	"$_:"*|*":$_:"*) ;;
	*) export PATH="$_:$PATH" ;;
	esac
done

[ -e "$HOME/.profile.local" ] && . "$HOME/.profile.local"
