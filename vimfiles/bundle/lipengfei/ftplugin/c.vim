set ts=4                        "tab键空格个数
set expandtab                   "tab转为空格 
set cinoptions={0,:0,g0,l1,t0,(0 " 访问缩进

nnoremap <buffer> <leader>b :call Do_CsTag()<CR>
inoremap <buffer> <leader>b <Esc>:call Do_CsTag()<CR><CR>a

" for cscope 
"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
"g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
"d: 查找本函数调用的函数
"c: 查找调用本函数的函数
"t: 查找指定的字符串
"e: 查找egrep模式，相当于egrep功能，但查找速度快多了
"f: 查找并打开文件，类似vim的find功能
"i: 查找包含本文件的文件

nnoremap <buffer> <m-g>s       :cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>g       :cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>c       :cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>t       :cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>e       :cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <m-g>f       :cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <m-g>i       :cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <m-g>d       :cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>s  <Esc>:cclose<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>g  <Esc>:cclose<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>c  <Esc>:cclose<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>t  <Esc>:cclose<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>e  <Esc>:cclose<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
inoremap <buffer> <m-g>f  <Esc>:cclose<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
inoremap <buffer> <m-g>i  <Esc>:cclose<CR>:cs find i <C-R>=expand("<cfile>")<CR><CR>
inoremap <buffer> <m-g>d  <Esc>:cclose<CR>:cs find d <C-R>=expand("<cword>")<CR><CR>

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
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"
    endif

    if(executable('cscope') && has("cscope") )
        " ver 1
        if(MySys()!='windows')
            silent! execute "!find . -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp' > cscope.files"
        else
            let cwd = getcwd()
            silent! execute "!findex.exe " . cwd . " -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp  -o ! -path \"./DevEnv/*\" -o ! -path \"./.git/*\"' > cscope.files"
        endif
	
	" ver 2
	" if(MySys()!='windows')
        "     " let l:cmd = "!find " . getcwd() . " -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp' > cscope.files"
        "     " silent! execute "!find . -name '*.hpp' -o -name '*.h' -o -name '*.c' -o -name '*.cpp' > cscope.files"
        "     " silent! execute l:cmd
        " else
        "     silent! execute "!dir /s/b *.hpp *.c,*.cpp,*.h,* >> cscope.files"
        " endif
            
	silent! execute "!cscope -bq"
        execute "normal :"

        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
     endif
endfunction

" cscope 不需要添加目录,你包含的目录会自动添加,很好

if MySys() == 'windows'
    setlocal tags+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 11.0/VC/include/tags
    setlocal tags+=C:/Program\\\ Files/MySQL/MySQL\\\ Server\\\ 5.0/include/tags
    setlocal path+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 11.0/VC/include
    setlocal path+=C:/Program\\\ Files/MySQL/MySQL\\\ Server\\\ 5.0/include
    setlocal path+=C:/Program\\\ Files/Lua/5.1/include
else
    setlocal tags+=~/.vim/tags/stl.tags
    setlocal tags+=~/.vim/tags/cpp.tags
    setlocal tags+=~/.vim/tags/c.tags
    setlocal tags+=~/.vim/tags/gl.tags
    setlocal path+=/usr/local/include
    setlocal path+=/usr/include/c++/4.8.3/
endif

"====================================================
" fold
"====================================================
setlocal foldmethod=indent
setlocal foldmethod=syntax
" setlocal foldlevel=1
setlocal foldtext=v:folddashes.substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')

inoremap <buffer> <M-;> <C-O>A;
inoremap <buffer> <C-;> <C-O>A;

"====================================================
" for mymistake
"====================================================
iabbrev <buffer> Include include
iabbrev <buffer> inlcude include
