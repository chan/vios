
command! -nargs=* -complete=file Htmltotext :call util#htmltotext#main(<q-args>)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
