#IfWinActive ahk_class Kohan

GetColor(x,y){ ; function getColor to get flash step color if available
    PixelGetColor, color, x, y, RGB
    StringRight color,color,9 ;
    return color
}


;-- group ████████████████████████████████████████████████████████████████████████████████████
!5::0
!1::6
!2::7
!3::8
!4::9


;-- select ████████████████████████████████████████████████████████████████████████████████████
^q::
{
MouseMove, 1012, 600
Send {Lbutton down}
MouseMove, 8, 8
Send {Lbutton up}
MouseMove, 500, 300
Return
}


~`:: ;select HQ
{
Send {F1}
MouseMove, 253, 102
Send {Lbutton}
Send {Lbutton}
Send {F1}
MouseMove, 500, 300
Return
}

~F2::
Send {F1}
MouseMove, 253, 182
Send {Lbutton}
Send {Lbutton}
Send {F1}
MouseMove, 500, 300
Return

F3::
Send {F1}
MouseMove, 253, 252
Send {Lbutton}
Send {Lbutton}
Send {F1}
MouseMove, 500, 300
Return


F4::
Send {F1}
MouseMove, 253, 320
Send {Lbutton}
Send {Lbutton}
Send {F1}
MouseMove, 500, 300
Return


~F5::
Send {F1}
MouseMove, 253, 400
Send {Lbutton}
Send {Lbutton}
Send {F1}
MouseMove, 500, 300
Return


~F6::
Send {F1}
MouseMove, 253, 482
Send {Lbutton}
Send {Lbutton}
Send {F1}
MouseMove, 500, 300
Return


;speed value replace ████████████████████████████████████████████████████████████████████████████████████
~NumpadAdd::F4
~NumpadSub::F3

;instant delete ████████████████████████████████████████████████████████████████████████████████████

; ~Delete::
; {
; Send {enter}
; Return
; }

; recruit   ████████████████████████████████████████████████████████████████████████████████████

^e:: ;settler without kohan
    if (GetColor(338,726) == "0x6365AD" ){ ; recruit menu button 
        send {r}
        send {1}
        send {enter}
        sleep 1000
    }
return

^r:: ;settler with kohan
    if (GetColor(338,726) == "0x6365AD" ){ ; recruit menu button 
        send {r}
        send {1}
        MouseMove, 365, 420
        Send {Lbutton}
        if (GetColor(407,415) == "0xCE7D29" ){ ; settler 
                send {enter}
                sleep 500
                send {Lbutton} 
            }
        Send {Lbutton}
        send {enter}
        sleep 500
    }
    else
    send ^r
return

~r::
    if (GetColor(512,492) == "0xCEAE42" ){ ; recruit menu button 
        	
        	send {enter}
    }
    else {
    }
return

~e::
    if (GetColor(512,492) == "0xCEAE42" ){ ; recruit menu button 
        	
        	send {Lbutton down}
            MouseMove, 304, 223
            send {Lbutton up}
    }
    if (GetColor(406,733) == "0x525552" ){ ; building button
	if (GetColor(50,177) == "0x424142" ){ ; blacksmith button
 		send {e}
		sleep 500
    	}
	else {
		send {b}
	}
    }
return

;Rbutton::
    ;if (GetColor(512,492) == "0xCEAE42" ){ ; R click does add unit
        	
        	;send {Lbutton}
            ;send {Lbutton}
    ;}
    ;else {
    ;    send {Rbutton}
    ;}
    ;sleep 500
;return


; Build     ████████████████████████████████████████████████████████████████████████████████████



CheckEnginerOrSettler(){ ; check if the unit selected is Enginer or settler

    if (GetColor(318,633) == "0xFF7939" ){ ; settler
        send {s}
        send {Lbutton}
        if (GetColor(407,421) == "0xCE7D29" ){ ; settler
            send {enter}
        }
    }
    if (GetColor(326,641) == "0x6B6552" ){ ; Enginer
        send {o}
        send {Lbutton}
        send {enter}
    }
    return
}

^f::
    if (GetColor(507,650) == "0x8C5521" ){ ; settler
        CheckEnginerOrSettler()
    }
    else {
        send {b}
        CheckEnginerOrSettler()
    }
    sleep 1000
return

; add component     ████████████████████████████████████████████████████████████████████████████████████


~x:: ;library X
    if (GetColor(51,366) == "0x081429" ){ ; building menu open check library available color
        	send {l}
    }
    else {
    }
return

; sell component     ████████████████████████████████████████████████████████████████████████████████████


SellAll(){ ; fast selling
    x := 0
    while x < 7 {
        MouseMove, 347, 644
        Send {s}
        Send {Lbutton}
        ;send {enter}
        x := x+1
        sleep 200
    }
    return
}

^s:: ;sell all
    if (GetColor(456,729) == "0xF7BE5A" ){ ; settler 
        sleep 100
        SellAll()
    }
return


; parameter     ████████████████████████████████████████████████████████████████████████████████████
~^x::
{
Send ^x
Send ^s
Send ^p
Send ^c
Return
}

; multi command     ████████████████████████████████████████████████████████████████████████████████████

!q:: ; ressources repport /r
{
send {enter}
send /r
send {enter}
sleep 1000
Return
}


!e:: ; ping danger
{
send {enter}
send ^m
send  Danger 
send ^m
send {enter}
sleep 1000
Return
}

!r:: ; ping lair
{
send {enter}
send ^e
send Lair
send ^e
send {enter}
sleep 1000
Return
}

!a:: ; ping Attack
{
send {enter}
send ^a
send Attack
send ^a
send {enter}
sleep 1000
Return
}

!s:: ; ping Spy
{
send {enter}
send ^e
send Spy
send ^e
send {enter}
sleep 1000
Return
}

!d:: ; ping indie
{
send {enter}
send ^c
send Indies
send ^c
send {enter}
sleep 1000
Return
}

!f:: ; def here
{
send {enter}
send ^d
send Defend
send ^d
send {enter}
sleep 1000
Return
}

!w:: ; last event
{
MouseMove, 239, 594
send {Lbutton}
MouseMove, 500, 300
sleep 1000
Return
}


; cheat     ████████████████████████████████████████████████████████████████████████████████████

!F7:: ; scene 24
{
send {enter}
send scene
send {space}
send 24
send {enter}
Return
}

!F8:: ; rentakohan
{
send {enter}
send rentakohan
send {enter}
Return
}

!F9:: ; pyrite
{
send {enter}
send pyrite
send {enter}
Return
}


