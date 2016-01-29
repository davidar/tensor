import QtQuick 2.0
import "../UC"

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

    Item {
        id: messages
        anchors.bottom: textEntry.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Flickable {
            id: flickable
            anchors.fill: parent
            contentWidth: width
            contentHeight: textArea.height
            onAtYBeginningChanged: {
                if(textArea.height > flickable.height && atYBeginning) loadBacklog()
            }
            Text {
                id: textArea
                width: parent.width
                textFormat: Qt.RichText
                wrapMode: Text.Wrap
                text: "Nothing to see here..."
            }
        }
    }

    TextField {
        id: textEntry
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        focus: true
        placeholderText: "Say something..."
        onAccepted: userInput(text)
    }
}
