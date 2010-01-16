
function! system#mv#init(func, ...)
    exec 'let val = call(s:mv.'.a:func.', a:000, s:mv)'
    return val
endfunction

let s:mv = {}

function! s:mv.main(from, to)
    let from = expand(a:from)
    if isdirectory(from)
        call Msg("err", ['Moving direcctories is not possible'])
        return -1
    else
        if filereadable(from) == 0
            call Msg("err", [a:from.': Doesn''t exists'])
            return -1
        endif
    endif 
    let to = expand(a:to)
    if isdirectory(fnamemodify(to, ":p"))
        let to = to."/".fnamemodify(from, ":p:t")
        return self.rename(from, to)
    else
        let todir =fnamemodify(to, ":p:h") 
        if !isdirectory(todir)
            call Msg("err", [todir.": Not a directory"])
            return -1
        else
            return self.rename(from, to)
        endif
    endif
endfunction

function! s:mv.rename(from, to)
    if filereadable(a:to) == 1
        if confirm(a:to.": exists\nOverwrite? :", "&Yes\n&No") == 2
            call Msg('warn', ['... aborting'])
            return
        else
            if rename(a:from, a:to) == 0
                call Msg("norm", [a:from.' --> '.a:to.' (SUCCEEDED)'])
            else
                call Msg("err", [a:from.' --> '.a:to.' (FAILED)'])
                return -1
            endif
        endif
    else
        if rename(a:from, a:to) == 0
            call Msg("norm", [a:from.' --> '.a:to.' (SUCCEEDED)'])
        else
            call Msg("err", [a:from.' --> '.a:to.' (FAILED)'])
            return -1
        endif
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
