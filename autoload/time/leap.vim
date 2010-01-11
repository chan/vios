
function! time#leap#init(func, ...)
    exec 'let val = call(s:leap.'.a:func.', a:000, s:leap)'
    return val
endfunction

let s:leap = {}

function! s:leap.isleap(year)
    if !(a:year % 4 || (!(a:year % 100) && a:year % 400))
        return 1
    endif
endfunction

function! s:leap.years(start, end)
    let saved_a = @a
    let @a = ''
    let firstyear = a:start
    let lastyear = a:end
    if lastyear < firstyear 
        call Msg("err", ["Out of range"])
        return -1
    endif
    if firstyear < -999 || firstyear > 10000 || lastyear > 10000
	call Msg("warn", ["This will damage formating", "Aborting"])
        return 1
    endif
    while firstyear <= lastyear
        if firstyear != 0
            if self.isleap(firstyear) == 1
                let @A = printf("%04d", firstyear)." "
            endif
        endif
        let firstyear += 1
    endwhile
    if @a != ""
            let title = "         LEAP YEARS      "
            let line = substitute(title, '.', '==', 'g') 
            let text = title."\n".line   
            let a = substitute(@a, '.\{4,50}', " &\n", 'g')
	    let @a = saved_a
            return text."\n".a.line
    else
       return
    endif
endfunction
