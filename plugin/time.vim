
command! Timedaysinyear :echo wrapper#time#init('daysinyear')
command! Timeisleapyear :echo wrapper#time#init('isleap') 
command! Timeleapyears  :echo wrapper#time#init('leapyears')
command! Timejuliandate :echo wrapper#time#init('juliandate')
command! Timechecktimeformat :echo wrapper#time#init('timeformat')
command! Timedayoftheweek  :echo wrapper#time#init('weekday')
command! Timeisoweek :echo wrapper#time#init('isoweek')
command! Timejuliandatetocal :echo wrapper#time#init('jdntocal')
command! Timedifftwodays : echo wrapper#time#init('diffdays')

" vim: et:ts=4 sw=4 fdm=expr fde=getline(v\:lnum)=~'^\\s*$'&&getline(v\:lnum-1)=~'\\S'?'<1'\:1
