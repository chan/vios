
function! time#check#init(func, ...)
    exec 'let val = call(s:check.'.a:func.', a:000, s:check)'
    return val
endfunction

let s:check = {}

function! s:check.month(month)
    if a:month > 12 || a:month < 1
        call Msg("err", [a:month." : can't be greater than 12, and less than 1"])
        return -1
    endif
endfunction

function! s:check.year(year)
    if a:year == 0
        call Msg("err", ["0 is not a valid year"])
        return -1
    endif
endfunction

function! s:check.day(day, month, year)
    if a:day > time#daysinmonth#init('days', a:month, a:year)
        call Msg("err", [a:day." : Is not a valid day"])
        return -1
    endif
    if a:day < 1
        call Msg("err", [a:day." : Can't be less than 1"])
        return -1
    endif
endfunction

function! s:check.epoh(year)
    if a:year < 1970
        call Msg("err", [a:year." : Can't be less than 1970"])
        return -1
    endif
endfunction

function! s:check.timeformat(day, month, year)
    let dic = {
        \  'day'   : self.day(a:day, a:month, a:year)
        \, 'month' : self.month(a:month)
        \, 'year'  : self.year(a:year)
        \ }
    return dic
endfunction

function! s:check.dateformat(hour, min, sec)
    if (a:hour  > 24 || a:min > 60 || a:sec > 59)
       \|| (a:hour < 0 || a:min < 0 || a:sec < 0)
       \|| (a:hour == 24 && (a:min > 0 || a:sec > 0))
        return -1
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
