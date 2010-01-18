
command! -complete=file -nargs=* Rmfiles :echo wrapper#rm#init('filelist', 0, <f-args>)
command! -complete=file -nargs=* Rmfilesinteractive :echo wrapper#rm#init('filelist', 1, <f-args>)
command! -complete=file -nargs=1 Rmsinglefile :echo system#rm#init('file', <q-args>)
command! -complete=file -nargs=1 Rmsinglefileinteractive :echo system#rm#init('file', <q-args>, "-i")
command! -complete=file -nargs=1 Rmeverythingindir  :echo wrapper#rm#init('all', <f-args>, 0)
command! -complete=file -nargs=1 Rmfilesindirinteractive :echo wrapper#rm#init('all',  <f-args>, 1)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
