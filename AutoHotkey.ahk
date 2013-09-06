;; Hotkey to reload autohotkey script
^#r:: Reload

;; Close Active window
#c:: WinClose, A

;#z::Run www.autohotkey.com

;^!n::
;IfWinExist Untitled - Notepad
;	WinActivate
;else
;	Run Notepad
;return


;; cmd.exe with linux like hotkey
#IfWinActive, ahk_class ConsoleWindowClass
	+PgUp:: Send {WheelUp}
	+PgDn:: Send {WheelDown}
;	^d:: Send exit {Enter}
	^d:: Send {Del}
	^p:: Send {Up}
	^n:: Send {Down}
	^a:: Send {Home}
	^e:: Send {End}
	^b:: Send {Left}
	^f:: Send {Right}
	!b:: Send ^+{Left}
	!f:: Send ^+{Right}
;	^u::
;	Loop, 50
;	{
;		Send {BS}
;	}
;	return
	^k::
	Loop, 50
	{
		Send {Del}
	}
	return
#IfWinActive



