
function! system#cp#init(func, ...)
    exec 'let val = call(s:cp.'.a:func.', a:000, s:cp)'
    return val
endfunction

let s:cp = {}

let s:cp['excodes'] = {}
let s:cp['excodes'] = {
        \  'norm'         : [0, "normal"]
        \, 'abort'        : [1, "abort because file exists"]
        \, 'notadic'      : [2, "var is not a dictionary"]
        \, 'dickeys'      : [3, "keys doesn't exists in dictionary"] 
        \, 'notreadable'  : [4, "file is not readable or doesn't exists"]
        \, 'failedtocopy' : [5, "failed to copy the file"]
        \, 'isdirectory'  : [6, "It is a dieectory"]
        \, 'notadir'      : [7, "Not a directory"]
        \ }

function! s:cp.main(dic)
    if type(a:dic) != type({})
        call Msg("err", ["Error returned from cp.main", "arg should be a dictionary"])
        return self['excodes']['notadic'][0]
    else
        let list = ['copyfrom', 'copyto', 'interactive', 'verbose', 'abortonfileexists']
        let check = dic#check#init('keys', a:dic, list)
        if check == -1
            return self['excodes']['dickeys'][0]
        else
            for item in list
                let {item} = a:dic[item]
            endfor
        endif
    endif
    let copyfrom = expand(copyfrom)
    let copyto = expand(copyto)
    if isdirectory(copyfrom)
        call Msg("err", [copyfrom.": is a directory. Can't copy"])
        return self['excodes']['isdirectory'][0]
    endif
    if !filereadable(copyfrom)
        call Msg("err", [copyfrom.': is not readable', "Aborting ..."])
        return self['excodes']['notreadable'][0]
    endif
    if isdirectory(copyto)
        let copyto = copyto."/".fnamemodify(copyfrom, ":t")
    else
        let todir = fnamemodify(copyto, ":h")
        if !isdirectory(todir)
            call Msg("err", [todir.": is not a directory. Can't copy"])
            return self['excodes']['notadir'][0]
        endif
    endif
    if filereadable(copyto)
        call Msg("warn", [copyto.": exists"])
        if interactive == "yes"
            call Msg("norm", ["Overwrite ?"])
            let answer = input("Y[ye]/N[o]: \n")
            if answer == "y"
                let docopy = self.docopy(copyfrom, copyto, verbose)
                return docopy
            else
                call Msg("norm", ["Aborting ..."])
                return self['excodes']['abort'][0]
            endif
        else
            if abortonfileexists == 'yes'
                return self['excodes']['abort'][0]
            else
                let docopy = self.docopy(copyfrom, copyto, verbose)
                return docopy
            endif
        endif
    else
        let docopy = self.docopy(copyfrom, copyto, verbose)
        return docopy
    endif
endfunction

function! s:cp.docopy(copyfrom, copyto, verbose)
    let file = readfile(a:copyfrom, 'b')
    if a:verbose == "yes"
        call Msg("norm", ['Copying '.a:copyfrom.' --> '.a:copyto])
    endif
    try
        call writefile(file, a:copyto, "b")
    catch /.*/
        if a:verbose != "yes"
            call Msg("norm", ['Copying '.a:copyfrom.' --> '.a:copyto])
        endif
        call Msg("err", ['Failed to copy', "Vim Exception: ".v:exception])
        return self['excodes']['failedtocopy'][0]
    endtry
    return self['excodes']['norm'][0]
endfunction

function! s:cp.showcodes()
    let excodes = []
    for key in keys(self['excodes'])
        let excodes += [join(self['excodes'][key], " : ")]
    endfor
    let excodes = sort(excodes)
    return join(excodes, "\n")
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
