
function! wrapper#cp#init(func, ...)
    exec 'let val = call(s:cp.'.a:func.', a:000, s:cp)'
    return val
endfunction

let s:cp = {}

function! s:cp.main(copyfrom, copyto)
    let dic = {}
    let dic['copyfrom'] = a:copyfrom
    let dic['copyto'] = a:copyto
    let dic['verbose'] = 'yes'
    let dic['interactive'] = 'yes'
    let dic['abortonfileexists'] = 'yes'
    let val = system#cp#init('main', dic)
    if val != 0
        echo system#cp#init('showcodes', val)
        return val
    endif
endfunction

function! s:cp.files(fromdir, todir, ...)
    let fromdir = expand(a:fromdir)
    let todir = expand(a:todir)
    if !isdirectory(fromdir)
        call Msg("err", [a:fromdir." : Not a directory"])
        return -1
    endif
    if !isdirectory(todir)
        call Msg("warn", [a:todir." : Doesn't exists"])
        let answer = input("Create it? Y[es]/N[o]\n")
        if answer != "y"
            call Msg("norm", ["Aborting ..."])
        else
            let excode = system#mkdir#init('main', todir)
            if excode == -1
                return -1
            endif
        endif
    endif
    if exists("a:1") 
        let filelist = lib#filelist#init('main', a:fromdir, a:1)['file']
    else
        let filelist = lib#filelist#init('main', a:fromdir)['file']
    endif
    for file in filelist
        let excode = self.main(fromdir."/".file, todir)
        if excode != 0
            if excode == 1
                if index(filelist, file) != (len(filelist) -1)
                    let answera = input("Continue with the rest of files? Y[es]/N[o]\n")
                    if answera == "y"
                        continue
                    else
                        return
                    endif
                else
                    return
                endif
            else 
                return -1
            endif
        endif
    endfor
endfunction
     
" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
