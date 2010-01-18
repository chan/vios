
command! -complete=file -nargs=* Cp :echo wrapper#cp#init('main', <f-args>)
command! -complete=file -nargs=* Cpfilesfromdirtodir :echo wrapper#cp#init('files', <f-args>)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
