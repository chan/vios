
function! wrapper#rm#init(func, ...)
    exec 'let val = call(s:wrapperrm.'.a:func.', a:000, s:wrapperrm)'
    return val
endfunction

let s:wrapperrm = {}

function! s:wrapperrm.all(dir, interactive, ...)
    let curdir = getcwd()
    if a:interactive == 1
        call Msg("norm", ["Choose a directory : "
            \, "A single dot means the current directory"
            \, "Hit the tab key for completion" 
            \, "Enter cansels the operation"])
        let dir = input("Directory :", "", "dir")
        if empty(dir)
            return
        elseif dir == "."
            let dir = curdir
        endif
        call Msg("norm", ["An optional glob (leave empty to remove everything) : "])
        let glob = input("", "", "file")
        let filelist = ["-i"]
    else
        if a:dir == "."
            let dir = getcwd()
        else
            let dir = expand(a:dir)
        endif
        if exists("a:1") && !empty(a:1)
            let glob = a:1
        else
            let glob = "*"
        endif
        let filelist = []
    endif
    if !isdirectory(dir)
        call Msg("err", [dir.': Not a directory'])
        return -1
    else
        if curdir != dir
            exec "cd ".dir
        endif
        let filelist += lib#filelist#init('indir', empty(glob) ? "*" : glob)['file']
        let excode = system#rm#init('list', filelist)
        exec "cd ".curdir
        return excode
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
