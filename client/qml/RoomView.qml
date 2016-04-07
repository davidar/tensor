import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: room

    signal userInput(string text)
    signal loadBacklog()

    function show(s) {
        var oldContentY = flickable.contentY
        var oldTextHeight = textArea.height
        var wasAtEnd = flickable.atYEnd
        textArea.text = s
        if(wasAtEnd) {
            flickable.contentY = textArea.height - flickable.height
        }
        else
        {
            flickable.contentY = oldContentY + textArea.height - oldTextHeight
        }

        if(textArea.height <= flickable.height) loadBacklog()
    }
    function clearInput() {
        textEntry.text = ''
    }

    function setRoom(room) {
        textArea.setRoom(room)
    }

    function setConnection(conn) {
        textArea.setConnection(conn)
    }

    Item {
        id: messages
        anchors.bottom: textEntry.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        ChatRoom {
            id: textArea
            anchors.fill: parent
            //onAtYBeginningChanged: {
            //    if(textArea.height > flickable.height && atYBeginning) loadBacklog()
            //}
        }
    }

    TextField {
        id: textEntry
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        focus: true
        placeholderText: "Say something..."
        onAccepted: textArea.sendLine(text)
    }
}
