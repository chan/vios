
function! time#diffdays#init(func, ...)
    exec 'let val = call(s:diffdays.'.a:func.', a:000, s:diffdays)'
    return val
endfunction

let s:diffdays = {}

function! s:diffdays.main(firstdate, lastdate)
    let [fdthour, fdtmin, fdtsec, fdtday, fdtmonth, fdtyear] = a:firstdate
    let [ldthour, ldtmin, ldtsec, ldtday, ldtmonth, ldtyear] = a:lastdate
    let fdtjdn = time#juliandate#init('main', fdtday, fdtmonth, fdtyear, fdthour)
    let ldtjdn = time#juliandate#init('main', ldtday, ldtmonth, ldtyear, ldthour)
    let fjdn = fdtjdn
    let ljdn = ldtjdn
    let fdtjdntocal = time#juliandate#init('tocal', fdtjdn  < 12 ? fdtjdn + 1 : fdtjdn)
    let ldtjdntocal = time#juliandate#init('tocal', ldthour < 12 ? ldtjdn + 1 : ldtjdn)
    let fdtsec = fdtsec + ((fdthour * 60 + fdtmin) * 60)
    let ldtsec = ldtsec + ((ldthour * 60 + ldtmin) * 60)
    if (fdtjdn < ldtjdn) || (fdtjdn == ldtjdn && (fdtsec < ldtsec && fdtday == ldtday) || (fdtday < ldtday))
        let tmplist = [fdtjdn, fdthour, fdtsec]
        let [fdtjdn, fdthour, fdtsec] = [ldtjdn, ldthour, ldtsec]
        let [ldtjdn, ldthour, ldtsec] = tmplist
    endif
    if (fdthour >= 12 && ldthour < 12)
        let fdtjdn -= 1
        let totalseconds  = fdtsec - ldtsec
    elseif (fdthour < 12 && ldthour >= 12)
        let totalseconds  = fdtsec + 86400 - ldtsec
    elseif ((fdthour >= 12 && ldthour >= 12) || (fdthour < 12 && ldthour < 12))
    \&& (fdtsec < ldtsec)
        let totalseconds = 86400 + fdtsec - ldtsec
        let fdtjdn -= 1
    else
        let totalseconds  = fdtsec - ldtsec
    endif
    let days = fdtjdn - ldtjdn
    let seconds = (totalseconds % 86400) % 60
    let minutes = (totalseconds  % 86400) % 3600 / 60
    let hours = (totalseconds % 86400) / 3600
    let totalhours = days * 24 + hours
    let totalminutes = totalhours * 60 + minutes
    let totalseconds = totalminutes * 60 + seconds
    let totalweeks = days / 7
    let [tdays, tmonths, tyears] = self.yearsmonthsanddays([fdtday, fdtmonth, fdtyear], [ldtday, ldtmonth, ldtyear])    
    let totalyearsmonthsanddays = tdays." days, ".tmonths." months and ".tyears." years" 
    let dic = {
        \  'days'         : days
        \, 'hours'        : hours
        \, 'minutes'      : minutes
        \, 'seconds'      : seconds
        \, 'totalseconds' : totalseconds
        \, 'totalhours'   : totalhours
        \, 'totalminutes' : totalminutes
        \, 'totalweeks'   : totalweeks
        \, 'totalyearsmonthsanddays' : totalyearsmonthsanddays
        \, 'firstjdntocal': fdtjdntocal
        \, 'lastjdntocal' : ldtjdntocal
        \, 'fjdn'         : fjdn
        \, 'ljdn'         : ljdn
        \ } 
    return dic
endfunction

function! s:diffdays.yearsmonthsanddays(firstdate, lastdate)
    let [fday, fmonth, fyear] = a:firstdate
    let [lday, lmonth, lyear] = a:lastdate
    let years = 0
    let months = 0
    let days = 0
    if fyear != lyear
        while fyear < lyear
            let years += 1
            let fyear += 1
        endwhile
    else
        let years = 0
    endif
    if fmonth > lmonth && fday > lday
        let years -= 1
        let months = (12 - fmonth) + (lmonth - 1)
        if lmonth == 1
            let days = (31 - fday) + (lday - 1)
        else
            let days = (time#daysinmonth#init('days', lmonth - 1, lyear) - fday) + (lday - 1)
        endif
        return [days, months, years]
    elseif fmonth > lmonth && fday < lday
        let years -= 1
        let months = (12 - fmonth) + lmonth 
        let days = (lday - fday - 1)
        return [days, months, years]
    elseif fmonth > lmonth && fday == lday
        let years -= 1
        let months = (12 - fmonth) + (lmonth - 1)
        if lmonth == 1
            let days = (31 - fday) + (lday - 1)
        else
            let days = (time#daysinmonth#init('days', lmonth - 1, lyear) - fday) + (lday - 1)
        endif
        return [days, months, years]
    elseif fmonth == lmonth && lday < fday
        let years -= 1
        let months = 11
        if lmonth == 1
            let days = (31 - fday) + (lday - 1)
        else
            let days = (time#daysinmonth#init('days', lmonth - 1, lyear) - fday) + (lday - 1)
        endif
        return [days, months, years]
    elseif fmonth == lmonth && lday == fday
        let years -= 1
        if lmonth == 1
            let days = (31 - fday) + (lday - 1)
        else
            let days = (time#daysinmonth#init('days', lmonth - 1, lyear) - fday) + (lday - 1)
        endif
        return [days, 11, years]
    elseif fmonth < lmonth && fday > lday
        let months = lmonth - fmonth - 1
        let days = (time#daysinmonth#init('days', fmonth, lyear) - fday) + (lday - 1)
        return [days, months, years]
    elseif fmonth < lmonth && fday < lday
        let months = lmonth - fmonth
        let days = lday - fday - 1
        return [days, months, years]
    elseif fmonth < lmonth && fday == lday
        let days = (time#daysinmonth#init('days', fmonth, lyear) - fday) + (lday - 1)
        return [days, 0, years]
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
