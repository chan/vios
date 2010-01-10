
function! system#mkdir#init(func, ...)
    exec 'let val = call(s:mkdir.'.a:func.', a:000, s:mkdir)'
    return val
endfunction

let s:mkdir = {}

function! s:mkdir.main(dir, ...)
    if exists("a:1")
        let mode = a:1
    else
        let mode = 0755
    endif
    if !isdirectory(a:dir)
        try
            call mkdir(a:dir, 'p', mode)
            call Msg('norm', ['Creating '.a:dir.': Succeeded'])
        catch /^Vim\%((\a\+)\)\=:E739/
            call Msg('err', ['Creating '.a:dir.': Failed'
                \, 'VIM EXCEPTION is: '.v:exception])
            return -1
        endtry
    else
        call Msg('warn', [a:dir.": already exists"])
    endif
endfunction
" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
