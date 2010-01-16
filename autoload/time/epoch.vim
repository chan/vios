
function! time#epoch#init(func, ...)
    exec 'let val = call(s:epoch.'.a:func.', a:000, s:epoch)'
    return val
endfunction

let s:epoch = {}

function! s:epoch.main(time, timezone)
    if empty(a:time)
        let time = split(strftime("%T:%d:%m:%Y"), ":")
    else
        let time = a:time
    endif
    let timezone = empty(a:timezone) ? "UTC" : a:timezone
    let [hour, min, sec, day, month, year] = time
    let seconds = sec + ((hour * 60 + min) * 60)
    let epochyear = 1970
    let days = 0
    while epochyear < year
        let days = days + time#daysinyear#main(epochyear)
        let epochyear += 1
    endwhile
    if month != 1
        let firstmonth = 0
        while firstmonth < month
            let days += time#daysinmonths#init('days', month, year)
            let firstmonth += 1
        endwhile
    endif
    let days = days + day
    if timezone ==? "UTC"
        let epochsec = (((((days - 1) * 24) * 60) * 60) + seconds)
    else
        let tz = timezone[0] == "+" ? "-".timezone[1:] : "+".timezone[1:]
        let seconds = ((tz * 60) * 60) + seconds
        let epochsec = ( ( ( ( (days - 1) * 24) * 60) * 60) + seconds)
    endif
    if epochsec < 954032399
        return epochsec - 3600
    else
        return epochsec
    endif
endfunction

function! s:epoch.convert(epochseconds)
    return strftime("%T %F %A", a:epochseconds)
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
