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
command! -complete=dir -nargs=* Lsf echo system#ls#init("main", "files", <f-args>)
command! -complete=dir -nargs=* Lsd echo system#ls#init("main", "dirs", <f-args>)
command! -complete=dir -nargs=* Ls echo system#ls#init("main", "all",  <f-args>)
command! -complete=dir -nargs=* Lscdev echo system#ls#init("main", "cdev",  <f-args>)
command! -complete=dir -nargs=* Lsbdev echo system#ls#init("main", "bdev",  <f-args>)
command! -complete=dir -nargs=* Lsfifo echo system#ls#init("main", "fifo",  <f-args>)
command! -complete=dir -nargs=* Lslink echo system#ls#init("main", "link",  <f-args>)
command! -complete=dir -nargs=* Lssocket echo system#ls#init("main", "socket",  <f-args>)

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1

