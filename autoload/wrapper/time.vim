
function! wrapper#time#init(func, ...)
    exec 'let val = call(s:timewrapper.'.a:func.', a:000, s:timewrapper)'
    return val
endfunction

let s:timewrapper = {}

function! s:timewrapper.isleap()
    let helpisleap = "arg : (year)\nif returns 1 the year is a leap year, 0 otherwise\nYear: "
    let year = input(helpisleap."\n")
    return time#leap#init('isleap', year)
endfunction

function! s:timewrapper.leapyears()
    call Msg("norm", ["It will output a table with the leap years between two years"
        \, "args : (firstyear, lastyear)"
        \, "Limitations (for formating reasons): firstyear > -999"
        \, "firstyear or lastyear < 10000", " "])
    let first = input("first year : \n")
    let last = input("last year : \n")
    return time#leap#init('years', first, last)
endfunction

function! s:timewrapper.timeformat()
    call Msg("norm", ["Check the time format if it is valid"
        \, "it returns a dictionary"
        \, "if the value of the entries is 0, the time format is valid, -1 otherwise"
        \, "if the month is not valid, probably also the day wouldn't be valid too", " "])
    let day = input("day : \n")
    let month = input("\nmonth (month should be in decimal (9, or 08) or\n
        \at three letters abr (feb, Febr, FebRuR)) : \n") 
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
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
    let month = input("month (month should be in decimal (9, or 08) or\n
        \at least three first letters or more (feb, Febr, FebRuR)) : \n") 
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
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
    let month = input("month (month should be in decimal (9, or 08) or\n
        \at least three first letters or more (feb, Febr, FebRuR)) : \n") 
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
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
    let month = input("month (month should be in decimal (9, or 08) or\n
        \at least three first letters or more (feb, Febr, FebRuR)) : \n") 
    let isdecimal = str2nr(month)
    if isdecimal != 0
        let month = isdecimal
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

    
" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
