
function! wrapper#time#init(func, ...)
    exec 'let val = call(s:timewrapper.'.a:func.', a:000, s:timewrapper)'
    return val
endfunction

set nomore

let s:timewrapper = {}

let s:timewrapper['monthquest'] = "month (month should be in decimal (9, or 08) or
        \\nat least the first three letters of a month (feb, Febr, FebRuR) : "

function! s:timewrapper.isleap()
    call Msg("norm", ['This function returns 1, if the given year is a leap year,'
        \, '0 otherwise'])
    let year = input("Year : \n")
    return time#leap#init('isleap', year)
endfunction

function! s:timewrapper.leapyears()
    call Msg("norm", ["This function will output a table, with the leap years between two given years"
        \, "args : (firstyear, lastyear)"
        \, "Limitations (for formating reasons): firstyear > -999"
        \, "firstyear or lastyear < 10000", " "])
    let first = input("first year : \n")
    let last = input("last year : \n")
    return time#leap#init('years', first, last)
endfunction

function! s:timewrapper.timeformat()
    call Msg("norm", ["This time will check the time format (day, month, year) if it is valid"
        \, "it returns a dictionary"
        \, "if the value of the entries is 0, the time format is valid, -1 otherwise"
        \, "if the month is not valid, probably also the day isn't going to be valid too", " "])
    let day = input("day : \n")
    let month = input(self['monthquest']." \n")
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
    else
        let month = time#abrmonths#main(month)
        if month == -1
            return -1
        endif
    endif
    let year = input("year : \n")
    return time#check#init('timeformat', day, month, year)
endfunction

function! s:timewrapper.daysinyear()
    let year = input("Year to be counted for days: ")
    return time#daysinyear#main(year)
endfunction

function! s:timewrapper.juliandate()
    call Msg("norm", ["This function computes the julian date"
        \, "http://en.wikipedia.org/wiki/Julian_day"])
    let day = input("Day : \n")
    let month = input(self['monthquest']." \n")
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
    else
        let month = time#abrmonths#main(month)
        if month == -1
            return -1
        endif
    endif
    let year = input("Year : \n")
    let check = time#check#init('timeformat', day, month, year)
    if check['year'] == -1 || check['month'] == -1 || check['day'] == -1
        return -1
    else
        let jdn = time#juliandate#init('main', day, month, year)
        if jdn == -1
            return -1
        else
            call Msg("norm", [" ", 'NOTE:', 'The julian date is one less,
            \ if hour is less than 12 o'' clock (noon)', " "])
            return jdn
        endif
    endif
endfunction

function! s:timewrapper.weekday()
    call Msg("norm", ['This computes the day of the week in the given date'])
    let day = input("Day : \n")
    let month = input(self['monthquest']." \n")
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
    else
        let month = time#abrmonths#main(month)
        if month == -1
            return -1
        endif
    endif
    let year = input("Year : \n")
    let check = time#check#init('timeformat', day, month, year)
    if check['year'] == -1 || check['month'] == -1 || check['day'] == -1
        return -1
    else
        let dayoftheweek = time#week#init('day', day, month, year)
        if  dayoftheweek == -1
            return -1
        else
            return dayoftheweek
        endif
    endif
endfunction

function! s:timewrapper.isoweek()
    call Msg("norm", ['This computes the ISO week day of the given date'
        \, 'http://en.wikipedia.org/wiki/ISO_week_date'])
    let day = input("Day : \n")
    let month = input(self['monthquest']." \n")
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
    else
        let month = time#abrmonths#main(month)
        if month == -1
            return -1
        endif
    endif
    let year = input("Year : \n")
    let check = time#check#init('timeformat', day, month, year)
    if check['year'] == -1 || check['month'] == -1 || check['day'] == -1
        return -1
    else
        let isoweek = time#week#init('iso', day, month, year)
        if  isoweek == -1
            return -1
        else
            return isoweek
        endif
    endif
endfunction

function! s:timewrapper.jdntocal()
    call Msg("norm", ['This function returns a julian date to local calendar'
        \, 'It takes a julian date as an argument'])
    let jdn = input("Julian date to convert : \n")
    return time#juliandate#init('tocal', jdn)
endfunction

function! s:timewrapper.diffdays()
    call Msg("norm", ['This function computes, the difference between two given dates.'
        \, 'It output the difference in days, hours, minutes and seconds.'
        \, 'And the total hours, total minutes, totalseconds and (total years, months and days).'
        \, 'The time format should be a string, with ":" as separator with the following entries.'
        \, 'hour:minute:second:day:month:year  (in that order)'
        \, 'e.g.,'
        \, '13:32:00:20:07:1969'
        \, 'That means in 20 of July of the year 1969 in one o'' clock and thirty two minutes.'
        \, 'Month can be a string with at least the first three letters (uppercase or lower case or mixed).'
        \, 'Confirmation can be achieved in'
        \, 'http://www.timeanddate.com/date/duration.html'])
    let firstdate = input("First date : \n")
    let fdt = split(firstdate, ":")
    if len(fdt) != 6
        call Msg("err", ["Format doesn't have the neccesarry entries"])
        return -1
    else
        let [hour, min, sec, day, month, year] = fdt
        unlet fdt[4]
        let isdecimal = str2nr(month)
        if isdecimal != 0
            let month = isdecimal
        else
            let month = time#abrmonths#main(month)
            if month == -1
                return -1
            endif
        endif
        let check = time#check#init('timeformat', day, month, year)
        if check['year'] == -1 || check['month'] == -1 || check['day'] == -1
            return -1
        else
            let datecheck = time#check#init('dateformat', hour, min, sec)
            if datecheck == -1
                return -1
            endif
        endif
    endif
    call insert(fdt, month, 4)
    let lastdate = input("Last date : \n")
    let ldt = split(lastdate, ":")
    if len(ldt) != 6
        call Msg("err", ["Format doesn't have the neccesarry entries"])
        return -1
    else
        let [lhour, lmin, lsec, lday, lmonth, lyear] = ldt
        unlet ldt[4] 
        let isdecimal = str2nr(lmonth)
        if isdecimal != 0
            let lmonth = isdecimal
        else
            let lmonth = time#abrmonths#main(lmonth)
            if lmonth == -1
                return -1
            endif
        endif
        let check = time#check#init('timeformat', lday, lmonth, lyear)
        if check['year'] == -1 || check['month'] == -1 || check['day'] == -1
            return -1
        else
            let datecheck = time#check#init('dateformat', lhour, lmin, lsec)
            if datecheck == -1
                return -1
            endif
        endif
    endif
    call insert(ldt, lmonth, 4)
    let dic = time#diffdays#init('main', fdt, ldt)
    call Msg("norm", [" "
    \, "The difference from ".hour.":".min.":".sec." at ".dic['firstjdntocal']." to "
    \, "                    ".lhour.":".lmin.":".lsec." at ".dic['lastjdntocal']." is : "
    \, dic['days']." days, ".dic['hours']." hours,
        \ ".dic['minutes']." minutes and ".dic['seconds']." seconds."
    \, 'Total hours are   : '.dic['totalhours']
    \, 'Total minutes are : '.dic['totalminutes']
    \, 'Total seconds are : '.dic['totalseconds']
    \, 'Total weeks are   : '.dic['totalweeks']
    \, 'Total years, months and days are : '.dic['totalyearsmonthsanddays']
    \, 'First date julian date is : '.dic['fjdn']
    \, 'Last date julian date is : '.dic['ljdn']])
endfunction    
        
" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
