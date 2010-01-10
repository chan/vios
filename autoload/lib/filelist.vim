
function! lib#filelist#init(func, ...)
    exec 'let val = call(s:flist.'.a:func.', a:000, s:flist)'
    return val
endfunction

let s:flist = {}

function! s:flist.main(dir, ...)
    let todir = expand(a:dir)
    let curdir = getcwd()
    let dic = {}
    for i in ['file', 'dir', 'link', 'cdev', 'bdev', 'socket', 'fifo', 'other']
        let dic[i] = []
    endfor
    exec "cd ".todir
    let list = !exists("a:1") ? split(glob("*"), "\n") : split(glob(a:1), "\n")
    for filename in list
        let type = getftype(filename)
        if !empty(type)
            call add(dic[type], filename)
        endif
    endfor
    exec "cd ".curdir
    return dic
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
