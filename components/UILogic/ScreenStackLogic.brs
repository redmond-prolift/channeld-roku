' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub InitScreenStack()
    m.screenStack = []
end sub

sub showPlaylistReadyScreen(practiceId as String)
    m.PlaylistReadyScreen = CreateObject("roSGNode", "PlaylistReadyScreen")
    m.top.backgroundUri= "pkg:/images/jordan_full.png"
    m.practiceId = practiceId
    ShowScreen("PlaylistReady", m.PlaylistReadyScreen) ' show GridScreen
    labelNode = m.top.FindNode("practiceIdLabel")
    if labelNode <> invalid
        ' Set the text of the label
        labelNode.text = "Practice Id: " + practiceId
        print "Label text set to: "; labelNode.text 
    else
        print "Label not found"
    end if
end sub

sub showHelpScreen()
    m.HelpScreen = CreateObject("roSGNode", "HelpScreen")
    m.top.backgroundUri= "pkg:/images/micheal.png"
    ShowScreen("Help", m.HelpScreen) ' show GridScreen
end sub

sub ShowScreen(screenName as String, node as Object)
    prev = m.screenStack.Peek() ' take current screen from screen stack but don't delete it
    if prev <> invalid
        prev.visible = false ' hide current screen if it exist
    end if
    m.top.AppendChild(node) ' add new screen to scene
    ' show new screen
    node.visible = true
    node.screenName = screenName
    node.SetFocus(true)
    m.screenStack.Push(node) ' add new screen to the screen stack

    m.currentScreen = screenName

    node.ObserveField("focusedChild", "onFocusChanged")
end sub

sub onFocusChanged()
    focusedScreen = m.screenStack.Peek()  ' Get the current focused screen
    screenName = m.currentScreen
    if focusedScreen <> invalid
        print "Focus changed to: "; focusedScreen
        focusedScreen.SetFocus(true)  ' Ensure the current screen is handling focus
    end if
end sub

sub CloseScreen(node as Object)
    if node = invalid OR (m.screenStack.Peek() <> invalid AND m.screenStack.Peek().IsSameNode(node))
        last = m.screenStack.Pop() ' remove screen from screenStack
        last.visible = false ' hide screen
        m.top.RemoveChild(last) ' remove screen from scene

        ' take previous screen and make it visible
        prev = m.screenStack.Peek()
        if prev <> invalid
            prev.visible = true
            prev.SetFocus(true)
        end if
    end if
end sub