" functions {{{
" get the word in visual mode
fun! VsbFuntion(arg1)
    execute 'vert bel sb' a:arg1
endfun

fun! Get_visual_selection()
    let l=getline("'<")
    let [line1,col1] = getpos("'<")[1:2]
    let [line2,col2] = getpos("'>")[1:2]
    return l:l[col1 - 1: col2 - 2]
endfun

function! ChangePythonVersion(ver)
    if a:ver == 2
        set omnifunc = pythoncomplete#Complete
    endif
    if a:ver == 3
        set omnifunc = python3complete#Complete
    endif
endfunction

function! MySys()
    return "linux"
endfunction

function! IsVundle()
    return 'vundle'
endfunction

function! ToggleNu()
    if &rnu == 1
        set nornu
    else
        set rnu
    endif
endfunction

function! SetStatusLine()
    let l:curMode = mode()
    let l:line_left = '%-10.130(%3* %*%1*%m%*%<%3*%F%w%h%q %*%)%=%-7.7{&fileencoding} %-5.7{&filetype} %-8.8(ch:%B %)%4*%6.6( %p%% %)%*%5*%-5.10( %l:%c %) %*'
    if "n" == l:curMode
        return '%2*%-7.9( NORMAL %)%*'.l:line_left
    endif
    if "s" == l:curMode
        return '%7*%-7.9( SELECT %)%*'.l:line_left
    endif
    if "r" == l:curMode
        return '%7*%-7.9( REPLACE %)%*'.l:line_left
    endif
    if "v" == l:curMode
        return '%6*%-7.9( VISUAL %)%*'.l:line_left
    endif
    if "" == l:curMode
        return '%6*%-7.9( V-BLOCK %)%*'.l:line_left
    endif
    if "i" == l:curMode
         return '%2*%-7.9( INSERT %)%*'.l:line_left
    endif
    if "c" == l:curMode
        return '%-7.9( COMMAND %)'.l:line_left
    endif
    return '%2*%-8.11{mode()}'.l:line_left
endfunction

function! SimpleTag()
    silent! execute "!ctags -R"
endfunction

function! MySetCurrentPath()
    let l:path = bufname("%")
    if MySys() == "windows"
        let l:pathdir = substitute(l:path, '\\[^\\]\+$','','')
	else
            let l:pathdir = substitute(l:path, '/[^/]\+$', '','')
    endif
    if l:path != l:pathdir
        exec 'cd '.l:pathdir
        echo 'workdir: '.l:pathdir
    else
        let l:pathdir = getcwd()
        echo 'workdir: '.l:pathdir
    endif
endfunction

function! MyGoBackPath()
    exec 'cd -'
    exec 'pwd'
endfunction

function! IsExitProjectFile()
    if "Session.vim" == findfile("Session.vim", ".;")
        && ".viminfo" == findfile(".viminfo", ".;")
        return 1
    else
        return 0
    endif
endfunction

function! LoadProject()
    if IsExitProjectFile() == 1
        exec "source Session.vim"
        exec "rviminfo .viminfo"
    endif
endfunction

function! SaveProject()
    exec "mksession"
    exec "wviminfo .viminfo"
endfunction


function! CscopeTips()
    echo 's: symbol, g: define, d: what I call, c: where call me, e:find word, f:open file, i: open file contains me'
endfunction

function! MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
"}}}
if IsVundle() == 'vundle'
" pathogen add for vundle bug {{{ add plugin in .vim/bundle
execute pathogen#infect()
" }}}
endif

" common config before vundle {{{
let mapleader = ","
filetype off
syntax enable
"}}}

" common set {{{
set nu
set cino+=:2
set foldlevel=1
set foldmethod=indent
set diffopt+=vertical
set fileencodings=utf-8,cp936
set fileencoding=utf-8
set list
set listchars=tab:\|\ ,extends:>,precedes:<
set nocompatible                "make it vim style, not vi style
set backspace=indent,eol,start  "set <BC> key
set autoindent
set incsearch                   "Search increase
set hlsearch                    "Search highlight
set magic                       " pattern mode
set cursorline                  "highlight currentline
set smartcase                    "ignore case   
set ignorecase                    "ignore case   
set history=400                  "set command history 50 and seach history 50
set ruler                       "set show cursor position at right bottom
set showcmd                     "help you use command mode easily
set nobackup
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autowrite
set fileformats=unix,dos,mac
set showmatch
set matchtime=3
set fillchars=vert:\ ,stl:\ ,stlnc:\
set scrolloff=8
set laststatus=2
set stl=%!SetStatusLine()
set helplang=cn
set guioptions-=T
set guioptions-=m
set selection=exclusive
set selectmode=mouse,key
set mousemodel=extend
set tags+=./tags;
set sessionoptions =blank,buffers,curdir,folds,help,options,tabpages,winsize
set wildmenu "列出所有命令 
" set cscopequickfix=s-,c-,d-,i-,t-,e-
"close pre window
"set completeopt=longest,menu
set wildignore=*.swp,*.bak,*.pyc,*.class
"set hidden
"set nohidden
set whichwrap=<,>,h,l
set nolazyredraw
set pastetoggle=<F3>
"set colorcolumn=80         " 80 column will write a redline
set iskeyword&
set iskeyword+=	    
if MySys() == 'windows'
     set guifont=monaco:h11
    set diffexpr=MyDiff()
else
    set guifont=Monaco:h14
endif
"}}}

" common map {{{
nnoremap %{ I{%<space><esc>A<space>%}<esc>
nnoremap <leader>p "0p
inoremap <leader>cp <C-o>:cp<cr>
nnoremap <leader>cp :cp<cr>
"for mymistake
inoremap  <esc>
nnoremap <C-w>- 25<C-w>-
nnoremap <C-w>+ 25<C-w>+
nnoremap <C-w>> 80<C-w>>
nnoremap <C-w>< 80<C-w><
nnoremap <C-y><C-h> :call CscopeTips()<cr>
inoremap  <esc>:b#<cr>
nnoremap  :b#<cr>
nnoremap <C-]> g<C-]>
xnoremap <C-]> g<C-]>
nnoremap g<C-]> <C-]>
xnoremap g<C-]> <C-]>
nnoremap cp <esc>:pclose<cr>
inoremap <C-Z> <Esc>ua
nnoremap <C-Z> u
snoremap <C-z> u
xnoremap <C-C> "+y
inoremap <C-C> <C-O>yy
xnoremap <C-X> "+x
nnoremap <leader><leader>f :let @/ = ""<CR>
inoremap <C-F1> <Esc>:call SimpleTag()<CR>a
nnoremap <C-F1> :call SimpleTag()<CR>
inoremap <C-F5> <C-O>:call MySetCurrentPath()<CR>
nnoremap <C-F5> :call MySetCurrentPath()<CR>
inoremap <C-F6> <C-O>:cal MyGoBackPath()<CR>
nnoremap <C-F6> :call MyGoBackPath()<CR>
inoremap <expr> <C-L>  pumvisible()?"\<C-L>":"<C-X><C-L>"
" nnoremap zz :clo!<CR>
" leader
noremap <leader>nu :call ToggleNu()<cr>
nnoremap <leader>se :vsplit $MYVIMRC<CR>
nnoremap <leader>ss :source $MYVIMRC<CR>
inoremap <leader>se <C-[>:vsplit $MYVIMRC<CR>
inoremap <leader>ss <C-[>:source $MYVIMRC<CR>
inoremap <leader>=t <C-[>:set guioptions+=T<CR>
inoremap <leader>-t <C-[>:set guioptions-=T<CR>
nnoremap <leader>=t :set guioptions+=T<CR>
nnoremap <leader>-t :set guioptions-=T<CR>
inoremap <leader>=m <C-[>:set guioptions+=m<CR>
inoremap <leader>-m <C-[>:set guioptions-=m<CR>
nnoremap <leader>=m :set guioptions+=m<CR>
nnoremap <leader>-m :set guioptions-=m<CR>
" for quick indent
inoremap <leader>= <esc>V=
nnoremap <leader>= V=
" quick error location
inoremap <leader>cn <esc>:cn<cr>
inoremap <leader>cl <esc>:cl<cr>
inoremap <leader>cp <esc>:cp<cr>
inoremap <leader>tp <esc>:tp<cr>
inoremap <leader>tn <esc>:tp<cr>
nnoremap <leader>cn :cn<cr>
nnoremap <leader>cp :cp<cr>
nnoremap <leader>cl :cl<cr>
nnoremap <leader>tp :tp<cr>
nnoremap <leader>tn :tp<cr>
" faster s
inoremap <leader>f <esc>:%s/<C-r>=expand("<cword>")<cr>//g<left><left>
nnoremap <leader>f :%s/<C-r>=expand("<cword>")<cr>//g<left><left>
inoremap <leader>w <Esc>:%s/\<<C-r>=expand("<cword>")<cr>\>//g<Left><Left>
nnoremap <leader>w :%s/\<<C-r>=expand("<cword>")<cr>\>//g<Left><Left>
inoremap <leader>fc <esc>:%s/<C-r>=expand("<cword>")<cr>//gc<left><left><left>
nnoremap <leader>fc :%s/<C-r>=expand("<cword>")<cr>//gc<left><left><left>
inoremap <leader>wc <Esc>:%s/\<<C-r>=expand("<cword>")<cr>\>//gc<Left><Left><Left>
nnoremap <leader>wc :%s/\<<C-r>=expand("<cword>")<cr>\>//gc<Left><Left><Left>
nnoremap <leader>wn :%s/\<<C-r>=expand("<cword>")<cr>\>//gn<cr>
xnoremap <leader>f  :<C-u>%s/<C-r>=Get_visual_selection()<cr>//g<left><left>
xnoremap <leader>fc  :<C-u>%s/<C-r>=Get_visual_selection()<cr>//gc<left><left><left>
map <silent> <leader>1 :diffget 1<CR> :diffupdate<CR>
map <silent> <leader>2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>4 :diffget 4<CR> :diffupdate<CR>
if MySys() == "windows"
inoremap <C-V> <MiddleMouse>
else
    inoremap <C-V> <C-R><C-P>+
endif

"}}}

" autocmd {{{
augroup common_au
    autocmd!
    au VIMENTER * silent exec "set vb t_vb="
  " autocmd VimLeavePre *.lua silent call SaveProject()
    " au FileType lua setlocal fileencoding=cp936
    au FileType erlang setlocal shiftwidth=2
    au FileType erlang setlocal tabstop=2
    au FileType erlang setlocal softtabstop=2
    au FileType python exec 'nnoremap <buffer> K :call ShowPyDoc(expand("<cword>"), 1)<cr>'
    au FileType python setlocal fileencodings=utf-8
    au FileType python setlocal fileencoding=utf-8
    au FileType go setlocal nolist
    au VimEnter,BufNewFile,BufReadPre *.txt,*.sh,makfile,*.lua setlocal noexpandtab
    " au VimEnter,BufNewFile,BufReadPre *.txt,*.sh,makfile,*.lua setlocal listchars=extends:>,precedes:<
    au VimEnter,BufNewFile,BufReadPre *.txt,*.sh,makfile,*.lua setlocal nolist
    au FileType javascript setlocal dictionary=d:/Vim/vimfiles/javascript.dict
augroup END

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" common command and iabbrev {{{
iabbrev slef self
iabbrev lpf lipengfei
iabbrev ksf kingsoft
iabbrev @@@ phone:18688186905   mail:lipengfei@kingsoft.com   <C-r>=strftime("%Y-%m-%d")<cr>
iabbrev cpr Copyright 2013 LiPengfei, all right reserved
" my error
iabbrev inlcude include
iabbrev gropu   group
iabbrev lcoal local
iabbrev opitonal optional

" commond
command! -nargs=1 Vsb call VsbFuntion(<f-args>)
command! -nargs=1 Go :e #<<args>                   " go to recent openfiles with num
command! -nargs=1 Rmk :source <args>               " recover from session
command! P2 :call ChangePythonVersion(2)
command! P3 :call ChangePythonVersion(3)
command! Lpj :call LoadProject()
command! Spj :call SaveProject()
command! P4 :!p4 open %
command! Mru :CtrlPMRUFiles
command! Ma :CtrlPTag
"}}}

" tmux {{{
" if exists("$TMUX")
"     set term=screen-256color
" endif
"
" if exists("$ITERM_PROFILE")
"     if exists("$TMUX")
"         let &amp;t_SI = "<Esc>[3 q"
"         let &amp;t_EI = "<Esc>[0 q"
"     else
"         let &amp;t_SI = "<Esc>50;CursorShape=1x7"
"         let &amp;t_EI = "<Esc>50;CursorShape=0x7"
"     endif
" endif
" }}}


" omnicppcomplete {{{
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype  in popup window
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1
let OmniCpp_DefaultNamespaces=["std"]
" }}}

" taglist {{{ already remove now
" let Tlist_Display_Prototype= 1
" let Tlist_Auto_Open=1
" let Tlist_Use_Right_Window=1
" let Tlist_File_Fold_Auto_Close=0
" let Tlist_Use_SingleClick = 0
" nnoremap <F4> :TlistUpdate<CR>
" nnoremap <leader>tl :Tlist<CR>
" inoremap <F4> <Esc>:TlistUpdate<CR>a
" inoremap <leader>tl <C-[>:Tlist<CR>
"}}}

" ag
let g:ag_prg = "ag --vimgrep --smart-case --file-search-regex \\\\.erl$\\\\|\\\\.proto$\\\\|\\\\.hrl$\\\\|\\\\.log$\\\\|.template$\\\\|.go$"
" let g:ag_prg = "rg --vimgrep --smart-case -g '*'.erl -g '*'.proto -g '*'.hrl  -g '*'.csv -g '*'.log -g '*'.c -g '*'.h"
let g:ag_working_path_mode='r'

" minibufexpl {{{
let g:miniBufExplModSelTarget = 1 
let g:miniBufExplTabWrap = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplCycleArround = 1
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l
noremap <C-Down>  <C-W>j
noremap <C-Up>    <C-W>k
noremap <C-Left>  <C-W>h
noremap <C-Right> <C-W>l
noremap <C-TAB>   :MBEbn<CR>
noremap <C-S-TAB> :MBEbp<CR>
inoremap <C-TAB>   <esc>:MBEbn<CR>
inoremap <C-S-TAB> <esc>:MBEbp<CR>
if MySys() == 'windows'
    imap <C-TAB> <C-[><C-TAB>
    imap <C-S-TAB> <C-[><C-S-TAB>
end
"}}}

" lua-support {{{ remove now
if MySys() == 'windows'
    let g:Lua_Interpreter = 'd:\Vim\vimfiles\compiler\lua.exe'
    let g:Lua_Compiler    = 'd:\Vim\vimfiles\compiler\luac.exe'
end
let g:Lua_OutputGvim = 'qx'
let g:Lua_AuthorName = 'lipengfei'
"}}}

" netrw {{{
let g:netrw_winsize=40
"let g:netrw_altv=1
let g:netrw_preview  = 1
let g:netrw_liststyle = 1
let g:netrw_list_hide = '^\$\w*\|\w*\.swp\w*'
let g:netrw_hide = 1
let g:netrw_browse_split=4   " 1,2,3,4
let g:netrw_menu=0
let g:netrw_use_errorwindow=0
let g:netrw_banner=0
"}}}

"  pydiction {{{
if MySys() == 'windows'
    let g:pydiction_location='d:/Vim/vimfiles/complete-dict'
else
    let g:pydiction_location=$HOME .'/.vim/complete-dict'
endif
" attention <C-F4> is run for script language
"}}}

" tcomment {{{
let g:tcommentMapLeader1='<C-f>'
"}}}

" surround {{{
xmap s S
" }}}

" " MRU {{{
" if MySys() == 'windows'
"     let MRU_File = $VIM . '\vimfiles\_vim_mru_files'
"     let MRU_Exclude_Files = '^c:\\temp\\.*'           " For MS-Windows
" else
"     let MRU_File = $HOME . '/_vim_mru_files'
"     let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
" endif
" let MRU_Auto_Close = 1
" let MRU_Add_Menu = 0
" "}}}

" ControlP {{{
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
let g:ctrlp_user_command = 'find %s -type f | grep "\.erl$\|\.proto$\|\.hrl$\|\.log$\|\.csv$\|\.go$\|\.cpp$\|\.h$\|\.c$"'
let ctrlp_mruf_max = 300
let g:ctrlp_mruf_save_on_update = 1

let g:ctrlp_map = '<C-p>'
let g:ctrlp_match_window_bottom=1
let g:ctrlp_match_window_reversed=0
let g:ctrlp_max_height=30
let g:ctrlp_by_filename=0
let g:ctrlp_regexp=1
let g:ctrlp_reuse_window='help\|quickfix'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
    \ }
let g:ctrlp_open_new_file='r'
let g:ctrlp_open_multiple_files='i'
let g:ctrlp_working_path_mode = 'ra'
"let g:ctrlp_root_makers=['.git', '.svn', '.hg', 'bzr', '_darcs']
"press F5 quick refresh chache
let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_lazy_update = 1
if MySys() == "windows"
    let g:ctrlp_cache_dir=$VIM.'/vimfiles/ctrlp'
else
    let g:ctrlp_cache_dir=$HOME ."/.ctrlp"
endif
let g:ctrlp_max_files=0
let g:ctrlp_arg_map=1
" simple help
" <C-d> troggle model file or path
" <C-r> troggle model regex
" <C-f> <C-b> search from change file mru or buffer
" <C-z> mark  <C-o> open
" }}}

" checksyntax disable it {{{
let g:checksyntax_key_single="<C-,>"
let g:checksyntax_key_all="<C-,>"
"}}}

" tagbar {{{
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_indent = 1
nnoremap <leader>tl :TagbarToggle<cr>
"}}}

" syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['lua', 'javascript', 'python', 'objc'],
                           \ 'passive_filetypes': ['puppet', 'c', 'cpp', 'erlang'] }
let g:syntastic_quiet_messages = {'level' : 'warnnings'}
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = "X"
let g:syntastic_warning_symbol = "!"
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
if MySys() == 'windows'
let g:syntastic_python_checkers = ['pyflakes']
else
    let g:syntastic_python_checkers = ['pylint']
endif
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_cpp_compiler_options = '-std=c++11'
" }}}

" vimwiki {{{
let g:vimwiki_use_mouse = 1
let g:vimwiki_folding = 'list'
" after test it can remove
" let g:vimwiki_list      = [{'path': 'D:/vimwiki/person/', 'path_html': 'D:/vimwiki/person/html/', 'template_path': 'D:/vimwiki/template/', 'template_default': 'template'},
            " \{'path': 'D:/vimwiki/linux/', 'path_html': 'D:/vimwiki/linux/html/', 'template_path': 'D:/vimwiki/template/', 'template_default': 'template'}]
" let g:vimwiki_list      = [{'path': 'D:/vimwiki/person/', 'path_html': 'D:/vimwiki/person/html/'}]
if MySys()== "windows"
   let path = 'd:/'
else
   let path = $HOME . '/.vim/'
endif
let g:vimwiki_list = [{'path': path . 'vimwiki/person/',
			\ 'template_path': path . 'vimwiki/public_html/templates/',
			\ 'template_default': 'template',
			\ 'template_ext': '.html'},
			\ {'path': path . "vimwiki/mkdown/", 
			\ 'syntax': 'markdown', 'ext': '.md', 'template_ext': 'html',}]
nmap <C-w><C-x> <Plug>VimwikiToggleListItem
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown', 
			\ '.mkd': 'markdown',
			\ '.wiki': 'media'}
let g:vimwiki_html_header_numbering = 2
"}}}

" easy-align {{{
xnoremap <silent> <cr> :EasyAlign<cr>
" }}}

" snipMate {{{
" ino  <tab> <C-r>=TriggerSnippet()<cr>
" snor <tab> <esc>i<right><C-r>=TriggerSnippet()<cr>
" }}}

" emmet {{{
let g:user_emmet_settings = {'indentation' : '    ' } 
"}}}

" delimitMate c-g g jump out to end {{{
au FileType vim,html let b:delimitMate_matchpairs = "(:),[:],{:}"
augroup scheme 
    autocmd!
    au FileType scheme,lisp let b:delimitMate_quotes = "\"" 
    au FileType scheme,lisp setlocal tabstop=2
augroup END
"}}}

" grep.vim {{{
if MySys() == 'windows'
    let Grep_Find_Path= 'findex'
    function! FindLuaInWorkPath()
        let pattern=expand("<cword>")
        let cwd = getcwd()
        if g:Grep_Cygwin_Find == 1
            let cwd = substitute(cwd, "\\", "/", "g")
        endif
        if has('win32') && !has('win32unix') && !has('win95')
            let cmd = g:Grep_Find_Path . ' "' . cwd . '"' . ' -name "*.lua" | xargs grep -in "\\<' . pattern . '\\>"'
            echo cmd
        endif
        call s:RunGrepCmd(cmd, pattern, "")
    endfunction

    function! FindInWorkPathVisual()
        let pattern=Get_visual_selection()
        let cwd = getcwd()
        if g:Grep_Cygwin_Find == 1
            let cwd = substitute(cwd, "\\", "/", "g")
        endif
        if has('win32') && !has('win32unix') && !has('win95')
            " let cmd = g:Grep_Find_Path . ' "' . cwd . '"' . ' -name '. '"*.lua" '. '| xargs grep -in "' . pattern . '"'
            let cmd = g:Grep_Find_Path . ' "' . cwd . '"' . ' -name ' . '"*.c *.h *.cpp" ' . '| xargs grep -in "' . pattern . '"'
            echo cmd
        endif
        call s:RunGrepCmd(cmd, pattern, "")
    endfunction

endif

let Grep_Default_Options = ''
let Grep_Skip_Files = "*.bak *.swp *~"
let Grep_Default_Filelist = "*.c *.cpp *.h *.hpp *.lua *.cs *.asm *.vim *.php *.go"
if MySys() == 'windows'
    let Grep_Find_Path = 'findex'
endif
" }}}
if IsVundle() == 'vundle'
"ycm {{{ .ycm_extra_conf.py
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_open_loclist_on_ycm_diags = 0
let g:ycm_show_diagnostics_ui = 1
" let g:ycm_filetype_specific_completion_to_disable = {
"         \ 'text': 1
"         \}
let g:ycm_auto_trigger = 1
if MySys()== "windows"
    let g:ycm_error_symbol = 'X'
    let g:ycm_warning_symbol = "!"
else
    let g:ycm_error_symbol = ">>"
    let g:ycm_warning_symbol = ">"
end
" let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_key_invoke_completion = '<c-j>'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" let g:ycm_global_ycm_extra_conf = $HOME.'/.ycm_extra_conf.py'
"" Do not ask when starting vim
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <leader><leader>r :YcmDiags<CR>
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
"}}}

" ultisnip {{{
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsListSnippets='<C-y><C-j>'
let g:UltiSnipsJumpForwardTrigger='<C-y>n'
let g:UltiSnipsJumpBackwardTrigger='<C-y>N'
" }}}

" listtoggle {{{
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_height = 10
" }}}

" ctrlspace {{{
set nocompatible
set hidden
set showtabline=0
" let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
let g:CtrlSpaceGlobCommand = 'ag ag --vimgrep --smart-case --file-search-regex \\\\.erl$\\\\|\\\\.proto$\\\\|\\\\.hrl$\\\\|\\\\.log$ ""'
let g:CtrlSpaceSearchTiming = 500
let g:CtrlSpaceDefaultMappingKey = "<leader>d"
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSaveWorkSapceOnSwitch = 0
let g:CtrlSpaceUseUnicode = 0
" }}}


" vundle {{{
if MySys() == 'windows'
    set rtp+=$Vim/vimfiles/bundle/Vundle.vim/
    let path="$Vim/vimfiles/bundle"
    call vundle#begin(path)
else
    set rtp+=~/.vim/bundle/Vundle.vim/
    let path=$HOME. '/.vim/bundle'
    call vundle#begin(path)
endif

" Bundle 'petdance/ack'
Bundle 'rking/ag.vim'
" Bundle 'dyng/ctrlsf.vim'
" Bundle 'yonchu/accelerated-smooth-scroll'
Bundle 'airblade/vim-gitgutter'
Bundle 'gmarik/vundle'
Bundle 'vim-scripts/L9'
Bundle 'taxilian/a.vim'
" Bundle 'itchyny/calendar.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'mattn/emmet-vim'
" Bundle 'othree/html5.vim'
" Bundle 'othree/html5-syntax.vim'
Bundle 'mbriggs/mark.vim'
" Bundle 'vim-scripts/mru.vim'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
" Bundle 'vim-scripts/python_fold'
" Bundle 'vim-scripts/tornadotmpl.vim'
" Bundle 'vim-scripts/indentpython.vim'
" Bundle 'othree/vim-autocomplpop'
" Bundle 'scrooloose/syntastic'
Bundle 'majutsushi/tagbar'
Bundle 'vim-scripts/tComment'
Bundle 'vim-scripts/vim-easy-align'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'bumaociyuan/vim-matchit'
Bundle 'tpope/vim-surround'
" Bundle 'vimwiki/vimwiki'
Bundle 'fholgado/minibufexpl.vim'
" Bundle 'pangloss/vim-javascript'
" Bundle 'maksimr/vim-jsbeautify'
" Bundle 'vim-scripts/grep.vim'
Bundle 'vim-scripts/sh.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Valloric/ListToggle'
Bundle 'jimenezrick/vimerl'
Bundle 'lipengfei'
Bundle 'fatih/vim-go'
Bundle 'Vundle.vim'
Bundle 'vim-ctrlspace/vim-ctrlspace'
" Bundle 'vim-scripts/OmniCppComplete'
" Bundle 'rkulla/pydiction'
" Bundle ' pythoncomplete'
call vundle#end()
"}}}
endif
"""{{{
filetype plugin indent on
filetype plugin on
if IsVundle() == 'vundle'
  filetype on
endif
colorscheme molokai

set wildignore+=.git           " should not break clone
set wildignore+=.git/*         " should not break clone
set wildignore+=README
set wildignore+=*.md
set wildignore+=*.markdown
set wildignore+=.gitignore
"}}}

" Note and change log {{{
" 1. change vim74\ftplugin\python.vim python 2 python3        2013-10-15
"    installed pyflakes for syntastic

" 2. [I has not been used, need to have a try                 2013-10-17

" 3. remove sparkup from plugin and add emmet.vim             2013-10-19
"    add indent javascript.vim
"    add plugin jsbeautify.vim
"    add javascript.dict
"    add javascript lint for syntastic
"    add match-it plugin.
"
" 4. add css.vim to vimfiles/after/syntax directory          2013-10-24
"
" 5. add html5.vim and html5-syntax plugin                   2013-10-27
"
" 6. add function to change pythonomnifunc from 2 to 3 or 3 to 2, and add " command for it.  :P2 and :P3. 
" add ,pc to close preview window                            2013-11-07
"
" 7. add {% %} for tornado syntax                            2014-07-28
"    add grep.vim for linux                                  2014-09-15

" 8. add search map number                                   2014-10-28

" 9. remove pydoc                                            2015-05-12
" }}}
