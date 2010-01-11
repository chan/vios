
function! time#daysinyear#main(year)
    return 365 + time#leap#main(a:year)
endfunction
