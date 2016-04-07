import QtQuick 2.0
import QtQuick.Controls 1.4
import Matrix 1.0

Rectangle {
    color: "#6a1b9a"

    signal enterRoom(var room)
    signal joinRoom(string name)

    RoomListModel {
        id: rooms
    }

    function setConnection(conn) {
        rooms.setConnection(conn)
    }

    function refresh() {
        if(roomListView.visible)
            roomListView.forceLayout()
    }

    Column {
        anchors.fill: parent

        ListView {
            id: roomListView
            model: rooms
            width: parent.width
            height: parent.height - textEntry.height

            delegate: Rectangle {
                width: parent.width
                height: Math.max(20, roomLabel.implicitHeight + 4)
                color: "transparent"

                Label {
                    id: roomLabel
                    text: display
                    color: "white"
                    elide: Text.ElideRight
                    font.bold: roomListView.currentIndex == index
                    anchors.margins: 2
                    anchors.leftMargin: 6
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        roomListView.currentIndex = index
                        enterRoom(rooms.roomAt(index))
                    }
                }
            }

            highlight: Rectangle {
                height: 20
                radius: 2
                color: "#9c27b0"
            }
        }

        TextField {
            id: textEntry
            width: parent.width
            placeholderText: "Join room..."
            onAccepted: { joinRoom(text); text = "" }
        }
    }
}
