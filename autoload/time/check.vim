
function! time#check#init(func, ...)
    exec 'let val = call(s:check.'.a:func.', a:000, s:check)'
    return val
endfunction

let s:check = {}

function! s:check.month(month)
    if type(a:month) != type(0)
        let month = time#check#init('issuchamonth', a:month)
        if month == -1
            call Msg("err", [a:month." : Not such a month"])
            return -1
        endif
    else
        if a:month > 12 || a:month < 1
            call Msg("err", [a:month." : can't be greater than 12, and less than 1"])
            return -1
        endif
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

function! s:check.issuchamonth(month)
    if strlen(a:month) < 3
        call Msg("err", [a:month." : It has to be at least the first 3 characters"])
        return -1
    else
        let monthsfull = ['January', 'February', 'March', 'April', 'May', 'June'
                \, 'July', 'August', 'September', 'October', 'November', 'December']
        let match = match(monthsfull, '^\c'.a:month)
        if match != -1
            return match + 1
        else
            return -1
        endif
    endif
endfunction

function! s:check.timeformat(day, month, year)
    let dic = {
        \  'day'   : self.day(a:day, a:month, a:year)
        \, 'month' : self.month(a:month)
        \, 'year'  : self.year(a:year)
        \, 'epoh'  : self.epoh(a:year)
        \ }
    return dic
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
