" ----------------------------------------------------------------------
"
"    File: repair-S.vim
"  Author: fbigun <rsdhlz@qq.com>
" Version: 1.0.0
"
" Description:
"     1. Delete Trailing White Space
"     2. With the plug-in fbigun/template-load `func lastmod
"
"
" License:
"     This file is placed in the public domain.
"
" ----------------------------------------------------------------------

if exists("g:loaded_repair_S")
    finish
endif
let g:loaded_repair_S = 1



function! DeleteTrailingWhiteSpace() "{{{2
    normal mZ
    %s/\s\+$//e
    normal `Z
    let line_number = line('$')
    while 1
        if getline(line_number) == ''
            exec line_number . ',' . line_number .'g/^\s*$/d'
            let line_number -= 1
        else
            break
        endif
    endwhile
    unlet line_number
endfunction

function! LastMod() "{{{2
    let l:line = line(".")
    let l:col = col(".")
    "let a:save_cursor = getpos('.')
    let fileNameModify = 'filename'
    let l:l = min([line("$"), 10])
    exec '1,' . l:l . 'substitute/' . '^\(.*Date:\?\s*:\?\s*\).*$' . '/\1' .
                \ strftime('%c', getftime(expand('<afile>:p'))) . '/e'
    exec '1,' . l:l . 'substitute/' . '^\(.*File:\?\s*:\?\s*\).*$' . '/\1' .
                \ expand('<afile>:t') . '/e'
    call cursor(l:line, l:col)
    "call setpos('.', a:save_cursor)
endfunction

"if !exists("autocommands_loaded")
"    let autocommands_loaded = 1
    au FileWritePre * set bin
    au FileWritePost * set nobin
    au BufWritePost,FileWritePost * call LastMod()
    au BufWrite *
                \ if &ft != 'markdown'
                \ | call DeleteTrailingWhiteSpace()
                \ | endif
"endif
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
