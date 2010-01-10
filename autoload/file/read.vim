" *************************************************
" Description -    
" Author -        elunix
" Email -         elunix at gmail dot com
" Date -          02 Dec 2009 20:28:20
" Last modified:  
" Usage:           
" References:      
" License: GPL3
" *************************************************
function! file#read#init(func, ...)
    exec 'let val = call(s:read.'.a:func.', a:000, s:read)'
    return val
endfunction

let s:read = {}

function! s:read.vimscript(name, ...)
    let file = call(self.file, exists("a:1") ? [a:name, a:1] : [a:name], s:read)
    if file[0] == -1
        return [-1, file[1]]
    else
        let list = []
        while !empty(file)
            let string = remove(file, 0)
            if match(string, '^\s*\') == -1
                call add(list, string)
            else
                let string = substitute(string, '^\s*\', '', '')
                while (!empty(file) && match(file[0], '^\s*\') != -1)
                    let string .= ' '.substitute(remove(file, 0), '^\s*\', '', '')
                endwhile
                let list[-1] = list[-1].string
            endif
        endwhile
        return list
    endif
endfunction

function! s:read.file(name, ...)
    if !filereadable(a:name)
        return [-1, a:name." : Doesn't exist"]
    else
        if exists("a:1") && !empty(a:1)
            return readfile(a:name, '', a:1)
        else
            return readfile(a:name)
        endif
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
