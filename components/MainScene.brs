' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of  MainScene
' Note that we need to import this file in MainScene.xml using relative path.
sub Init()
    ' set background color for scene. Applied only if backgroundUri has empty value
    m.top.backgroundColor = "0xFFFFFF"
    m.top.backgroundUri= "pkg:/images/micheal.png"
    ' m.loadingIndicator = m.top.FindNode("loadingIndicator") ' store loadingIndicator node to m
    InitScreenStack()
    ShowGridScreen()
    ' RunContentTask() ' retrieving content
end sub

' The OnKeyEvent() function receives remote control key events


sub showdialog()
    keyboarddialog = createObject("roSGNode", "KeyboardDialog")
    m.top.backgroundColor = "0x000000"
    keyboarddialog.title = "Practice ID"
    keyboarddialog.ObserveField("text", "OnTextInputChanged")
    keyboarddialog.buttons=["OK","Cancel"]
    keyboarddialog.observeField("buttonSelected","confirmSelection")
    keyboarddialog.text = "600699"
    m.top.dialog = keyboarddialog
    keyboarddialog.SetFocus(true)
    m.cFocused=0 'initialize variable
end sub

sub CloseDialog()
    if m.top.dialog <> invalid
        ' m.top.dialog.control = "close"  ' Close the dialog
        dialogText = m.top.dialog.text
        print "User input: "; dialogText
        ' print "keyboardprops"l m.top.dialog.keyboard
        m.top.dialog.close = true
    end if
end sub

sub confirmSelection()
    m.cFocused=m.top.dialog.buttonFocused
    if m.cFocused=0
        dialogText = m.top.dialog.text
        print "User input confirmed: "; dialogText
        print "practiceId"; m.practiceId
        m.practiceId = dialogText
        RunContentTask(dialogText)
        CloseDialog()
    end if
    if m.cFocused=1
        print "Dialog closed without submission"
        CloseDialog()
    end if
end sub

sub onBackPress() 
    numberOfScreens = m.screenStack.Count()
    ' close top screen if there are two or more screens in the screen stack
    if numberOfScreens > 1
        CloseScreen(invalid)
        result = true
    end if
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        print "MainScene Key pressed: "; key
        print "Current Screen: "; m.currentScreen 

        if m.currentScreen = "Login"
            if key = "OK"
                showdialog()
                return true
            elseif key = "back"
                onBackPress()
                return true
            end if
        end if

        if m.currentScreen = "PlaylistReady"
            if key = "OK"
                ShowVideoScreen()
                return true
            elseif key = "up"
                showHelpScreen()
                return true
            elseif key = "back"
                m.currentScreen = "Login"
                onBackPress()
                return true
            end if
        end if

        if m.currentScreen = "Help"
            if key = "back"
                m.currentScreen = "PlaylistReady"
                onBackPress()
                return true
            end if
        end if

        if m.currentScreen = "Main"
            if key = "back"
                m.currentScreen = "PlaylistReady"
                onBackPress()
                return true
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function
