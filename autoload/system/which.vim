
function! system#which#init(func, ...)
    exec 'let val = call(s:which.'.a:func.', a:000, s:which)'
    return val
endfunction

let s:which = {}

function! s:which.main(exec)
    let saved_suffixesadd = &suffixesadd
    let saved_path = &path
    let &path = substitute($PATH, ':', ',', 'g')
    let findexec = findfile(a:exec)
    if empty(findexec) == 0
        let exec = fnamemodify(findexec, ":p")
    else
        let exec = -1
    endif
    let &path = saved_path
    let &suffixesadd = saved_suffixesadd
    return exec
endfunction 

function! s:which.lookin(dirlist, exec)
    let saved_path = $PATH
    let $PATH = join(a:dirlist, ":").':'.$PATH
    let excode = self.main(a:exec)
    let $PATH = saved_path
    return excode
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
