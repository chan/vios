
function! lib#filelist#init(func, ...)
    exec 'let val = call(s:filelist.'.a:func.', a:000, s:filelist)'
    return val
endfunction

let s:filelist = {}

function! s:filelist.indir(filter)
    let dic = {}
    for i in ['file', 'dir', 'link', 'cdev', 'bdev', 'socket', 'fifo', 'other']
        let dic[i] = []
    endfor
    let list = split(glob(a:filter), "\n")
    for filename in list
        let type = getftype(filename)
        if !empty(type)
            call add(dic[type], filename)
        endif
    endfor
    return dic
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
