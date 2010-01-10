
function! Msg(...)
    exec 'let val = call(s:msg.main, a:000, s:msg)'
    return val
endfunction

let s:msg = {}

function! s:msg.main(type, list, ...)
    if type(a:list) != type([])
        let aerrmsg = ['ERR: calling the msg#main function'
                \, 'The second argument should be a list'] 
        return self.main('err', aerrmsg, 'no')
    else
        let dic = {
            \  'warn' : ['v:warningmsg', 'WarningMsg']
            \, 'norm' : ['v:statusmsg', 'Normal']
            \, 'err'  : ['v:errmsg', 'ErrorMsg']}
        if has_key(dic, a:type) == 1
            let list = a:list
            exec "echohl ".dic[a:type][1]
            while len(list) < 2
                let list += ['']
            endwhile
            for msg in list
                echomsg msg
            endfor
            echohl NONE
            " if we want to store the message in the correspondig variable
            " check for an optional argument 
            if exists("a:1") == 0
                let {dic[a:type][0]} = join(a:list, "\n")
            endif
        else
            let berrmsg = ['ERR: calling the Msg(...) function'
                    \, 'The first argument should be a string.'
                    \, 'Valid values are:'.join(keys(dic), ', ')]
            let v:errmsg = join(berrmsg, "\n")
            return self.main('err', berrmsg, 'no')
        endif
    endif
    return join(a:list, "\n")
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
