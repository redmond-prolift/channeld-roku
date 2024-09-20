' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowGridScreen()
    m.LoginScreen = CreateObject("roSGNode", "LoginScreen")
    ShowScreen("Login", m.LoginScreen) ' show GridScreen
    m.LoginScreen.SetFocus(true)
end sub

sub OnGridScreenItemSelected(event as Object) ' invoked when GridScreen item is selected
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedIndex = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    itemIndex = m.selectedIndex[1]
    ShowVideoScreen()
end sub