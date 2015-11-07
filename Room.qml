import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

Component {
    Column {
        id: room
        Layout.fillWidth: true

        property variant users
        function showMessage(s) { textArea.append(s) }

        Item {
            width: parent.width
            height: parent.height - textEntry.height

            TextArea {
                id: textArea
                anchors.fill: parent
                anchors.margins: -1
                readOnly: true
                textFormat: Qt.RichText
            }
        }

        TextField {
            id: textEntry
            width: parent.width
            focus: true
            placeholderText: "Say something..."
            onAccepted: {
                main.sendMessage(text)
                text = ""
            }

            style: TextFieldStyle {
                background: Rectangle {
                    color: "#eee"
                    Rectangle {
                        color: "#eee"
                        anchors.fill: parent
                        anchors.margins: -1
                    }
                }
            }
        }
    }
}

