
function! system#ls#init(func, ...)
    exec 'let val = call(s:ls.'.a:func.', a:000, s:ls)'
    return val
endfunction

let s:ls = {}

let s:ls['dirfilter'] = "/\?v\d\+$"

function! s:ls.main(dic)
    let curdir = getcwd()
    let dir = a:dic['dir']
    let glob = a:dic['glob']
    let show = a:dic['show']
    let sort = a:dic['sort']
    exec "cd ".dir
    let filelist = lib#filelist#init('indir', glob)
    if empty(filelist['dir']) == 0 && (show == 'all' || show == 'dirs')
        call filter(filelist['dir'], 'v:val !~# self["dirfilter"]')
    endif
    let dic = {}
    for item in ['file', 'dir', 'link', 'cdev', 'bdev', 'socket', 'fifo', 'other']
        if empty(filelist[item]) == 0
            let dic[item] = lib#filelist#init('stats', filelist[item], dir)
            let {item}table = []
            if sort == 'size' || sort == 'time'
                for file in keys(dic[item])
                    let {item}table += [dic[item][file][sort]." ".file]
                endfor
                if sort == 'size'
                    function! Sortbysize(first, second)
                            let firstitem = str2nr(split(a:first)[0])
                            let seconditem = str2nr(split(a:second)[0])
                            return firstitem == seconditem ? 0 : firstitem > seconditem ? 1 : -1
                    endfunction
                    let sorted = sort({item}table, "Sortbysize")
                    let filelist[item] = map(reverse(sorted), 'split(v:val)[1]')
                else
                    let filelist[item] = map(reverse(sort({item}table)), 'split(v:val)[1]')
                endif
            endif
        endif
    endfor
    let lsreport = 'GENERATED LIST (sorted by '.sort.' ) in '.dir
    let names = {'file' : "FILES", "dir" : "DIRECTORIES", "link" : "LINKS"
            \, 'cdev' : "CHARACTER DEVICES", 'bdev' : "BLOCK DEVICES"
            \, 'socket' : "SOCKETS", 'fifo' : "FIFOS", 'other' : "OTHERS"}
    let list = ['file', 'dir', 'link', 'cdev', 'bdev', 'socket', 'fifo', 'other']
    if show != "all"
        let list = filter(list, 'v:val == show')
    endif
    for item in list
        if empty(filelist[item]) == 0
            let lsreport .= "\n".repeat("=", 30)." ".names[item]." ".repeat("=", 30)."\n"
            for file in filelist[item]
                let lsreport .= dic[item][file]['perm']."\t"
                    \.printf("%12d", dic[item][file]['size'])
                    \."\t\t".strftime("%Y-%m-%d %H:%M:%S", dic[item][file]['time'])
                    \."\t".file
                if item == 'link'
                    let resolved = resolve(dir.file)
                    let lsreport .= " --> ".resolved."\n"
                else
                    let lsreport .= "\n"
                endif
            endfor
        endif
    endfor
    return lsreport
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
