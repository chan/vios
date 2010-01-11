
function! time#date#init(func, ...)
    let obj = call(s:date.createobj, [],  s:date)
    if obj == -1
        return -1
    endif
     exec 'let val = call(s:date.'.a:func.', a:000, s:date)'
     return val
endfunction

let s:date = {}

" Configuration file
" ~/.vim/data/date.conf

let s:date['config'] = expand("$HOME/.vim/data/".expand("<sfile>:p:t:r").".conf")

function! s:date.createobj()
	if !exists("self['default']")
		let excode = self.source()
		if excode == -1
			return -1
		endif
	endif
endfunction

function! s:date.print(...)
    if exists("a:1")
        let format = substitute(a:1, '.', len(a:1) == 1 ? '%&' : '%& ', 'g')
    else
        let format = substitute(self['default']['format'], '.', '%& ', 'g')
    endif
    let time = strftime(format)
    return time
endfunction

function! s:date.source()
    try
        let data = file#read#init('vimscript', self['config'])
        let @9 = join(data, "\n")
        :@9
    catch /.*/
        echo Msg("err", ["Can not source ".self['config'], "VIM EXCEPTION is: ".v:exception])
        return -1
    endtry
endfunction

function! s:date.showfmt(...)
    if exists("a:1")
        if exists("self['strftime'][a:1]")
            return self['strftime'][a:1]
        else
            call Msg("err", [a:1." : Format doesn't exists"])
        endif        
    else
        let list = []
        for key in keys(self['strftime'])
            let list += [key." : ".self['strftime'][key]]
        endfor
        return join(sort(list), "\n") 
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
