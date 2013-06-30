"
" $Id: java.vim 830 2007-09-04 20:45:20Z suriya $
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Comment and uncomment code
map C 0i// <esc>j
map X 03xj
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run make when <F5> is pressed and show the errors
map <F5> :copen<cr>:make<cr>
map <F4> :cnext<cr>
map <F3> :cprev<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=2
set shiftwidth=2
set expandtab
set cindent

"""""""""""""""" Cscope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim          
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE:
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE:
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell        jduell@alumni.princeton.edu     2002/3/7
" Suriya Subramanian suriya@cs.utexas.edu            2004/5/2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Its nice to use cscope
" Add these to enable seamless integration of cscope and ctags
if has("cscope")

    """""""""""" Initilize cscope by adding available databases
 	set nocsverb
	set csprg=cscope
 	set csto=0
 	set cst
	" add any database in current directory
 	if filereadable("cscope.out")
 		cs add cscope.out
	" else add database pointed to by environment
 	elseif $CSCOPE_DB != ""
 		cs add $CSCOPE_DB
 	endif
	set csverb

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search. 
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

	"""""""""""" Add cscope to the menu
	" This also does another thing. This enables cscopequickfix
	" As a result, cscope doesn't show numbers when there are multiple
	" results (as it usually does). Instead, cscope does something like an
	" errfile. So you can use :copen, :cnext, :cprev, etc.
	" :cindow (see usage at the end of the menu entries below) opens an
	" errfile if there is one. So we need not do :copen
	" These are (useful) maps which I have
	" map <F3> :cnext<CR>
	" map <F4> :cprev<CR>
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    nmenu Cscope.Find\ this\ C\ symbol                       :cs find s <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ this\ definition                      :cs find g <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ functions\ called\ by\ this\ function :cs find d <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ functions\ calling\ this\ function    :cs find c <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ this\ text\ string                    :cs find t <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ this\ egrep\ pattern                  :cs find e <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ this\ file                            :cs find f <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu Cscope.Find\ files\ #including\ this\ file         :cs find i <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>

    imenu Cscope.Find\ this\ C\ symbol                       <esc>:cs find s <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ this\ definition                      <esc>:cs find g <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ functions\ called\ by\ this\ function <esc>:cs find d <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ functions\ calling\ this\ function    <esc>:cs find c <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ this\ text\ string                    <esc>:cs find t <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ this\ egrep\ pattern                  <esc>:cs find e <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ this\ file                            <esc>:cs find f <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu Cscope.Find\ files\ #including\ this\ file         <esc>:cs find i <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>

    nmenu PopUp.Cscope.Find\ this\ C\ symbol                       :cs find s <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ this\ definition                      :cs find g <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ functions\ called\ by\ this\ function :cs find d <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ functions\ calling\ this\ function    :cs find c <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ this\ text\ string                    :cs find t <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ this\ egrep\ pattern                  :cs find e <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ this\ file                            :cs find f <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    nmenu PopUp.Cscope.Find\ files\ #including\ this\ file         :cs find i <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>

    imenu PopUp.Cscope.Find\ this\ C\ symbol                       <esc>:cs find s <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ this\ definition                      <esc>:cs find g <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ functions\ called\ by\ this\ function <esc>:cs find d <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ functions\ calling\ this\ function    <esc>:cs find c <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ this\ text\ string                    <esc>:cs find t <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ this\ egrep\ pattern                  <esc>:cs find e <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ this\ file                            <esc>:cs find f <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
    imenu PopUp.Cscope.Find\ files\ #including\ this\ file         <esc>:cs find i <C-R>=expand("<cword>")<CR><CR> :cwindow<CR>
else
	echo "This version of vim does not come with cscope support. RECOMPILE vim"
endif


" Some abbreviations
call IMAP("SEP", "System.err.println(\"<++>\");", "java")
call IMAP("SOP", "System.out.println(\"<++>\");", "java")
