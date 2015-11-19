import QtQuick 2.0
import "../UC"

Rectangle {
    color: "#6a1b9a"

    signal enterRoom(int id)
    signal joinRoom(string name)

    property ListModel rooms

    Column {
        anchors.fill: parent

        ScrollView {
            width: parent.width
            height: parent.height - textEntry.height

            ListView {
                id: roomListView
                model: rooms

                delegate: Rectangle {
                    width: parent.width
                    height: Math.max(20, roomLabel.implicitHeight + 4)
                    color: "transparent"

                    Label {
                        id: roomLabel
                        text: room.name
                        color: "white"
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
                            enterRoom(index)
                        }
                    }
                }

                highlight: Rectangle {
                    anchors { left: parent.left; right: parent.right }
                    height: 20
                    radius: 2
                    color: "#9c27b0"
                }
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
