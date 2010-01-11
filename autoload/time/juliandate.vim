
function! time#juliandate#init(func, ...)
    exec 'let val = call(s:jdn.'.a:func.', a:000, s:jdn)'
    return val
endfunction

let s:jdn = {}

function! s:jdn.main(day, month, year, ...)
    let dic = time#check#init('timeformat', a:day, a:month, a:year)
    if dic['day'] == -1 || dic['month'] == -1 || dic['year'] == -1
        call Msg("err", ["Time format is wrong", "Or gave the \"4713 31 December\" as date"])
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
    if (a:year == 1582 && month == 10  && (a:day < 15 && a:day > 4))
        call Msg("err", ["This day dissapeared all of a sudden"])
        return -1
    endif
    let a = (14 - month) / 12
    if a:year > 0
        let year = (a:year + 4800) - a
    else
        let year = (a:year + 4801) - a
    endif
    let month = month +  (12 * a) - 3
    if a:year > 1582 || (a:year == 1582 && (month > 10 || (month && a:day > 4)))  
        let jdn = a:day + ((153 * month + 2) / 5) + (year * 365) + (year / 4) - (year / 100) + (year / 400) - 32045
    else
        let jdn = a:day + (153 * month + 2) / 5 + year * 365 + year / 4 - 32083
    endif
    " Before 12 o' clock
    if (exists('a:1') && (a:1 < 12 && a:1 >= 0))
        let jdn = jdn - 1
    endif
    return jdn
endfunction

function! s:jdn.tocal(jdn)
    let z = a:jdn
    if a:jdn > 2299160
        let w = float2nr((z - 1867216.25) / 36524.25)
        let x = float2nr(w / 4)
        let a = z + 1 + w - x
    else
        let a = z
    endif
    let b = a + 1524
    let c = float2nr((b - 122.1) / 365.25)
    let d = float2nr(365.25 * c)
    let e = float2nr((b - d) / 30.6001)
    let f = float2nr(30.6001 * e)
    let day = b - d - f
    let month = e - 1
    if month > 12
        let month = e - 13
    endif
    if month == 1 || month == 2
        let year = c - 4715
    else
        let year = c - 4716
    endif
    let date = time#week#init('day', day, month, year)
    echo month
    if date != -1
        let months = ['January', 'February', 'March', 'April', 'May', 'June', 'July'
                    \, 'August', 'September', 'October', 'November', 'December']
        let date = day.' '.months[month - 1].', '.year.', '.date
        return date
    else
        return -1
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
