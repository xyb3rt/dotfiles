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

filetype off
syntax off

let g:acme_plumbing = [
	\ ['<https?\:\/\/(\f|[-.~!*();:@&=+$,/?#%]|\[|\])+', {m ->
		\ AcmePlumb('', 'setsid xdg-open', m[0])}],
	\ ['(\f{-1,})\s*\((\d\a*)\)', {m ->
		\ AcmePlumb(m[1].'('.m[2].')', 'man', m[2], m[1])}],
	\ ['\f+', {m -> m[0] !~ '/' &&
		\ AcmeOpen(exepath(m[0]), '')}],
	\ ['(\f|[@{}~^.])+', {m ->
		\ AcmePlumb('git:'.m[0], 'git-plumb', m[0])}]]
let g:loaded_netrwPlugin=1

augroup vimrc
au!
au BufNewFile,BufReadPost * call s:detectindent()
au BufReadPost COMMIT_EDITMSG setl textwidth=72
au OptionSet background call s:setcolors()
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

function s:setcolors()
	if &t_Co < 256
		return
	endif
	let c = &bg == 'light'
		\ ? [0, 195, 186, 193, 225, 213]
		\ : [15, 237, 58, 22, 53, 127]
	exe 'hi StatusLine ctermbg='.c[1].' ctermfg='.c[0].' cterm=bold'
	exe 'hi StatusLineNC ctermbg='.c[1].' ctermfg='.c[0].' cterm=none'
	exe 'hi VertSplit ctermbg='.c[1].' ctermfg='.c[0].' cterm=none'
	exe 'hi Visual ctermbg='.c[2].' ctermfg='.c[0].' cterm=none'
	exe 'hi Search ctermbg='.c[3].' ctermfg='.c[0].' cterm=none'
	exe 'hi DiffAdd ctermbg='.c[4].' ctermfg='.c[0].' cterm=none'
	exe 'hi DiffDelete ctermbg='.c[4].' ctermfg='.c[5].' cterm=none'
	exe 'hi DiffChange ctermbg='.c[4].' ctermfg='.c[0].' cterm=none'
	exe 'hi DiffText ctermbg='.c[5].' ctermfg='.c[0].' cterm=none'
endfunc

call s:setcolors()

if $XDG_SESSION_DESKTOP == 'gnome'
	call job_start(['darkmon'], {
		\ 'callback': {_, v -> execute('sil! set bg='.v)},
		\ 'err_io': 'null', 'in_io': 'null', 'mode': 'nl'})
endif
