
function! time#week#init(func, ...)
    exec 'let val = call(s:week.'.a:func.', a:000, s:week)'
    return val
endfunction

let s:week = {}

let s:week['days'] = {
                \  0 : 'Sunday'
                \, 1 : 'Monday'
                \, 2 : 'Tuesday'
                \, 3 : 'Wednesday'
                \, 4 : 'Thursday'
                \, 5 : 'Friday'
                \, 6 : 'Saturday'
                \}

function! s:week.iso(day, month, year)
    let dic = time#check#init('timeformat', a:day, a:month, a:year)
    if dic['day'] == -1 || dic['month'] == -1 || dic['year'] == -1
        call Msg("err", ["Time format is wrong"])
        return -1
    endif
    let jdn = time#juliandate#init('main', a:day, a:month, a:year, 12)
    if jdn == -1
        return -1
    endif
    let d4 = (jdn + 31741 - ( jdn % 7)) % 146097 % 36524 % 1461
    let l = d4 / 1460
    let d1 = ((d4 - l) % 365) + l
    let weeknumber = d1 / 7 + 1
    if a:month == 1 && weeknumber == 53
        return (a:year - 1).'-W'.weeknumber.'-'.self.day(a:day, a:month, a:year)
    elseif a:month == 12 && weeknumber == 1
        return (a:year + 1).'-W'.weeknumber.'-'.self.day(a:day, a:month, a:year)
    else
        return a:year.'-W'.weeknumber.'-'.self.day(a:day, a:month, a:year)
    endif
endfunction

function! s:week.day(day, month, year)
    let dic = time#check#init('timeformat', a:day, a:month, a:year)
    if dic['day'] == -1 || dic['month'] == -1 || dic['year'] == -1
        call Msg("err", ["Time format is wrong"])
        return -1
    endif
    let jdn = time#juliandate#init('main', a:day, a:month, a:year, 12)
    if jdn == -1
        return -1
    endif
    if type(a:month) == type('')
        let month = time#check#init('issuchamonth', a:month)
        if month == -1
            return -1
        endif
    else
        let month = a:month
    endif
    let a = (14 - month) / 12
    if a:year > 0
        let year = a:year - a
    else
        let year = a:year - a  + 1
    endif
    let month = month + (12 * a ) - 2
    if jdn > 2299160
        let day = (a:day + year + (year / 4) - (year / 100) +  (year / 400) + (31 * month) / 12) % 7
    else
        let day = (5 + a:day + year + year / 4 + (31 * month) / 12) % 7
    endif
    return self['days'][day]
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
