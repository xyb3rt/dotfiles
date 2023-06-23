set autoindent copyindent
set autoread
set autoshelldir
set backspace=indent,eol,start
set clipboard=unnamed
set display=lastline
set directory=~/.vim/swap//
set noequalalways
set hidden
set hlsearch incsearch
set ignorecase smartcase
set nomodeline
set mouse=a ttymouse=sgr
set noruler showcmd
set showmatch
set wildmode=longest,list nowildmenu

if 1 " +eval

filetype on
filetype indent plugin off
syntax off

let g:acme_plumbing = [
	\ ['<https?\:\/\/(\f|[-.~!*();:@&=+$,/?#%]|\[|\])+', {m ->
		\ AcmePlumb('', 'xdg-open', m[0])}],
	\ ['([[:graph:]]+)\s*\((\d\a*)\)', {m ->
		\ AcmePlumb(m[1].'('.m[2].')', 'man', m[2], m[1])}],
	\ ['<stash\@\{\d+\}', {m ->
		\ AcmePlumb('git:'.m[0], 'git stash show -p', m[0])}],
	\ ['(\f|[@{}])*\.\.\.?(\f|[@{}])*', {m ->
		\ AcmePlumb('git:'.m[0], 'git log -s --left-right', m[0])}],
	\ ['(\f|[@{}])+', {m ->
		\ AcmePlumb('git:'.m[0], 'git show', m[0])}]]
let g:loaded_netrwPlugin=1

augroup vimrc
au!
au BufNewFile guide call setline(1, './ ^acmegit ^acmelsp apropos fw gw')
au BufNewFile,BufReadPost * call s:detectindent()
au BufReadPost * call s:restorepos()
au FileType gitcommit setl textwidth=72
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

function s:restorepos()
	if &ft !~# 'git' && expand('%:t') != 'guide'
		if line("'\"") >= 1 && line("'\"") <= line('$')
			normal! g`"
		endif
	endif
endfunc

endif " +eval
