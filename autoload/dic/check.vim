
function! dic#check#init(func, ...)
    exec 'let val = call(s:check.'.a:func.', a:000, s:check)'
    return val
endfunction

let s:check = {}

function! s:check.keys(dic, listkeys)
    if type(a:dic) != type({})
        call Msg("err", ["Error returned from check.keys", "arg1 should be a dictionary"])
        return -1
    endif
    if type(a:listkeys) != type([])
        call Msg("err", ["Error returned from check.keys", "arg2 should be a list"])
        return -1
    endif
    for item in a:listkeys
        if !exists('a:dic[item]')
            call Msg("err", [item.": doesn't exists in dictionary"])
            return -1
        endif
    endfor
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
