" *************************************************
" Description -    
" Author -        elunix
" Email -         elunix at gmail dot com
" Date -          18 Dec 2009 19:56:03
" Last modified:  
" Usage:           
" References:      
" License: GPL3
" *************************************************

function! scratch#buffer(name, pos, width, bufhidden)
    execute a:pos.' '.a:width.'split \['.a:name.'\]'
    setlocal noswapfile
    setlocal buftype=nofile
    exec 'setlocal bufhidden='.a:bufhidden
    setlocal nonumber
    setlocal modifiable
    setlocal tabstop=4
    setlocal nofoldenable
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
