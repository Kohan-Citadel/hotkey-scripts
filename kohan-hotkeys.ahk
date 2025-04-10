#HotIf WinActive("ahk_class Kohan")

; calibrates the script for the current screen resolution
Calibrate(){
	WinGetClientPos(,, &W, &H,)
	; Assume the game is still in 4:3 aspect ratio
	if W/4 > H/3 {
		global OffSetX := (W - 4/3 * H) * 0.5
		global OffSetY := 0
		global Width := W - 2*OffSetX
		global Height := H
	} else {
		global OffSetX := 0
		global OffSetY := (H - 0.75 * W) * 0.5
		global Width := W 
		global Height := H- 2*OffSetY
	}
	;MsgBox Format( "Top-Left corner: {1}, {2}\nActive Area: {3} x {4}", OffSetX, OffSetY, Width, Height)
}

Recenter(){
	MouseMove( ConvertCoords( 500, 300 )* )
}

FindColor(x, y, color){ ; function getColor to get flash step color if available
    coords := ConvertCoords( x, y )
	x1 := coords[1] - 2
	y1 := coords[2] - 2
	x2 := coords[1] + 2
	y2 := coords[2] + 2
	if( PixelSearch( &Px, &Py, x1, y1, x2, y2, color, 2 ) ){
		return true
	} else {
		return false
	}
}


ConvertCoords( x, y ){
	if( NOT isSet(Width) ){
		Calibrate()
	}
	coords := [ x * Width / 1024 + OffSetX, y * Height / 768 + OffSetY ]
	return coords
}

SelectSettlement( index ){
	Send( "{F1}" )
	sleep 2
	MouseMove( 5, 5, 2, "R") ; prevents cursor getting "stuck"
	Sleep( 2 )
	MouseMove( ConvertCoords( 250, 21 + index * 76 )* )
	Sleep 2
	Click( , , "Left", 2)
	Sleep 3
	Send( "{F1}" )
	Recenter()
}

~c::Calibrate()

;-- group ████████████████████████████████████████████████████████████████████████████████████
!5::0
!1::6
!2::7
!3::8
!4::9


;-- select whole screen ████████████████████████████████████████████████████████████████████████████████████
^q::
{
coords := ConvertCoords( 1012, 600 )
x1 := coords[1], y1 := coords[2]
coords := ConvertCoords( 8, 8 )
x2 := coords[1], y2 := coords[2]
Send Format("{Click {1} {2} Down}{Click {3} {4} Up}", x1, y1, x2, y2)
sleep(2)
Recenter()
}

; click on settlements in the F1 menu
`::SelectSettlement( 1 )

F2::SelectSettlement( 2 )

F3::SelectSettlement( 3 )

F4::SelectSettlement( 4 )

F5::SelectSettlement( 5 )

F6::SelectSettlement( 6 )


; Game speed controls███████████████████████████████████████████████████████████████████████████████████
~NumpadAdd::F4
~NumpadSub::F3

XButton1::Enter
XButton2::Delete


; recruit   ████████████████████████████████████████████████████████████████████████████████████

^e:: ;settler without kohan
{
    if( FindColor( 338, 726, 0x6365AD ) ){ ; recruit menu button 
        send( "{r}" )
        send( "{6}" )
        send( "{enter}" )
        sleep 100
    }
}

^r:: ;settler with kohan
{
    if( FindColor( 338, 726, 0x6365AD ) ){ ; recruit menu button 
        send( "{r}" )
        send( "{6}" )
        MouseMove( ConvertCoords( 365, 420 )* )

        Send( "{Lbutton}" )
        if (FindColor( 407, 415, 0xCE7D29 ) ){ ; settler 
                send( "{enter}" )
                sleep 500
                send( "{Lbutton}" ) 
            }
        Send( "{Lbutton}" )
        send( "{enter}" )
        sleep 500
    }
    else
    Send( "^r" )
}

; "r" works as {Enter} while in recruitment window
~r::
{
    if ( FindColor( 55, 320, 0x211431 ) ){ ; recruit menu side panel 
        	send( "{enter}" )
    }
}


; "e" removes the unit under the cursor from the company to be commissioned
~e::
{
    if ( FindColor( 55, 320, 0x211431 ) ){ ; recruit menu side panel 
		send( "{Lbutton down}" )
		MouseMove( 50, 0, 2, "R" )
		send( "{Lbutton up}" )
		Sleep( 3 )
		MouseMove( -50, 0, 2, "R" )
    }
	/*
    if (GetColor( ConvertCoords( 406, 733 )* ) == "525552" ){ ; building button
	if (GetColor( ConvertCoords( 50, 177 )* ) == "424142" ){ ; blacksmith button
 		send( "{e}" )
		sleep 500
    	}
	else {
		send( "{b}" )
	}
    }*/
}


; right click to add unit to company
~Rbutton::
{
    if ( FindColor( 55, 320, 0x211431 ) ){
        	send( "{Lbutton}" )
            send( "{Lbutton}" )
    }
    sleep 100
}



; Build outpost/settlement at cursor    ████████████████████████████████████████████████████████████████████████████████████

^f::
{
	isSettler := false
    if( FindColor( 515, 637, 0x946531 )  ){ ; checks for build menu button and opens build menu
        send( "{b}" )
		Sleep( 70 )
	}
	if( FindColor( 515, 637, 0xBD8A00 ) ){ ; check for company menu button (ie already in build menu)
		if( FindColor( 448, 640, 0x211431 ) ){ ; if background color (ie no button and therefore settler)
			Send( "s" )
			isSettler := true
		} else {
			Send( "o" )
		}
		Send( "{LButton}" )
		if( FindColor( 502, 371, 0x424152 ) ){ ; if structure confirmation dialog opened (ie valid location)
			Send( "{Enter}b" )
			if( isSettler ){ ; always press settlers
				Send( "q" )
			}
		}
	}
	sleep 100
}

; add component     ████████████████████████████████████████████████████████████████████████████████████


~x:: ;library X
{
    if ( FindColor( 55, 368, 0x2961b5 ) ){ ; building menu open check library available color
        	send( "{l}" )
    }
}

; sell component     ████████████████████████████████████████████████████████████████████████████████████


SellAll(){ ; fast selling
   ; while fist component slot is NOT empty
    while( NOT FindColor( 345, 640, 0x101429 ) ){ 
        MouseMove( ConvertCoords( 345, 640 )* )

        Send( "{s}" )
        Send( "{Lbutton}" )
        send( "{enter}" )
        sleep 175
    }
    return
}

^s:: ;sell all
{
    if ( FindColor( 456, 729, 0xF7BE5A ) ){ ; checks for sell button
        sleep 100
        SellAll()
    }
}


; toggle zones     ████████████████████████████████████████████████████████████████████████████████████
~^z::
{
Send( "^x" )
Send( "^s" )
Send( "^p" )
Send( "^c" )
}

; multi command     ████████████████████████████████████████████████████████████████████████████████████

!q:: ; resources report /r
{
Send( "{enter}" )
Send( "/r" )
Sleep 3
Send( "{enter}" )
sleep 100
}


!e:: ; ping danger
{
Send( "{enter}" )
Send( "^m" )
Sleep 3
Send( "Danger" )
Sleep 3
Send( "^m" )
Sleep 3
Send( "{enter}" )
sleep 100
}

!r:: ; ping lair
{
Send( "{enter}" )
Send( "^e" )
Sleep 3
Send( "Lair" )
Sleep 3
Send( "^e" )
Sleep 3
Send( "{enter}" )
sleep 100
}

!a:: ; ping Attack
{
Send( "{enter}" )
Send( "^a" )
Sleep 3
Send( "Attack" )
Sleep 3
Send( "^a" )
Sleep 3
Send( "{enter}" )
sleep 100
}

!s:: ; ping Spy
{
Send( "{enter}" )
Send( "^e" )
Sleep 3
Send( "Spy" )
Sleep 3
Send( "^e" )
Sleep 3
Send( "{enter}" )
sleep 100
}

!d:: ; ping indie
{
Send( "{enter}" )
Send( "^c" )
Sleep 3
Send( "Indies" )
Sleep 3
Send( "^c" )
Sleep 3
Send( "{enter}" )
sleep 100
}

!f:: ; def here
{
Send( "{enter}" )
Send( "^d" )
Sleep 3
Send( "Defend" )
Sleep 3
Send( "^d" )
Sleep 3
Send( "{enter}" )
sleep 100
}

!w:: ; last event
{
	MouseMove( ConvertCoords( 239, 594 )* )
	Send( "{Lbutton}" )
	MouseMove( ConvertCoords( 500, 300 )* )

	sleep 100
}


; cheat     ████████████████████████████████████████████████████████████████████████████████████

!F7:: ; scene 24
{
Send( "{enter}" )
Send( "scene" )
Send( "{space}" )
Send 24
Send( "{enter}" )
Return
}

!F8:: ; rentakohan
{
Send( "{enter}" )
Send( "rentakohan" )
Send( "{enter}" )
Return
}

!F9:: ; pyrite
{
Send( "{enter}" )
Send( "pyrite" )
Send( "{enter}" )
Return
}


