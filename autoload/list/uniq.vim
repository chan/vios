
function! list#uniq#init(func, ...)
    exec 'let val = call(s:uniq.'.a:func.', a:000, s:uniq)'
    return val
endfunction

let s:uniq = {}

function! s:uniq.main(list)
    if type(a:list) != type([])
        call Msg("err", ['The uniq main function returned an error'
                    \,   'Argument should be a list'])
        return -1
    endif
    let dic = {}
    for item in a:list
        if ((type(item) != type(''))
            \ && (type(item) != type(0))
            \ && (type(item) != type(0.0)))
            call Msg("err", ['Error returned by uniq.main'
                        \,   'Item in list is not a number nor a string'])
            return -1
        else
            let dic[string(item)] = item
        endif
    unlet item
    endfor
    return values(dic)
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
