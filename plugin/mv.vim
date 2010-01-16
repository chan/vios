" *************************************************
" Description -    
" Author -        elunix
" Email -         elunix at gmail dot com
" Date -          12 Dec 2009 15:45:08
" Last modified:  
" Usage:           
" References:      
" License: GPL3
" *************************************************

command! -nargs=* -complete=file Mv :call system#mv#init('main', <f-args>)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1

