' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowVideoScreen()
    ' Create new instance of video node for each playback
    m.videoPlayer = CreateObject("roSGNode", "Video")

    ' Directly setting the videoContent with the specified data
    videoContent = [
        {
            url: "https://channeld-videos-hls.s3.us-east-2.amazonaws.com/1f11445f-9a10-454b-8580-f8fa7f84eed3.m3u8",
            streamFormat: "hls"
        },
        {
            url: "https://channeld-videos-hls.s3.us-east-2.amazonaws.com/cc0c805a-36ad-4085-8c39-8b8f790ea148.m3u8",
            streamFormat: "hls"
        },
        ' {
        '     url: "https://channeld-videos-hls.s3.us-east-2.amazonaws.com/ce45e878-1acb-4c4b-8708-89e3ba5924ec.m3u8",
        '     streamFormat: "hls"
        ' },
        ' {
        '     url: "https://channeld-videos-hls.s3.us-east-2.amazonaws.com/b29c2712-c325-4ed6-b66d-02e811b01c22.m3u8",
        '     streamFormat: "hls"
        ' }
    ]

    print "Stored Vids"; m.contentTask.content

    ' Create a new ContentNode to hold the video content
    node = CreateObject("roSGNode", "ContentNode")
    node.Update({ children: videoContent }, true)
    
    ' Assign the node with the video content to the video player
    m.videoPlayer.content = m.contentTask.content

    ' Enable video playlist (a sequence of videos to be played)
    m.videoPlayer.contentIsPlaylist = true

    ' Show video screen and start playback
    ShowScreen("Main", m.videoPlayer)
    
    m.videoPlayer.control = "play"

    ' Observe state and visibility changes
    m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")
end sub


sub ShowVideoScreenOld(content as Object, itemIndex as Integer)
     m.videoPlayer = CreateObject("roSGNode", "Video") ' create new instance of video node for each playback
    ' we can't set index of content which should start firstly in playlist mode.
    ' for cases when user select second, third etc. item in the row we use the following workaround
    if itemIndex <> 0 ' check if user select any but first item of the row
        numOfChildren = content.GetChildCount() ' get number of row items
        ' populate children array only with  items started from selected one.
        ' example: row has 3 items. user select second one so we must take just second and third items.
        children = content.GetChildren(numOfChildren - itemIndex, itemIndex)
        childrenClone = []
        ' go through each item of children array and clone them.
        for each child in children
        ' we need to clone item node because it will be damaged in case of video node content invalidation
            childrenClone.Push(child.Clone(false))
        end for
        ' create new parent node for our cloned items
        node = CreateObject("roSGNode", "ContentNode")
        node.Update({ children: childrenClone }, true)
        m.videoPlayer.content = node ' set node with children to video node content
    else
        ' if playback must start from first item we clone all row node
        m.videoPlayer.content = content.Clone(true)
    end if
    m.videoPlayer.contentIsPlaylist = true ' enable video playlist (a sequence of videos to be played)
    ShowScreen("Main", m.videoPlayer) ' show video screen
    m.videoPlayer.control = "play" ' start playback
    m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")
end sub

sub OnVideoPlayerStateChange()
    state = m.videoPlayer.state
    print "Current state: "; state

    if state = "error"
        print "Error encountered, skipping to the next video..."
        m.videoPlayer.control = "next"
        ' Check if the current video is the last one in the playlist
        ' if m.videoPlayer.contentIndex >= m.videoPlayer.content.GetChildCount() - 1
        '     print "Last video encountered an error, looping back to the first video..."
        '     m.videoPlayer.contentIndex = 0  ' Reset to the first video in the playlist
        '     m.videoPlayer.control = "play"   ' Start playback from the beginning
        ' else
        '     print "Skipping to the next video..."
        '     m.videoPlayer.control = "next"  ' Move to the next video
        ' end if

    elseif state = "finished"
        print "Video finished playing, checking if it's the end of the playlist..."
            m.videoPlayer.contentIndex = 0  ' Reset to the first video in the playlist
            m.videoPlayer.control = "play"
        ' Check if the current video is the last one in the playlist
        ' if m.videoPlayer.contentIndex >= m.videoPlayer.content.GetChildCount() - 1
        '     print "Reached the end of the playlist, looping back to the first video..."
        '     m.videoPlayer.contentIndex = 0  ' Reset to the first video in the playlist
        '     m.videoPlayer.control = "play"   ' Start playback from the beginning
        ' else
        '     print "Skipping to the next video..."
        '     m.videoPlayer.control = "next"  ' Move to the next video
        ' end if
    end if
end sub


sub OnVideoVisibleChange()
    if m.videoPlayer.visible = false
        print "Video is no longer visible"
        ' Handle video player visibility change
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
    end if
end sub
