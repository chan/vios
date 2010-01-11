command! -complete=file -nargs=* Cp echo wrapper#cp#init('main', <f-args>)
command! -complete=dir  -nargs=* CpFilesFromDirToDir echo wrapper#cp#init('files', <f-args>)
command! CpHelp echo s:help

let s:help = "CpFilesFromDirToDir: takes two args and an optional (glob)\n
        \({src directory}, {destination}, [ {glob}])"

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
