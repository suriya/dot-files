" Author:  Eric Van Dewoestine
" Version: $Revision: 1.3 $
"
" Description: {{{
"   see http://eclim.sourceforge.net/vim/java/impl.html
"
" License:
"
" Copyright (c) 2005 - 2006
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"      http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.
"
" }}}

" Script Varables {{{
  let s:command_impl =
    \ '-filter vim -command java_impl -p "<project>" -f "<file>" -o <offset>'
  let g:JavaImplCommandInsert =
    \ '-filter vim -command java_impl -p "<project>" -f "<file>" -t "<type>" ' .
    \ '-s "<superType>" <methods>'
  let s:cross_type_selection = "Visual selection is currently limited to methods of one super type at a time."
" }}}

" Impl() {{{
function! eclim#java#impl#Impl ()
  if !eclim#project#IsCurrentFileInProject()
    return
  endif

  call eclim#java#util#SilentUpdate()

  let project = eclim#project#GetCurrentProjectName()
  let filename = eclim#java#util#GetFilename()
  let offset = eclim#util#GetCurrentElementOffset()

  let command = s:command_impl
  let command = substitute(command, '<project>', project, '')
  let command = substitute(command, '<file>', filename, '')
  let command = substitute(command, '<offset>', offset, '')

  call eclim#java#impl#ImplWindow(command)
endfunction " }}}

" ImplWindow(command) {{{
function! eclim#java#impl#ImplWindow (command)
  let name = eclim#java#util#GetFilename() . "_impl"
  if eclim#util#TempWindowCommand(a:command, name)
    setlocal ft=java
    call eclim#java#impl#ImplWindowFolding()

    nnoremap <silent> <buffer> <cr>
      \ :call eclim#java#impl#ImplAdd
      \    (g:JavaImplCommandInsert, function("eclim#java#impl#ImplWindow"), 0)<cr>
    vnoremap <silent> <buffer> <cr>
      \ :<C-U>call eclim#java#impl#ImplAdd
      \    (g:JavaImplCommandInsert, function("eclim#java#impl#ImplWindow"), 1)<cr>
  endif
endfunction " }}}

" ImplWindowFolding() {{{
function! eclim#java#impl#ImplWindowFolding ()
  setlocal foldmethod=syntax
  setlocal foldlevel=99
endfunction " }}}

" ImplAdd(command, function) {{{
function! eclim#java#impl#ImplAdd (command, function, visual)
  let winnr = bufwinnr(bufnr(b:filename))
  " src window is not longer open.
  if winnr == -1
    call eclim#util#EchoError(b:filename . ' no longer found in an open window.')
    return
  endif

  if a:visual
    let start = line("'<")
    let end = line("'>")
  endif

  let superType = ""
  let methods = ""
  " non-visual mode or only one line selected
  if !a:visual || start == end
    " not a valid selection
    if line('.') == 1 || getline('.') =~ '^\(\s*//\|package\|$\|}\)'
      return
    endif

    let line = getline('.')
    if line =~ '^\s*throws'
      let line = getline(line('.') - 1)
    endif
    " on a method line
    if line =~ '^\s\+'
      let methods = substitute(line, '.*\s\(\w\+\s(.*\)', '\1', '')
      let methods = substitute(methods, '\s\w\+\(,\|)\)', '\1', 'g')
      let methods = substitute(methods, '\s(', '(', 'g')
      let methods = substitute(methods, ',\s', ',', 'g')
      let methods = substitute(methods, '<.\{-}>', '', 'g')
      let ln = search('^\w', 'bWn')
      if ln > 0
        let superType = substitute(getline(ln), '.*\s\(.*\) {', '\1', '')
      endif
    " on a type line
    else
      let superType = substitute(line, '.*\s\(.*\) {', '\1', '')
    endif

  " visual mode
  else
    let lnum = line('.')
    let col = col('.')
    let index = start
    while index <= end
      let line = getline(index)
      if line =~ '^\s*\($\|throws\|package\)'
        " do nothing
      " on a method line
      elseif line =~ '^\s\+'
        if methods != ""
          let methods = methods . "|"
        endif
        let method = substitute(line, '.*\s\(\w\+\s(.*\)', '\1', '')
        let method = substitute(method, '\s\w\+\(,\|)\)', '\1', 'g')
        let method = substitute(method, '\s(', '(', 'g')
        let method = substitute(method, ',\s', ',', 'g')
        let method = substitute(method, '<.\{-}>', '', 'g')
        let methods = methods . method
        call cursor(index, 1)
        let ln = search('^\w', 'bWn')
        if ln > 0
          let super = substitute(getline(ln), '.*\s\(.*\) {', '\1', '')
          if superType != "" && super != superType
            call eclim#util#EchoError(s:cross_type_selection)
            call cursor(lnum, col)
            return
          endif
          let superType = super
        endif
      " on a type line
      else
        let super = substitute(line, '.*\s\(.*\) {', '\1', '')
        if superType != "" && super != superType
          call eclim#util#EchoError(s:cross_type_selection)
          call cursor(lnum, col)
          return
        endif
        let superType = super
      endif
      call cursor(lnum, col)

      let index += 1
    endwhile

    if superType == ""
      return
    endif
  endif

  " search up for the nearest package
  let ln = search('^package', 'bWn')
  if ln > 0
    let package = substitute(getline(ln), '.*\s\(.*\);', '\1', '')
    let superType = package . '.' . superType
  endif

  let type = substitute(getline(1), '\$', '.', 'g')
  let impl_winnr = winnr()
  exec winnr . "winc w"
  call eclim#java#util#SilentUpdate()

  let project = eclim#project#GetCurrentProjectName()

  let command = a:command
  let command = substitute(command, '<project>', project, '')
  let command = substitute(command, '<file>', eclim#java#util#GetFilename(), '')
  let command = substitute(command, '<type>', type, '')
  let command = substitute(command, '<superType>', superType, '')
  if methods != ""
    let command = substitute(command, '<methods>', '-m "' . methods . '"', '')
  else
    let command = substitute(command, '<methods>', '', '')
  endif

  call a:function(command)

  exec winnr . "winc w"
  call eclim#util#RefreshFile()
  silent retab

  exec impl_winnr . "winc w"
endfunction " }}}

" vim:ft=vim:fdm=marker
