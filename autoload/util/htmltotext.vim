
function! util#htmltotext#main(file)
    if empty(a:file)
        let list = getline(1, line("$")) 
    else
        let list = readfile(fnamemodify(a:file, ":p"))
    endif
    call scratch#buffer("HtmlToText", 'bo', 30, "hide")
    0put = list
    %!vilistextum -u -l - -
    only
    normal gg
    setlocal nofoldenable
    setlocal nonumber
    map <buffer> q :bd<CR>
    noremap <buffer> <Space> <PageDown>
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
