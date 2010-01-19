
function! wrapper#ls#init(func, ...)
    exec 'let val = call(s:wrapperls.'.a:func.', a:000, s:wrapperls)'
    return val
endfunction

let s:wrapperls = {}

function! s:wrapperls.main(dir, sort, show)
    let curdir = getcwd()
    if a:dir == "\." || empty(a:dir) == 1
        let dir = fnamemodify(curdir, ":p")
        let glob = "*"
    elseif isdirectory(a:dir)
        let dir = fnamemodify(a:dir, ":p")
        let glob = "*"
    elseif match(a:dir, '/') == -1
        let dir = fnamemodify(curdir, ":p")
        let glob = a:dir
    else
        let string = a:dir
        let match = match(string, '/')
        let dir = strpart(string, 0, match + 1)
        while match(string, '/', match + 1) != -1
            let match = match(string, '/', match + 1)
            let dir = strpart(string, 0, match  + 1)
        endwhile
	    let glob = strpart(string, match + 1)
    endif
    try
        exec "cd ".dir
    catch /^Vim\%((\a\+)\)\=:E344/
        call Msg("err", ['Can''t change directory', dir.' : Directory doesn''t exists'])
        return -1
    endtry
    let dic = { "dir" : dir, "sort" : a:sort, "show" : a:show, "glob" : glob}
    let report = system#ls#init('main', dic)
    if getcwd() != curdir
        exec "cd ".curdir
    endif
    return report
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
