
function! time#abrmonths#main(month)
    if strlen(a:month) < 3
        call Msg("err", [a:month." : It has to be at least the first 3 characters"])
        return -1
    else
        let list = ['January', 'February', 'March', 'April', 'May', 'June'
                \, 'July', 'August', 'September', 'October', 'November', 'December']
        let match = match(list, '^\c'.a:month)
        if match != -1
            return match + 1
        else
            return -1
        endif
    endif
endfunction
