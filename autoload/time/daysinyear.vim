
function! time#daysinyear#main(year)
    return 365 + time#leap#init('isleap', a:year)
endfunction
