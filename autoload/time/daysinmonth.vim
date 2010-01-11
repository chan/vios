function! time#daysinmonth#init(func, ...)
    exec 'let val = call(s:daysinmonth.'.a:func.', a:000, s:daysinmonth)'
    return val
endfunction

let s:daysinmonth = {}

let s:daysinmonth['monthindec'] = {
        \  1  : 31
        \, 2  : 28
        \, 3  : 31
        \, 4  : 30
        \, 5  : 31
        \, 6  : 30
        \, 7  : 31
        \, 8  : 31
        \, 9  : 30
        \, 10 : 31
        \, 11 : 30
        \, 12 : 31
        \ }

function! s:daysinmonth.days(month, year)
    if type(a:month) != type(0)
        let month = time#check#init('issuchamonth', a:month)
        if month == -1
            return -1
        endif
    else
        if time#check#init('month', a:month) != -1 
            let month = a:month
        else
            return -1
        endif
    endif
    if month == 2 
        return self['monthindec'][month] + time#leap#init('isleap', a:year)
    else
        return self['monthindec'][month]
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
