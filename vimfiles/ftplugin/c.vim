set ts=4                        "tab键空格个数
set expandtab                   "tab转为空格 

nnoremap <buffer> <C-F1> :call Do_CsTag()<CR>
inoremap <buffer> <C-F1> <Esc>:call Do_CsTag()<CR><CR>a

" for cscope 
"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
"g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
"d: 查找本函数调用的函数
"c: 查找调用本函数的函数
"t: 查找指定的字符串
"e: 查找egrep模式，相当于egrep功能，但查找速度快多了
"f: 查找并打开文件，类似vim的find功能
"i: 查找包含本文件的文件

" nnoremap <buffer> <M-f>s       :cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" nnoremap <buffer> <M-f>g       :cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
" nnoremap <buffer> <M-f>c       :cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" nnoremap <buffer> <M-f>t       :cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" nnoremap <buffer> <M-f>e       :cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" nnoremap <buffer> <M-f>f       :cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>:clist<CR>
" nnoremap <buffer> <M-f>i       :cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>:clist<CR>
" nnoremap <buffer> <M-f>d       :cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>s  <Esc>:cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>g  <Esc>:cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
" inoremap <buffer> <M-f>c  <Esc>:cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>t  <Esc>:cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>e  <Esc>:cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>f  <Esc>:cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>i  <Esc>:cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>:clist<CR>
" inoremap <buffer> <M-f>d  <Esc>:cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>:clist<CR>

nnoremap <buffer> <M-g>s       :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <M-g>g       :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <M-g>c       :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <M-g>t       :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <M-g>e       :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <M-g>f       :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <M-g>i       :cs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <M-g>d       :cs find d <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <M-g>s  <Esc>:cs find s <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <M-g>g  <Esc>:cs find g <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <M-g>c  <Esc>:cs find c <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <M-g>t  <Esc>:cs find t <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <M-g>e  <Esc>:cs find e <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <M-g>f  <Esc>:cs find f <C-R>=expand("<cfile>")<CR><CR>
inoremap <buffer> <M-g>i  <Esc>:cs find i <C-R>=expand("<cfile>")<CR><CR>
inoremap <buffer> <M-g>d  <Esc>:cs find d <C-R>=expand("<cword>")<CR><CR>

function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(MySys()=='windows')
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif

    if has("cscope")
        silent! execute "cs kill -1"
    endif

    if filereadable("cscope.files")
        if(MySys()=='windows')
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif

    if filereadable("cscope.out")
        if(MySys()=='windows')
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif

    if(executable('ctags'))
        silent! execute "!ctags --exclude=.git --exclude=.svn --exclude=DevEnv -R --c-types=+p --fields=+S *"
        silent! execute "!ctags --exclude=.git --exclude=.svn --exclude=DevEnv -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"
    endif

    if(executable('cscope') && has("cscope") )
        if(MySys()!='windows')
            silent! execute "!find . -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp' > cscope.files"
            silent! execute "!cscope -bq"
        else
            let cwd = getcwd()
            " silent! execute "!dir /s/b *.hpp *.c,*.cpp,*.h,* >> cscope.files"
            silent! execute "!findex.exe " . cwd . " -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp  -o ! -path \"./DevEnv/*\" -o ! -path \"./.git/*\"' > cscope.files"
            silent! execute "!cscope -bq"
        endif
        execute "normal :"

        if filereadable("cscope.out")
            " execute "cs add cscope.out -q"
            execute "cs add cscope.out"
        endif
    endif
endfunction

if MySys() == 'windows'
	setlocal tags+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 11.0/VC/include/tags
	setlocal tags+=C:/Program\\\ Files/MySQL/MySQL\\\ Server\\\ 5.0/include/tags
    setlocal path+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 11.0/VC/include
    setlocal path+=C:/Program\\\ Files/MySQL/MySQL\\\ Server\\\ 5.0/include
    setlocal path+=C:/Program\\\ Files/Lua/5.1/include
else
    setlocal tags+=~/tags/tags.linux
    setlocal path+=/usr/local/include
endif

"====================================================
" fold
"====================================================
setlocal foldmethod=indent
setlocal foldmethod=syntax
" setlocal foldlevel=1
setlocal foldtext=v:folddashes.substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')

function! OpenZFAndSetmap()
    :normal zR

    if MySys() == 'windows'
        :nnoremap <buffer> <leader>sf :vsp D:\Vim\vimfiles\ftplugin\cpp.vim<CR>
        :inoremap <buffer> <leader>sf <C-[>:vsp D:\Vim\vimfiles\ftplugin\cpp.vim<CR>
    else
        :nnoremap <buffer> <leader>sf :vsp ~/.vim/ftplugin/cpp.vim<CR>
        :nnoremap <buffer> <leader>sf <C-[>:vsp ~/.vim/ftplugin/cpp.vim<CR>
    endif
endfunction

autocmd BufWinEnter *.cpp,*.h  silent call OpenZFAndSetmap()

inoremap <buffer> <leader>te <C-O>:Vexplore<CR> 
nnoremap <buffer> <leader>te :Vexplore<CR>
inoreabbrev <buffer> /**** /***************************************************/<CR>/***************************************************/<UP>

inoremap <buffer> #ifn #ifndef<Space><CR>#define<Space><CR><CR>#endif<Up><Up><Up><Right><Right>
" inoremap <buffer> { {}<Left><CR><Up><Right>
" inoremap <buffer> {} { }
inoremap <buffer> <leader>cls class<CR>;<Left>{<CR><CR>}<Up><Up><Up><Right><Right><Right><Right><Space>
inoremap <buffer> ( ()<Left>
inoremap <buffer> () ()
inoremap <buffer> [ []<Left>
inoremap <buffer> [] []
inoremap <buffer> " ""<Left>
inoremap <buffer> "" ""
inoremap <buffer> ' ''<Left>
inoremap <buffer> '' ''
inoremap <buffer> <M-;> <C-O>A;
inoremap <buffer> <C-;> <C-O>A;

"====================================================
" for mymistake
"====================================================
iabbrev <buffer> Include include
iabbrev <buffer> inlcude include

