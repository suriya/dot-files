"
" $Id$
"


" Simple maps for commenting and un-commenting python source code
" map C I# <esc>j
" map X ^2xj

map C 0i# <esc>j
map X 02xj
call IMAP("FUT", "from __future__ import absolute_import, unicode_literals, print_function", "python")
call IMAP("GET", "response = self.client.get(url)\<cr>self.assertEqual(response.status_code, 200)", "python")
