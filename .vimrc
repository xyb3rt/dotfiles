set autoindent copyindent
set autoread
set backspace=indent,eol,start
set directory=~/.cache/vim/swap//
set display=lastline
set noequalalways
set hidden
set hlsearch incsearch
set ignorecase smartcase
set nojoinspaces
set nomodeline
set mouse=a ttymouse=sgr
set noruler showcmd
set showmatch
set wildmode=longest,list

if 1 " +eval

filetype off
syntax off
hi Visual ctermbg=7 ctermfg=none

let g:acme_plumbing = [
	\ ['<https?\:\/\/(\f|[-.~!*();:@&=+$,/?#%]|\[|\])+', {m ->
		\ AcmePlumb('', 'setsid xdg-open', m[0])}],
	\ ['(\f{-1,})\s*\((\d\a*)\)', {m ->
		\ AcmePlumb(m[1].'('.m[2].')', 'man', m[2], m[1])}],
	\ ['(\f|[@{}~^])*\.\.\.?(\f|[@{}~^])*', {m ->
		\ AcmePlumb('git:'.m[0], 'git log -s --left-right', m[0])}],
	\ ['(\f|[@{}~^])+', {m ->
		\ AcmePlumb('git:'.m[0], 'git show --format=fuller -p --stat '.
			\ '--decorate', m[0])}],
	\ ['\f+', {m -> m[0] !~ '/' && AcmeOpen(exepath(m[0]), '')}]]
let g:loaded_netrwPlugin=1

augroup vimrc
au!
au BufNewFile,BufReadPost * call s:detectindent()
au BufReadPost COMMIT_EDITMSG setl textwidth=72
au SwapExists * let v:swapchoice = 'e'
augroup END

function s:detectindent()
	let l = getbufline('%', 1, min([512, line('$')]))
	call filter(l, {i, v -> v !~ '^\s*$'})
	if match(l, '^\t') != -1
		set et< sts< sw<
		return
	endif
	call map(l, {i, v -> len(matchstr(v, '^ *'))})
	let l = map(copy(l), {i, v -> abs(v - l[i - !!i])})
	let s = [4, 2, 6, 8]
	let n = map(copy(s), {i, v -> count(l, v)})
	let i = index(n, max(n))
	if n[i] != 0
		exe 'setl et sts=-1 sw='.s[i]
		return
	endif
	exe 'au BufWritePost <buffer='.bufnr().'> ++once call s:detectindent()'
endfunc

endif " +eval
