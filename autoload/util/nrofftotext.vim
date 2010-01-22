
function! util#nrofftotext#main(file)
    if empty(a:file)
        let list = getline(1, line("$"))
    else
        let list = readfile(fnamemodify(a:file, ":p"))
    endif
    echo list
    call scratch#buffer("ManPage", 'bo', 30, "hide")
    0put = list
    %!nroff -man
    %s/\[\d\+m//g
    setlocal ft=man
    only
    normal gg
    setlocal nolist
    setlocal title
    setlocal titlestring=%Y"
    setlocal nofoldenable
    setlocal nonumber
    map <buffer> q :bd<CR>
    noremap <buffer> <Space> <PageDown>
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
