
function! net#curl#init(func, ...)
    exec 'let val = call(s:curl.'.a:func.', a:000, s:curl)'
    return val
endfunction

let exec = system#which#init('lookin', ['/usr/bin', '/usr/local/bin'], 'curl')
if exec == -1
   call Msg("err", ['Couldn''t find the curl executable'])
   finish
endif

let s:curl = {}
 
let s:curl = {
        \  'exec'    : exec.' -C - -L -s -f'
        \, 'codes'   : expand("$HOME")."/.vim/data/curl_excodes.dat"
        \, 'stdout'  : "\\nUrl:\\t\%{url_effective}\\nTime:\\t\%{time_total}
                       \\\nSize:\\t\%{size_download}\\nSpeed:\\t\%{speed_download}
                       \\\nType:\\t\%{content_type}\\n"
        \, 'defdir'  : "/tmp/"
        \ }

unlet exec

function! s:curl.download(dic)
    let savetodir = empty(a:dic['savetodir']) ? self['defdir'] : a:dic['savetodir']
    let baseurl = a:dic['baseurl']
    let remotefilename = a:dic['remotefilename']
    let localfilename = a:dic['localfilename']
    let verbose = a:dic['verbose']
    let timeouttoconnect = a:dic['timeouttoconnect']
    let maxtimetofetch = a:dic['maxtimetofetch']
    if !empty(timeouttoconnect)
        let self['exec'] .= " --connect-timeout ".timeouttoconnect
    endif
    if !empty(maxtimetofetch)
        let self['exec'] .= " --max-time ".maxtimetofetch
    endif
    let command = self['exec']." ".baseurl.remotefilename." -o ".savetodir.localfilename
    if verbose == 1
        let command .= ' -w "'.self['stdout'].'"'
        call Msg("norm", [" ", "Downloading ".remotefilename.' from '.baseurl
            \, "into ".savetodir])
        echo system(command)
    else
        call system(command)
    endif
    if v:shell_error != 0
        let codes = file#read#init('vimscript', self['codes'])
        let saved_reg = @9
        let @9 = join(codes, "\n")
        :@9
        call Msg("err", ['Couldn''t download '.baseurl.remotefilename
                \, "Exit code : ".curlexcodes[v:shell_error]])
        let @9 = saved_reg
        return -1
    endif
endfunction
            
" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
