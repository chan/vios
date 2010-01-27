
command! -nargs=* Dlsourcestodir :echo wrapper#curl#init('dlsources', <f-args>)
command! -nargs=1 Dlsources :echo wrapper#curl#init('dlsources', <q-args>, '')

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
