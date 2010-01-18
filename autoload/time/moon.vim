" Thanks goes to
" http://home.att.net/~srschmitt/zenosamples/zs_lunarphasecalc.html
" for the moonphase algorithm

function! time#moon#init(func, ...)
    exec 'let val = call(s:moon.'.a:func.', a:000, s:moon)'
    return val
endfunction

let s:moon = {}

function! s:moon.normalize(v)
	let v = a:v - floor(a:v)
	if v < 0
		let v = v + 1
	endif
	return v
endfunction

function! s:moon.round2(x)
     return (round(100 * a:x) / 100.0)
endfunction

function! s:moon.phase(time)
    let pi = 3.1415926535897932385
    if empty(a:time) == 1
        let date = strftime("%T:%d:%m:%Y", localtime())
        let time = split(date, ":")
        let [hour, min, sec, day, month, year] = time
    else
        let [hour, min, sec, day, month, year] = a:time
    endif
    if (year >= 2038) && (month >= 1) && (day >= 19) && (hour >= 3) && (min >= 14) && (sec >= 7)
        call Msg("err", ["2038 bug, the time ends at ".strftime('%Y:%m:%d %T', 2147483647)])
        return -1
    endif
    let jdn = time#juliandate#init('main', day, month, year, hour)
	let ip = (jdn - 2451550.1) / 29.530588853
	let ag= self.normalize(ip) * 29.53
        if ag <  1.84566
 	        let phase = "NEW"
	     elseif ag <  5.53699
		    let phase = "Waxing crescent"
        elseif ag <  9.22831
		    let phase = "First quarter"
        elseif ag < 12.91963
		    let phase = "Waxing gibbous"
        elseif ag < 16.61096
		    let phase = "FULL"
        elseif ag < 20.30228
		    let phase = "Waning gibbous"
        elseif ag < 23.99361
		    let phase = "Last quarter"
        elseif ag < 27.68493
		    let phase = "Waning crescent"
        else                    
		    let phase = "NEW"
        endif
        let ip = ip * 2 * pi
        let dp = 2 * pi * self.normalize((jdn - 2451562.2) / 27.55454988)
        let di = 60.4 - 3.3 * cos(dp) - 0.6 * cos(2 * ip - dp) - 0.5 * cos(2 * ip)
        let np = 2 * pi * self.normalize((jdn - 2451565.2 ) / 27.212220817)
        let la = 5.1 * sin(np)
        let rp = self.normalize((jdn - 2451555.8) / 27.321582241)
        let lo = 360 * rp + 6.3 * sin(dp) + 1.3 * sin(2 * ip - dp) + 0.7 * sin(2 * ip)
        if lo < 33.18
            let zodiac = "Pisces"
        elseif lo <  51.16
            let zodiac = "Aries"
        elseif lo <  93.44
            let zodiac = "Taurus"
        elseif lo < 119.48
            let zodiac = "Gemini"
        elseif lo < 135.30
            let zodiac = "Cancer"
        elseif lo < 173.34
            let zodiac = "Leo"
        elseif lo < 224.17
            let zodiac = "Virgo"
        elseif lo < 242.57
            let zodiac = "Libra"
        elseif lo < 271.26
            let zodiac = "Scorpio"
        elseif lo < 302.49
            let zodiac = "Sagittarius"
        elseif lo < 311.72
            let zodiac = "Capricorn"
        elseif lo < 348.58
            let zodiac = "Aquarius"
        else 
            let zodiac = "Pisces"
        endif
        let report = []
        call add(report, "Date : ".time#juliandate#init('tocal', jdn))
        call add(report, "Phase         = ".phase)
        call add(report, "age           = ".string(self.round2(ag)). " days (".string(self.round2(ag) / 29.530588853).")")
        call add(report, "distance      = ".string(self.round2(di)). " earth radii")
        call add(report, "ecliptic")
        call add(report, "latitude      = ".string(self.round2(la)). '°')
        call add(report, "longitude     = ".string(self.round2(lo)). '°')
        call add(report, "constellation = ".zodiac)
        return join(report, "\n")
endfunction

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
