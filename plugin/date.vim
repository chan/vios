
command! -nargs=* Date :echo time#date#init('print', <f-args>)
command! -nargs=* Dateshowfmt  :echo time#date#init('showfmt', <f-args>)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
