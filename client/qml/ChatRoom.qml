import QtQuick 2.0
import QtQuick.Controls 1.0
import Matrix 1.0

Rectangle {
    id: root

    property Connection currentConnection: null
    property var currentRoom: null

    function setRoom(room) {
        currentRoom = room
        messageModel.changeRoom(room)
    }

    function setConnection(conn) {
        currentConnection = conn
        messageModel.setConnection(conn)
    }

    function sendLine(text) {
        if(!currentRoom || !currentConnection) return
        currentConnection.postMessage(currentRoom, "m.text", text)
    }

    ListView {
        id: chatView
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        rotation: 180 // https://wiki.qt.io/How_to_make_QML_ListView_align_bottom-to-top
        model: MessageEventModel { id: messageModel }

        delegate: Row {
            id: message
            width: parent.width
            spacing: 8
            rotation: 180

            Label {
                id: timelabel
                text: time.toLocaleTimeString("hh:mm:ss")
                color: "grey"
            }
            Label {
                width: 64
                elide: Text.ElideRight
                text: eventType == "message" ? author : "***"
                color: eventType == "message" ? "grey" : "lightgrey"
                horizontalAlignment: Text.AlignRight
            }
            TextEdit {
                selectByMouse: true
                readOnly: true
                font: timelabel.font
                text: content
                wrapMode: Text.Wrap
                width: parent.width - (x - parent.x) - spacing
                color: eventType == "message" ? "black" : "lightgrey"
            }
        }

        section {
            property: "date"
            labelPositioning: ViewSection.CurrentLabelAtStart
            delegate: Rectangle {
                width: parent.width
                height: childrenRect.height
                rotation: 180
                Label {
                    width: parent.width
                    text: section.toLocaleString("yyyy-MM-dd")
                    horizontalAlignment: Text.AlignRight
                }
            }
        }

        onAtYEndChanged: {
            if(currentRoom && atYEnd) currentRoom.getPreviousContent()
        }
    }
}
