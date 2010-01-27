
function! wrapper#curl#init(func, ...)
    exec 'let val = call(s:wrappercurl.'.a:func.', a:000, s:wrappercurl)'
    return val
endfunction

let s:wrappercurl = {}
let s:wrappercurl['defdir'] = '/tmp/'

function! s:wrappercurl.dlsources(url, to)
    let dic = {
        \  'savetodir'        : !empty(a:to) ? fnamemodify(a:to, ":p") : self['defdir']
        \, 'baseurl'          : fnamemodify(a:url, ":h")."/"
        \, 'remotefilename'   : fnamemodify(a:url, ":t")
        \, 'localfilename'    : fnamemodify(a:url, ":t")
        \, 'verbose'          : 1
        \, 'timeouttoconnect' : ''
        \, 'maxtimetofetch'   : ''
        \ }
    if !isdirectory(dic['savetodir'])
        call Msg("err", [dic['savetodir']." : Not a directory"])
        return -1
    endif
    let exitcode = net#curl#init('download', dic)
    if exitcode != -1
        let fileexec = system#which#init('main', 'file')
        if fileexec != -1
            let ishtml = system(fileexec." ".dic['savetodir'].dic['localfilename'])
            if match(ishtml, '\C HTML document') != -1
                call Msg("err", ['The file is a html document'])
                return -1
            endif
        else
            call Msg("war", ['The file executable couldn''t be found in PATH'
                        \,   'Can''t check if '.dic['localfilename']." is not a html document"])
        endif
    else
        return -1
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
