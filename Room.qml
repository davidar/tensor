import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Component {
    Column {
        id: room
        property variant users
        Layout.fillWidth: true
        function showMessage(s) { textArea.append(s) }

        SplitView {
            width: parent.width
            height: parent.height - textEntry.height

            Item {
                width: 1; height: 1
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    anchors.fill: parent
                    implicitWidth: textArea.implicitWidth
                    implicitHeight: textArea.implicitHeight

                    TextArea {
                        id: textArea
                        anchors.fill: parent
                        readOnly: true
                        textFormat: Qt.RichText
                    }
                }
            }

            Rectangle {
                width: parent.width / 4
                color: "#eee"

                ScrollView {
                    anchors.fill: parent

                    ListView {
                        id: userListView
                        model: room.users

                        delegate: Rectangle {
                            width: parent.width
                            height: Math.max(20, userLabel.implicitHeight + 4)
                            color: "transparent"

                            Label {
                                id: userLabel
                                text: display
                                anchors.margins: 2
                                anchors.leftMargin: 6
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: userListView.currentIndex = index
                                onDoubleClicked: {/* TODO */}
                            }
                        }

                        highlight: Rectangle {
                            anchors { left: parent.left; right: parent.right }
                            height: 20
                            radius: 2
                            color: "sky blue"
                        }
                    }
                }
            }
        }

        TextField {
            id: textEntry
            width: parent.width
            focus: true
            placeholderText: "Type a message here"
            onAccepted: {
                main.sendMessage(text)
                text = ""
            }
        }
    }
}

