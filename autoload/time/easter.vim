
function! time#easter#init(func, ...)
    exec 'let val = call(s:easter.'.a:func.', a:000, s:easter)'
    return val
endfunction

let s:easter = {}

function! s:easter.orthodox(year)
    let g = a:year % 19
    let i = (19 * g + 15) % 30
    let j = (a:year + a:year / 4 + i) % 7
    let l = i - j
    let eastermonth = 3 + (l +40) / 44
    if a:year < 1921
        call Msg("norm", ["This is a date in Julian Calendar (pre 1921)"])
        let easterday = l + 28 - 31 * (eastermonth / 4)
    else
        if a:year >= 2100
            let easterday = l + 28 - 31 * (eastermonth / 4) + 14
        else    
            let easterday = l + 28 - 31 * (eastermonth / 4) + 13
        endif
        if easterday > 30 && eastermonth == 4
            let eastermonth = "May"
            let easterday -= 30
        elseif easterday > 30 && eastermonth == 3
            let easterday -= 31
            let eastermonth = "April"
        else
            let eastermonth = "April"
        endif
    endif
    return easterday.' '.eastermonth
endfunction

function! s:easter.catholic(year)
"code by Anonymous Coward on /.  on Sunday March 23, @03:51PM (#22838184)
    if a:year == 4089
        return
    endif
    let a = a:year / 100
    let b = a:year % 100
    let c = (3 * (a + 25)) / 4
    let d = (3 * (a + 25)) % 4
    let e = (8 * (a + 11)) / 25
    let f = (5 * a + b) % 19
    let g = (19 * f + c - e) % 30
    let h = (f + 11 * g) / 319
    let j = (60 * (5 - d) + b) / 4
    let k = (60 * (5 - d) + b) % 4
    let m = ( 2 * j - k - g + h) % 7
    let n = ( g - h + m + 114) / 31
    let p = ( g - h + m + 114) % 31
    let easterday = p + 1
    if n == 3
        let eastermonth = "March"
    else
        let eastermonth = "April"
    endif
    return easterday.' '.eastermonth
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
