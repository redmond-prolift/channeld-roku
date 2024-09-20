' ' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' ' Note that we need to import this file in MainLoaderTask.xml using relative path.
' sub Init()
'     ' set the name of the function in the Task node component to be executed when the state field changes to RUN
'     ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
'     m.top.functionName = "GetContent"
' end sub

' sub GetContent()
'     ' request the content feed from the API
'     xfer = CreateObject("roURLTransfer")
'     xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
'     xfer.SetURL("https://jonathanbduval.com/roku/feeds/roku-developers-feed-v1.json")
'     rsp = xfer.GetToString()
'     rootChildren = []
'     rows = {}

'     ' parse the feed and build a tree of ContentNodes to populate the GridView
'     json = ParseJson(rsp)
'     if json <> invalid
'         for each category in json
'             value = json.Lookup(category)
'             if Type(value) = "roArray" ' if parsed key value having other objects in it
'                 if category <> "series" ' ignore series for this phase
'                     row = {}
'                     row.title = category
'                     row.children = []
'                     for each item in value ' parse items and push them to row
'                         itemData = GetItemData(item)
'                         row.children.Push(itemData)
'                     end for
'                     rootChildren.Push(row)
'                 end if
'             end if
'         end for
'         ' set up a root ContentNode to represent rowList on the GridScreen
'         PrintObject(rootChildren)
'         PrintObject(rows)
'         contentNode = CreateObject("roSGNode", "ContentNode")

'         contentNode.Update({
'             children: rootChildren
'         }, true)

'         PrintContentNode(contentNode)

'         ' populate content field with root content node.
'         ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
'         m.top.content = contentNode
'     end if
' end sub

function GetItemData(video as Object) as Object
    item = {}
    ' populate some standard content metadata fields to be displayed on the GridScreen
    ' https://developer.roku.com/docs/developer-program/getting-started/architecture/content-metadata.md
    if video.longDescription <> invalid
        item.description = video.longDescription
    else
        item.description = video.shortDescription
    end if
    item.hdPosterURL = video.thumbnail
    item.title = video.title
    item.releaseDate = video.releaseDate
    item.id = video.id
    if video.content <> invalid
        ' populate length of content to be displayed on the GridScreen
        item.length = video.content.duration
        ' populate meta-data for playback
        item.url = video.content.videos[0].url
        item.streamFormat = video.content.videos[0].videoType
    end if
    return item
end function


' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' request the content feed from the API
    practiceId = m.top.practiceId
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    rokuURL = "https://jonathanbduval.com/roku/feeds/roku-developers-feed-v1.json"
    url = "https://api-production.channeld.com/videos/streaming/" + practiceId
    print "CALL URL"; url
    xfer.SetURL(url)
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}

    ' print "Raw Response: "; rsp

    ' parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(rsp)
     if json <> invalid and json.Lookup("results") <> invalid
        formattedArray = ProcessResults(json)
        
        ' PrintObject(formattedArray)
        ' ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: formattedArray
        }, true)

        ' PrintContentNode(contentNode)
        m.top.content = contentNode
        PrintObject(m.videos)
    end if
end sub


sub PrintContentNode(contentNode)
    ' First, check if the contentNode is valid
    if contentNode = invalid
        print "Invalid ContentNode"
        return
    end if

    ' Print the node's fields
    fields = contentNode.GetFields()
    print "ContentNode Fields:"
    for each field in fields
        print field; ": "; contentNode[field]
    end for

    ' If the ContentNode has children, print each child's details recursively
    if contentNode.children.count() > 0
        print "ContentNode Children:"
        for each child in contentNode.children
            PrintContentNode(child)  ' Recursive call to print child nodes
        end for
    else
        print "No Children for this ContentNode"
    end if
end sub

sub PrintObject(obj)
    if Type(obj) = "roAssociativeArray"
        ' Loop through the keys in the associative array and print key-value pairs
        for each key in obj
            value = obj[key]
            if Type(value) = "roAssociativeArray" or Type(value) = "roArray"
                print "Key: "; key; ", Value: "
                PrintObject(value)  ' Recursively print associative arrays and arrays
            else
                print "Key: "; key; ", Value: "; value
            end if
        end for
    elseif Type(obj) = "roArray"
        ' Loop through the array and print each item
        print "Array Items: ["
        for each item in obj
            PrintObject(item)  ' Recursively print nested arrays or associative arrays
        end for
        print "]"
    else
        ' Handle primitive types like strings, numbers, etc.
        print "Value: "; obj
    end if
end sub

sub ProcessResults(json as Object) as Object
    vidArr = json.results
    newArr = []  ' Create an empty array to hold the formatted items

    ' Loop through each item in vidArr and add streamFormat = "hls"
    for each item in vidArr
        formattedItem = {}  ' Create a new associative array for each item
        formattedItem.url = item.url  ' Copy the URL field
        formattedItem.streamFormat = "hls"  ' Add the streamFormat field

        ' Add the formatted item to the new array
        newArr.Push(formattedItem)
    end for

    return newArr  ' Return the formatted array
end sub





