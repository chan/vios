
command! -complete=file -nargs=* Rmfilelist :echo wrapper#rm#init('filelist', 0, <f-args>)
command! -complete=file -nargs=* Rmfilelistinteractive :echo wrapper#rm#init('filelist', 1, <f-args>)
command! -complete=file -nargs=1 Rmfile :echo system#rm#init('file', <f-args>)
command! -complete=file -nargs=1 Rmall  :echo wrapper#rm#init('all', <f-args>, 0)
command! -complete=file -nargs=1 Rmallinteractive :echo wrapper#rm#init('all', <f-args>, 1)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
