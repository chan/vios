
function! system#rm#init(func, ...)
    exec 'let val = call(s:rm.'.a:func.', a:000, s:rm)'
    return val
endfunction

let s:rm = {}

function! s:rm.list(filelist)
    setlocal nomore
    let interactive = a:filelist[0] == "-i" ? 1 : 0
    let filelist = !empty(interactive) ? a:filelist[1:] : a:filelist
    for item in filelist
        let file = expand(item)
        if !empty(glob(file))
            let iswritable = filewritable(file)
            if iswritable == 0
                if isdirectory(file)
                    call Msg("warn", [file.": Is a directory"])
                else
                    call Msg("warn", [file.": You don't have permission to remove it."])
                endif
                if item != filelist[-1]
                    if self.confirmcontinue() == 1
                        break
                    else
                        continue
                    endif
                endif
            else
                if !empty(interactive)
                    let removequestion = confirm(file.": \nRemoving? :", "&Yes\n&No")
                    if removequestion == 1
                        if self.file(file) == -1
                            if item != filelist[-1]
                                if self.confirmcontinue() == 1
                                    break
                                else
                                    continue
                                endif
                            endif
                        endif
                    else
                        continue
                    endif 
                else
                    if self.file(file) == -1
                        if item != filelist[-1]
                            if self.confirmcontinue() == 1
                                break
                            else
                                continue
                            endif
                        endif
                    endif
                endif
            endif
        else
            call Msg("warn", [file.": Doesn't exist"])
        endif
    endfor
    setlocal more
endfunction

function! s:rm.file(file)
    if !isdirectory(a:file)
        if delete(a:file) == 0
            call Msg('norm', [a:file.": --> removed"])
            return
        else
            let perm =  getfperm(a:file)
            call Msg('err', [a:file.": Couldn't remove", 'Permisions are: '.perm])
            if perm == 'rw-rw-rw-'
                call Msg("warn", [a:file.': File is writable but not deletable'])
                if !exists('s:statexec')
                    call Msg("norm", ['Checking if stat is available'])
                    let s:statexec = system#which#init('main', 'stat')
                    if s:statexec == -1
                        call Msg("warn", ['stat executable is not in $PATH', 'Can''t be sure'])
                        return -1
                    endif
                else
                    if s:statexec == -1
                        return -1
                    endif
                endif
                let filestats = split(system(s:statexec.' '.a:file), "\n")
                let index = match(filestats, '^Acces')
                let access = matchstr(filestats[index], '(\d*/')[1:-2]
                call Msg("norm", [a:file.': ', 'Permissions are: '.access])
            endif
            return -1
        endif
    else
        call Msg("warn", [a:file.": Is a directory"])
        return -1
    endif
endfunction

function! s:rm.confirmcontinue()
    if confirm("\nContinue with the rest files in the list? ", "&Yes\n&No") == 1
        call Msg("norm", ["Continuing ..."]) 
        return
    else
        call Msg("warn", ["Aborting ..."])
        return 1
    endif
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
