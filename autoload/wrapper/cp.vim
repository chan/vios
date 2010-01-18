
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

function! s:cp.files()
    call Msg("norm", ["Cp files from source to destination"])
    let fromdir = fnamemodify(input("Source directory : ", "", "dir"), ":p")
    if !isdirectory(fromdir)
        call Msg("err", [fromdir." : Not a directory"])
        return -1
    endif
    let curdir = getcwd()
    exec "cd ".fromdir
    let glob = input("An optional filter: ", "", "file")
    let todir = fnamemodify(input("Destination directory: ", "", "dir"), ":p")
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
    let filelist = lib#filelist#init('indir', empty(glob) ? "*" : glob)['file']
    exec "cd ".curdir
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
