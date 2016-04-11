import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: room

    function setRoom(room) {
        chat.setRoom(room)
    }

    function setConnection(conn) {
        chat.setConnection(conn)
    }

    function sendLine(line) {
        chat.sendLine(line)
        textEntry.text = ''
    }

    ChatRoom {
        id: chat
        anchors.bottom: textEntry.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
    }

    TextField {
        id: textEntry
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        focus: true
        textColor: "black"
        placeholderText: "Say something..."
        onAccepted: sendLine(text)
    }
}
