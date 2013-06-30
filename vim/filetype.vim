" $Id: filetype.vim 673 2006-09-06 18:03:00Z suriya $

" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.dmpl    setfiletype dmpl
augroup END

