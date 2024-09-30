' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of  MainScene
' Note that we need to import this file in MainScene.xml using relative path.
sub Init()
    print "Stored Vids"
end sub


sub showdialog()
    keyboarddialog = createObject("roSGNode", "KeyboardDialog")
    m.top.backgroundColor = "0x000000"
    keyboarddialog.title = "Practice ID"
    m.top.dialog = keyboarddialog
end sub


sub ShowNextScreen()
    playlistReadyScene = CreateObject("roSGNode", "PlayerReadyScreen")
    m.top = playlistReadyScene
end sub


' The OnKeyEvent() function receives remote control key events
function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
    ' Print the key that was pressed
        print "Login Key pressed: "; key

        ' if key = "OK"
        '   showdialog()
        '   return true
        ' end if

        if key = "down"
            showdialog()
            return true
        elseif key = "OK"
            m.top.setFocus(false)
            ShowVideoScreen()
            return true
        elseif key = "up"
            showdialog()
            return true
        end if
    end if
    return false
end function
