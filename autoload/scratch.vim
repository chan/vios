
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
