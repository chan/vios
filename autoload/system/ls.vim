
function! system#ls#init(func, ...)
    exec 'let val = call(s:ls.'.a:func.', a:000, s:ls)'
    return val
endfunction

let s:ls = {}

function! s:ls.main(display, ...)
    if exists("a:1") && !empty(a:1)
        let dir = expand(a:1."/")
    elseif !exists("a:1") || a:1 == "\."
        let dir = getcwd()."/"
    endif
    if !isdirectory(dir)
        call Msg("err", [dir.': Doesn''t exists'])
        return -1
    endif
    let dic = !exists("a:2") ? lib#filelist#init('main', dir)
                            \: lib#filelist#init('main', dir, a:2)
    if type(dic) != type({})
        call Msg("err", ['lib#filelist#init function returned an error'])
        return -1
    else
        let report = ''
        if a:display == "files" || a:display == "all"
            if !empty(dic['file'])
                call reverse(sort(map(dic['file'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['file']
                    let i = split(item)
                    let dic['file'][index(dic['file'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]
                endfor
                call insert(dic['file'], "\n".repeat("=", 30)." FILES ".repeat("=", 30)."\n")
                let report .= join(dic['file'], "\n")
            endif
        endif
        if a:display == "dirs" || a:display == "all"
            if !empty(dic['dir'])
                "TODO: Fix the filter
                call filter(dic['dir'], 'v:val !~# "/\?v\d\+$"')
                call reverse(sort(map(dic['dir'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['dir']
                    let i = split(item)
                    let dic['dir'][index(dic['dir'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]
                endfor
                call insert(dic['dir'], "\n".repeat("=", 30)." DIRECTORIES ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['dir'], "\n")
            endif
        endif
        if a:display == "cdev" || a:display == "all"
            if !empty(dic['cdev'])
                call reverse(sort(map(dic['cdev'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['cdev']
                    let i = split(item)
                    let dic['cdev'][index(dic['cdev'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]
                endfor
                call insert(dic['cdev'], "\n".repeat("=", 30)." CHARACTER DEVICES ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['cdev'], "\n")
            endif
        endif
        if a:display == "bdev" || a:display == "all"
            if !empty(dic['bdev'])
                call reverse(sort(map(dic['bdev'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['bdev']
                    let i = split(item)
                    let dic['bdev'][index(dic['bdev'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]
                endfor
                call insert(dic['bdev'], "\n".repeat("=", 30)." BLOCK DEVICES ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['bdev'], "\n")
            endif
        endif
        if a:display == "fifo" || a:display == "all"
            if !empty(dic['fifo'])
                call reverse(sort(map(dic['fifo'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['fifo']
                    let i = split(item)
                    let dic['fifo'][index(dic['fifo'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%y-%m-%d %h:%m:%s", i[0])."\t".i[1]
                endfor
                call insert(dic['fifo'], "\n".repeat("=", 30)." FIFO ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['fifo'], "\n")
            endif
        endif
        if a:display == "other" || a:display == "all"
            if !empty(dic['other'])
                call reverse(sort(map(dic['other'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['other']
                    let i = split(item)
                    let dic['other'][index(dic['other'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]
                endfor
                call insert(dic['other'], "\n".repeat("=", 30)." OTHER ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['other'], "\n")
            endif
        endif
        if a:display == "link" || a:display == "all"
            if !empty(dic['link'])
                call reverse(sort(map(dic['link'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['link']
                    let i = split(item)
                    let resolved = resolve(dir.i[1])
                    let dic['link'][index(dic['link'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]." --> ".resolved
                endfor
                call insert(dic['link'], "\n".repeat("=", 30)." Links ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['link'], "\n")
            endif
        endif
        if a:display == "socket" || a:display == "all"
            if !empty(dic['socket'])
                call reverse(sort(map(dic['socket'], 'getftime(dir.v:val)." ".v:val')))
                for item in dic['socket']
                    let i = split(item)
                    let dic['socket'][index(dic['socket'], item)] = getfperm(dir.i[1])."\t".printf("%12d", getfsize(dir.i[1]))."\t\t".strftime("%Y-%m-%d %H:%M:%S", i[0])."\t".i[1]
                endfor
                call insert(dic['socket'], "\n".repeat("=", 30)." SOCKETS ".repeat("=", 30)."\n")
                let report .= "\n".join(dic['socket'], "\n")
           endif
        endif
    endif
    return report
endfunction 

function! s:ls.maina(dic)
    let dir = a:dic['dir']
    let glob = a:dic['glob']
    let show = a:dic['show']
    let sort = a:dic['sort']
    let filelist = lib#filelist#init('indir', glob)
    if show == 'all'
        let report = self.report(sort, filelist)
    else
        let report = self.report(sort, filelist[show])
    endif
    return report
endfunction

function! s:ls.report(sort, filelist)
    if type(a:filelist) == type({}}
    endif
endfunction 

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
