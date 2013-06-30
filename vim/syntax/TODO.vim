" $Id: TODO.vim 159 2004-11-21 00:47:02Z suriya $

syntax match xTODO /+.*/
syntax match xDONE /-.*/
highlight xTODO term=standout cterm=bold ctermfg=2 gui=bold guifg=Green
highlight xDONE term=standout cterm=bold ctermfg=1 guifg=Red
