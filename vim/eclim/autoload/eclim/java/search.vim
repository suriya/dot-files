" Author:  Eric Van Dewoestine
" Version: $Revision: 1.9 $
"
" Description: {{{
"   see http://eclim.sourceforge.net/vim/java/complete.html
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

" Global Varables {{{
  if !exists("g:EclimJavaDocSearchSingleResult")
    " possible values ('open', 'lopen')
    let g:EclimJavaDocSearchSingleResult = "open"
  endif

  if !exists("g:EclimJavaSearchSingleResult")
    " possible values ('split', 'edit', 'lopen')
    let g:EclimJavaSearchSingleResult = "split"
  endif
" }}}

" Script Varables {{{
  let s:search_src = "java_search"
  let s:search_doc = "java_docsearch"
  let s:search_element =
    \ '-filter vim -command <search> -n "<project>" -f "<file>" ' .
    \ '-o <offset> -l <length> <args>'
  let s:search_pattern =
    \ '-filter vim -command <search> -n "<project>" -f "<file>" <args>'
  let s:options = ['-p', '-t', '-x', '-s']
  let s:contexts = ['all', 'declarations', 'implementors', 'references']
  let s:scopes = ['all', 'project', 'type']
  let s:types = [
    \ 'annotation',
    \ 'class',
    \ 'classOrEnum',
    \ 'classOrInterface',
    \ 'constructor',
    \ 'enum',
    \ 'field',
    \ 'interface',
    \ 'method',
    \ 'package',
    \ 'type']

  let s:search_alt_all = '\<<element>\>'
  let s:search_alt_references = s:search_alt_all
  let s:search_alt_implementors =
    \ '\(implements\|extends\)\_[0-9A-Za-z,[:space:]]*\<<element>\>\_[0-9A-Za-z,[:space:]]*{'
" }}}

" Search (command, ...) {{{
" Executes a search.
" Usage closely resebles eclim command line client usage.
" When doing a non-pattern search the element under the cursor is searched for.
"   Search for declarations of element under the cursor
"     call s:Search("-x", "declarations")
"   Search for references of HashMap
"     call s:Search("-p", "HashM*", "-t", "class", "-x", "references")
" Or all the arguments can be passed in at once:
"   call s:Search("-p 'HashM*' -t class -x references")
function! s:Search (command, ...)
  let argline = ""
  let index = 1
  while index <= a:0
    if index != 1
      let argline = argline . " "
    endif
    let argline = argline . a:{index}
    let index = index + 1
  endwhile

  let in_project = eclim#project#IsCurrentFileInProject(0)

  " element search
  if argline !~ '-p\>'
    if &ft != 'java'
      call eclim#util#EchoWarning
        \ ("Element searches only supported in java source files.")
      return 0
    endif

    if !eclim#java#util#IsValidIdentifier(expand('<cword>'))
      call eclim#util#EchoError
        \ ("Element under the cursor is not a valid java identifier.")
      return 0
    endif

    if !in_project
      " build a pattern search and execute it
      return s:SearchAlternate('-p ' . s:BuildPattern() . ' ' . argline, 1)
    endif

    let project = eclim#project#GetCurrentProjectName()
    let filename = eclim#java#util#GetFilename()
    let position = eclim#util#GetCurrentElementPosition()
    let offset = substitute(position, '\(.*\);\(.*\)', '\1', '')
    let length = substitute(position, '\(.*\);\(.*\)', '\2', '')

    let search_cmd = s:search_element
    let search_cmd = substitute(search_cmd, '<project>', project, '')
    let search_cmd = substitute(search_cmd, '<search>', a:command, '')
    let search_cmd = substitute(search_cmd, '<file>', filename, '')
    let search_cmd = substitute(search_cmd, '<offset>', offset, '')
    let search_cmd = substitute(search_cmd, '<length>', length, '')
    let search_cmd = substitute(search_cmd, '<args>', argline, '')

    let result = eclim#ExecuteEclim(search_cmd)

  " pattern search
  else
    if !in_project
      return s:SearchAlternate(argline, 0)
    endif

    let project = eclim#project#GetCurrentProjectName()
    let filename = eclim#java#util#GetFilename()

    " pattern search
    let search_cmd = s:search_pattern
    let search_cmd = substitute(search_cmd, '<project>', project, '')
    let search_cmd = substitute(search_cmd, '<file>', filename, '')
    let search_cmd = substitute(search_cmd, '<search>', a:command, '')
    let search_cmd = substitute(search_cmd, '<args>', argline, '')
    " quote the search pattern
    let search_cmd =
      \ substitute(search_cmd, '\(.*-p\s\+\)\(.\{-}\)\(\s\|$\)\(.*\)', '\1"\2"\3\4', '')
    let result =  eclim#ExecuteEclim(search_cmd)
  endif

  return result
endfunction " }}}

" SearchAlternate(argline, element) {{{
" Alternate search for non-project src files using vimgrep and &path.
function! s:SearchAlternate (argline, element)
  call eclim#util#EchoInfo
    \ ("Unable to determine file's project. Executing alternate search...")
  if a:argline =~ '-t'
    call eclim#util#EchoError
      \ ("Alternate search doesn't support the type (-t) option yet.")
    return
  endif
  let search_pattern = ""
  if a:argline =~ '-x all'
    let search_pattern = s:search_alt_all
  elseif a:argline =~ '-x implementors'
    let search_pattern = s:search_alt_implementors
  elseif a:argline =~ '-x references'
    let search_pattern = s:search_alt_references
  endif

  let pattern = substitute(a:argline, '.*-p\s\+\(.\{-}\)\(\s.*\|$\)', '\1', '')
  let file_pattern = substitute(pattern, '\.', '/', 'g') . ".java"

  " search relative to the current dir first.
  let package_path = substitute(eclim#java#util#GetPackage(), '\.', '/', 'g')
  let path = substitute(expand('%:p:h'), '\', '/', 'g')
  let path = substitute(path, package_path, '', '')
  let files = split(eclim#util#Globpath(path, "**/" . file_pattern), '\n')

  " if none found, then search the path.
  if len(files) == 0
    let files = eclim#util#FindFileInPath(file_pattern, 1)
    let path = ""
  endif

  let results = []

  if len(files) > 0 && search_pattern != ''
    " narrow down to, hopefully, a distribution path for a narrower search.
    let response = eclim#util#PromptList(
      \ "Multiple type matches. Please choose the relevant file.",
      \ files, g:EclimInfoHighlight)
    if response == -1
      return
    endif

    let file = substitute(get(files, response), '\', '/', 'g')
    if path == ""
      let path = eclim#util#GetPathEntry(file)
    endif
    let path = escape(path, '/\')
    let path = substitute(file, '\(' . path . '[/\\]\?.\{-}[/\\]\).*', '\1', '')
    let pattern = substitute(pattern, '\*', '.\\\\{-}', 'g')
    let search_pattern = substitute(search_pattern, '<element>', pattern, '')
    let command = "vimgrep /" . search_pattern . "/gj " . path . "**/*.java"
    "echom command
    silent! exec command

    let loclist = getloclist(0)
    for entry in loclist
      let bufname = bufname(entry.bufnr)
      " when searching for implementors, prevent dupes from the somewhat
      " greedy pattern search.
      if a:argline !~ '-x implementors' ||
          \ !eclim#util#ListContains(results, bufname . '.*')
        call add(results,
          \ bufname . "|" . entry.lnum . " col " . entry.col . "|" . entry.text)
      endif
    endfor
  elseif len(files) > 0
    " if an element search, filter out results that are not imported.
    if a:element
      let results = []
      for file in files
        let fully_qualified = eclim#java#util#GetPackage(file) . '.' .
          \ eclim#java#util#GetClassname(file)
        if eclim#java#util#IsImported(fully_qualified)
          call add(results, file . "|1 col 1|" . fully_qualified)
        endif
      endfor
    endif
    if len(results) == 0
      call map(files, 'v:val . "|1 col 1|"')
      let results = files
    endif
  endif
  call eclim#util#Echo(' ')
  return join(results, "\n")
endfunction " }}}

" BuildPattern() {{{
" Builds a pattern based on the cursors current position in the file.
function! s:BuildPattern ()
  let class = expand('<cword>')
  " see if the classname element selected is fully qualified.
  let line = getline('.')
  let package =
    \ substitute(line, '.*\s\([0-9A-Za-z._]*\)\.' . class . '\>.*', '\1', '')

  " not fully qualified, so attempt to determine package from import.
  if package == line
    let package = eclim#java#util#GetPackageFromImport(class)

    " maybe the element is the current class?
    if package == ""
      if eclim#java#util#GetClassname() == class
        let package = eclim#java#util#GetPackage()
      endif
    endif
  endif

  if package != ""
    return package . "." . class
  endif
  return class
endfunction " }}}

" SearchAndDisplay(type, ...) {{{
" Execute a search and displays the results via quickfix.
function! eclim#java#search#SearchAndDisplay (type, args)
  " if running from a non java source file, no SilentUpdate needed.
  if &ft == 'java'
    call eclim#java#util#SilentUpdate()
  endif

  let argline = a:args

  " check if just a pattern was supplied.
  if argline =~ '^\s*\w'
    let argline = '-p ' . argline
  endif

  let results = split(s:Search(a:type, argline), '\n')
  if len(results) == 1 && results[0] == '0'
    return
  endif
  if !empty(results)
    if a:type == 'java_search'
      call eclim#util#SetLocationList(eclim#util#ParseLocationEntries(results))
      " if only one result and it's for the current file, just jump to it.
      " note: on windows the expand result must be escaped
      if len(results) == 1 && results[0] =~ escape(expand('%:p'), '\') . '|'
        if results[0] !~ '|1 col 1|'
          lfirst
        endif

      " single result in another file.
      elseif len(results) == 1 && g:EclimJavaSearchSingleResult != "lopen"
        let entry = getloclist(0)[0]
        let g:EclimLastProject = eclim#project#GetCurrentProjectName()
        exec g:EclimJavaSearchSingleResult . ' ' . bufname(entry.bufnr)
        unlet g:EclimLastProject

        call cursor(entry.lnum, entry.col)
      else
        lopen
      endif
    elseif a:type == 'java_docsearch'
      let window_name = "javadoc_search_results"
      let filename = expand('%:p')
      call eclim#util#TempWindowClear(window_name)

      if len(results) == 1 && g:EclimJavaDocSearchSingleResult == "open"
        let entry = results[0]
        call <SID>ViewDoc(entry)
      else
        call eclim#util#TempWindow(window_name, results)

        nnoremap <silent> <buffer> <cr> :call <SID>ViewDoc()<cr>
      endif
    endif
  else
    if argline =~ '-p '
      let searchedFor = substitute(argline, '.*-p \(.\{-}\)\( .*\|$\)', '\1', '')
      call eclim#util#EchoInfo("Pattern '" . searchedFor . "' not found.")
    elseif &ft == 'java'
      if !eclim#java#util#IsValidIdentifier(expand('<cword>'))
        return
      endif

      let searchedFor = expand('<cword>')
      call eclim#util#EchoInfo("No results for '" . searchedFor . "'.")
    endif
  endif
endfunction " }}}

" ViewDoc(...) {{{
" View the supplied file in a browser, or if none proved, the file under the
" cursor.
function! s:ViewDoc (...)
  if a:0 > 0
    call eclim#web#OpenUrl(a:1)
  else
    let url = substitute(getline('.'), '\(.\{-}\)|.*', '\1', '')
    call eclim#web#OpenUrl(url)
  endif
endfunction " }}}

" CommandCompleteJavaSearch(argLead, cmdLine, cursorPos) {{{
" Custom command completion for JavaSearch
function! eclim#java#search#CommandCompleteJavaSearch (argLead, cmdLine, cursorPos)
  let cmdLine = strpart(a:cmdLine, 0, a:cursorPos)
  let cmdTail = strpart(a:cmdLine, a:cursorPos)
  let argLead = substitute(a:argLead, cmdTail . '$', '', '')
  if cmdLine =~ '-s\s\+[a-z]*$'
    let scopes = deepcopy(s:scopes)
    call filter(scopes, 'v:val =~ "^' . argLead . '"')
    return scopes
  elseif cmdLine =~ '-t\s\+[a-z]*$'
    let types = deepcopy(s:types)
    call filter(types, 'v:val =~ "^' . argLead . '"')
    return types
  elseif cmdLine =~ '-x\s\+[a-z]*$'
    let contexts = deepcopy(s:contexts)
    call filter(contexts, 'v:val =~ "^' . argLead . '"')
    return contexts
  elseif cmdLine =~ '\s\+[-]\?$'
    let options = deepcopy(s:options)
    let index = 0
    for option in options
      if a:cmdLine =~ option
        call remove(options, index)
      else
        let index += 1
      endif
    endfor
    return options
  endif
  return []
endfunction " }}}

" FindClassDeclaration() {{{
" Used by non java source files to find the declaration of a classname under
" the cursor.
function! eclim#java#search#FindClassDeclaration ()
  exec "JavaSearch -t classOrInterface -p " . expand('<cword>')
endfunction " }}}

" vim:ft=vim:fdm=marker
