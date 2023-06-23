set background=light
set belloff=all
set columns=80 lines=60
set guicursor=a:blinkoff0
set guioptions=ei
set mouseshape=a:arrow,i-r:beam

hi Normal guibg=#ffffdd guifg=black
hi Terminal guibg=#ffffdd guifg=black

if argc() == 0
	silent args ~/guide
endif
