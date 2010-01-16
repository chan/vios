
function! wrapper#rm#init(func, ...)
    exec 'let val = call(s:wrapperrm.'.a:func.', a:000, s:wrapperrm)'
    return val
endfunction

let s:wrapperrm = {}

function! s:wrapperrm.all(dir, interactive)
    if a:dir == "."
        let dir = getcwd()
    else
        let dir = expand(a:dir)
    endif
    if !isdirectory(dir)
        call Msg("err", [dir.': Not a directory'])
        return -1
    else
        let filelist = lib#filelist#init('main', dir)['file']
        if a:interactive == 1
            let filelist = insert(filelist, '-i')
        endif
        let curdir = getcwd()
        if curdir != dir
            exec "cd ".dir
            let excode = system#rm#init('list', filelist)
            exec "cd ".curdir
            return excode
        else
            return system#rm#init('list', filelist)
        endif
    endif
endfunction

function! s:wrapperrm.filelist(interactive, ...)
    let filelist = []
    for file in a:000
        let filelist += [file]
    endfor
    if a:interactive == 1
        call insert(filelist, "-i")
    endif
    return system#rm#init('list', filelist)
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
