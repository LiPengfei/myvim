"========================================================
" highlight functions
"========================================================
syn match my_cppFunction1 /\<\h\w*\>\s*(/me=e-2
syn match my_cppFunction2 /\<\h\w*(/me=e-1
syn match my_cppFunction3 /\<::\>\s*<\h\w*\>s*(/me=e-2
syn match my_cppFunction4 /\<::\h\w*\>s*(/me=e-2


syn match my_cppFunction5 /\<::\h\w*(/me=e-1

"hi my_cppFunction1 gui=NONE guifg=#B5A1FF
hi my_cppFunction1 gui=NONE guifg=#A5A1FF
hi link my_cppFunction2 my_cppFunction1
hi link my_cppFunction3 my_cppFunction1
hi link my_cppFunction4 my_cppFunction1
hi link my_cppFunction5 my_cppFunction1

"========================================================
" hightlight all math operators
"========================================================
syn match cppMathOperator1  display "[-+\*%=&\~|\^]=\="
syn match cppMathOperator2  display "\</\>\|\</=\>"
syn match cppMathOperator3  display "/\|/="
syn match cppPtrOperator    "\.\|->"
syn match cppLogicOperator1 display "[><!=]=\="
syn match cppLogicOperator2 display "||\|&&"

hi link cppMathOperator1  operator
hi link cppMathOperator2  operator
hi link cppMathOperator3  operator

hi link cppPtrOperator    operator
hi link cppLogicOperator1 operator
hi link cppLogicOperator2 operator

"========================================================
" common STL class typedefine
"========================================================
syn keyword stlType string map set vector list
hi link stlType type
