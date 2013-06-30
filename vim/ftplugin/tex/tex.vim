"
" $Id: tex.vim 1409 2011-11-08 07:52:51Z suriya $
"

" This is a file for tex with a few simple mappings.
" This depends on the file ~/.vim/plugin/imaps.vim
"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Comment and uncomment code
map C 0i% <esc>j
map X 02xj
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ts=2
set sw=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-latexsuite folding configuration for Mridangam lessons
let Tex_FoldedEnvironments=",lesson,Msection"

"
" Compiling quickly

map <F2> :!if [ -x Makefile ]; then make; else rubber %; fi<cr><cr>
map <F3> :!xdvi *.dvi<cr>


call IMAP("DOC", "\\documentclass[a4paper,10pt]{article}\<cr>\\title{<++>}\<cr>\\author{<++>}\<cr>\\begin{document}\<cr><++>\<cr>\\end{document}", "tex")
call IMAP("TBLR", "\\begin{tabular}{<++>}\<cr><++>\<cr>\\end{tabular}\<cr><++>", "tex")
call IMAP("TAB", "\\begin{table}[H]\<cr>\\begin{center}\<cr><++>\<cr>\\caption{<++>\\label{tab:<++>}}\<cr>\\end{center}\<cr>\\end{table}\<cr><++>", "tex")
call IMAP("FIG", "\\begin{figure}[H]\<cr>\\begin{center}\<cr>\\includegraphics[<++>]{<++>}\<cr>\\caption{<++>\\label{fig:<++>}}\<cr>\\end{center}\<cr>\\end{figure}\<cr><++>", "tex")
call IMAP("ECE", "\\begin{center}\<cr><++>\<cr>\\end{center}\<cr><++>", "tex")
call IMAP("BIB", "\\bibliographystyle{alpha}\<cr>\\bibliography{<++>}\<cr><++>", "tex")
call IMAP("SLI", "\\begin{slide}\\slideheading{<++>}\<cr><++>\<cr>\\vfill\<cr>\\end{slide}\<cr>\<cr><++>", "tex")
call IMAP("FRA", "\\begin{frame}{<++>}%{A Sub-title is optional}\<cr><++>\<cr>\\end{frame}<++>", "tex")
call IMAP("BLO", "\\begin{block}{<++>}\<cr><++>\<cr>\\end{block}<++>", "tex")

"
" List environments
"
call IMAP("EIT", "\\begin{itemize}\<cr>\\item <++>\<cr>\\end{itemize}<++>", "tex")
call IMAP("EEN", "\\begin{enumerate}\<cr>\\item <++>\<cr>\\end{enumerate}\<cr><++>", "tex")
call IMAP("EDES", "\\begin{description}\<cr>\\item[<++>] <++>\<cr>\\end{description}\<cr><++>", "tex")


"
" Font changing commands
"
call IMAP("'bf", "\\textbf{<++>}<++>", "tex")
call IMAP("'tt", "\\texttt{<++>}<++>", "tex")
call IMAP("'em", "\\emph{<++>}<++>", "tex")


"
" Sectioning commands
"
call IMAP("SEC",         "\\section{<++>}\<cr>\\label{sec:<++>}\<cr><++>", "tex")
call IMAP("SSEC",     "\\subsection{<++>}\<cr>\\label{subsec:<++>}\<cr><++>", "tex")
call IMAP("SSSEC", "\\subsubsection{<++>}\<cr>\\label{subsubsec:<++>}\<cr><++>", "tex")

"
" Math symbols 
"
"   call IMAP("->", "\\rightarrow", "tex")
"   call IMAP("<-", "\\leftarrow", "tex")
"   call IMAP("<=", "\\leq", "tex")
"   call IMAP(">=", "\\geq", "tex")
"   call IMAP("=>", "\\Rightarrow", "tex")
"   call IMAP("...", "\\ldots", "tex")


"
" Greek symbols
"
"call IMAP("'''", "\\vartheta", "tex")
"call IMAP("''e", "\\varepsilon", "tex")
"call IMAP("''p", "\\varpi", "tex")
"call IMAP("''r", "\\varrho", "tex")
"call IMAP("''v", "\\varsigma", "tex")
call IMAP("''0", "\\phi", "tex")
call IMAP("''a", "\\alpha", "tex")
call IMAP("''b", "\\beta", "tex")
call IMAP("''c", "\\chi", "tex")
call IMAP("''d", "\\delta", "tex")
call IMAP("''e", "\\epsilon", "tex")
call IMAP("''f", "\\varphi", "tex")
call IMAP("''g", "\\gamma", "tex")
call IMAP("''h", "\\eta", "tex")
call IMAP("''i", "\\iota", "tex")
call IMAP("''k", "\\kappa", "tex")
call IMAP("''l", "\\lambda", "tex")
call IMAP("''m", "\\mu", "tex")
call IMAP("''n", "\\nu", "tex")
call IMAP("''p", "\\pi", "tex")
call IMAP("''q", "\\theta", "tex")
call IMAP("''r", "\\rho", "tex")
call IMAP("''s", "\\sigma", "tex")
call IMAP("''t", "\\tau", "tex")
call IMAP("''u", "\\upsilon", "tex")
call IMAP("''w", "\\omega", "tex")
call IMAP("''x", "\\xi", "tex")
call IMAP("''y", "\\psi", "tex")
call IMAP("''z", "\\zeta", "tex")
" Greek Letters big
call IMAP("''A", "\\Alpha", "tex")
call IMAP("''B", "\\Beta", "tex")
call IMAP("''C", "\\Chi", "tex")
call IMAP("''D", "\\Delta", "tex")
call IMAP("''E", "\\Epsilon", "tex")
call IMAP("''G", "\\Gamma", "tex")
call IMAP("''H", "\\Eta", "tex")
call IMAP("''K", "\\Kappa", "tex")
call IMAP("''L", "\\Lambda", "tex")
call IMAP("''M", "\\Mu", "tex")
call IMAP("''N", "\\Nu", "tex")
call IMAP("''O", "\\Theta", "tex")
call IMAP("''P", "\\Phi", "tex")
call IMAP("''P", "\\Pi", "tex")
call IMAP("''R", "\\Rho", "tex")
call IMAP("''S", "\\Sigma", "tex")
call IMAP("''T", "\\Tau", "tex")
call IMAP("''U", "\\Upsilon", "tex")
call IMAP("''W", "\\Omega", "tex")
call IMAP("''X", "\\Xi", "tex")
call IMAP("''Y", "\\Psi", "tex")
