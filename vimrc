" $Id: vimrc 1182 2009-02-03 11:54:29Z suriya $
"

""""""""""""""""" This is from the file /etc/vim/vimrc
""""""""""""""""" of the Debian GNU/Linux distribution (Woody)
""""""""""""""""" BEGIN FILE
" Configuration file for vim

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start	" more powerful backspacing

" Now we set some defaults for the editor
set autoindent		" always set autoindenting on
set textwidth=0		" Don't wrap words by default
set nobackup		" Don't keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than
			" 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" We know xterm-debian is a color terminal
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
" syntax on

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
set helpfile=$VIMRUNTIME/doc/help.txt

" Enabled filetype plugin and indent detection
filetype plugin on
filetype indent on

" Some Debian-specific things
augroup filetype
  au BufRead reportbug.*		set ft=mail
  au BufRead reportbug-*		set ft=mail
augroup END

" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make

""""""""""""""""" END FILE """"""""""""""""""""""""""""""""""""""""""""""""""""

" These are changes made locally by me, Suriya Subramanian <mssnlayam@vsnl.net>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I press the <Esc> key a lot of times in normal mode. I do not like the bell
" to ring. So I set it to show a visual bell
set tabstop=4
set shiftwidth=4
set expandtab
set visualbell t_vb=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" By default the vimrc file disables backups. This is dangerous. We enable
" backups and also put them in a separate directory to avoid the current
" directory from being cluttered with backup files
set backup
set backupdir=~/.vim-backup/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting by default
syntax on
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show (partial) command in status line
set showcmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Its nice to have brackets to be matched as you type them
set showmatch
" The default matchtime is a bit long. Set it to 200 ms
set matchtime=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add some bells and whistles to your search
set incsearch
set hlsearch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get the text to be automatically be wrapped
set textwidth=75
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyword completion <C-p> searched in these paths, add as needed
set path=.,/usr/include,/usr/src/linux/include/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically move to the last position where you left
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use templates for new files
" You need to have the package template-new installed
" autocmd BufNewFile *.c,*.cpp,*.h	!template-new <afile>
" autocmd BufNewFile *.pl			!template-new <afile>
" autocmd BufNewFile *-letter.tex		!template-new <afile> letter
" autocmd BufNewFile *.tex		!template-new <afile>
" autocmd BufNewFile *.html		!template-new <afile>
" autocmd BufNewFile *.sh			!template-new <afile>
" autocmd BufNewFile Makefile             !template-new <afile>
"
" autocmd BufNewFile *.py			!template-new <afile>
autocmd BufRead *TODO           set filetype=TODO
autocmd BufNewFile *TODO        set filetype=TODO
autocmd BufRead *.til           set filetype=til
autocmd BufNewFile *til         set filetype=til
autocmd BufRead    *.mkd        set filetype=mkd
autocmd BufNewFile *.mkd        set filetype=mkd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ut=1000
set laststatus=2
map gff :!xterm -bg black -fg white -e vim <cfile> & <cr><cr>
set mouse=a

"" break a line here
nmap <C-h> i<cr><esc>k<end>

" wildmenu
set wildmenu

" scrolloff so that we stay away from the top and bottom portions of the
" screen
set scrolloff=5

set helpheight=1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some good handling of quickfix windows
autocmd QuickFixCmdPre * copen
map <F3> :cprev<cr>
map <F4> :cnext<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Do not load matchparen
let loaded_matchparen = 1

" Better highlighting of search terms
highlight Search cterm=bold ctermfg=7 ctermbg=4 guifg=white guibg=blue
highlight Cursorline cterm=bold ctermfg=7 ctermbg=4 guifg=white guibg=blue

" Error format for python
" set efm+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%m
set efm+=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%m

let g:tex_flavor = "latex"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I work only in console (VT) or Konsole. The background is always dark.
" I do not use gvim
" set background=dark
set background=light
colorscheme delek
highlight Constant term=underline ctermfg=1
" highlight Identifier ctermfg=darkred
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EclimDisabled = 1

set modeline
set modelines=5
let g:netrw_sort_sequence = '[\/]$,\<core\%(\.\d\+\)\=,\.[a-np-z]$,\.h$,\.c$,\.cpp$,*,\.pyc$,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$'
