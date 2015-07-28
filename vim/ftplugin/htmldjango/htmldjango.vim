
" This is a file for tex with a few simple mappings.
" This depends on the file ~/.vim/plugin/imaps.vim
"

call IMAP("ROW",   "<div class=\"row\">\<cr><++>\<cr></div>\<cr><++>", "htmldjango")
call IMAP("COL",   "<div class=\"col-sm-<++>\">\<cr><++>\<cr></div>\<cr><++>", "htmldjango")
call IMAP("TABLE", "<table class=\"table table-striped table-bordered\">\<cr><++>\<cr></table>\<cr><++>", "htmldjango")
call IMAP("THEAD", "<thead><tr>\<cr><th><++></th>\<cr><th><++></th>\<cr></tr>\<cr></thead><++>", "htmldjango")
call IMAP("TROW",  "<tr>\<cr><td><++></td>\<cr><td><++></td>\<cr></tr>\<cr><++>", "htmldjango")
call IMAP("FOR",   "{% for <++> in <++> %}\<cr><++>\<cr>{% endfor %}\<cr><++>", "htmldjango")
call IMAP("EMPTY", "{% empty %}\<cr><tr><td class=\"text-center\" colspan=\"1000\">No <++> found.</td></tr>", "htmldjango")
