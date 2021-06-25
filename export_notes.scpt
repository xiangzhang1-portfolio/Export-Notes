-- Export Notes to HTML

on format_date(date_)
	set {year:y, month:m, day:d} to date_
	tell (y * 10000 + m * 100 + d) as string to text 1 thru 4 & "" & text 5 thru 6 & "" & text 7 thru 8
end format_date

set exportFolder to (choose folder) as string

tell application "Notes"
	
	set theFolder to first folder whose name = "Notes"
	set theNotes to notes of theFolder
	
	repeat with theNote in theNotes
		
		set theText to body of theNote as string
		set modDate to modification date of theNote as date
		set baseName to my format_date(modDate)
		
		repeat with postfix in {".html", "-1.html", "-2.html", "-3.html", "-4.html", "-5.html", "-6.html", "-7.html", "-8.html", "-9.html", "-10.html"}
			set filePath to (exportFolder & baseName & postfix)
			if not (exists file filePath of application "Finder") then
				set noteFile to open for access filePath with write permission
				write theText to noteFile as «class utf8»
				close access noteFile
				exit repeat
			end if
		end repeat
		
		tell application "Finder" to set modification date of file (filePath) to modDate
		
	end repeat
	
end tell

-- Convert HTML to TXT:
-- find . -name "*.html" -exec textutil -convert txt -inputencoding UTF-8 '{}' \;
