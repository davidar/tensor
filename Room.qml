import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

Item {
    id: room
    Layout.fillWidth: true

    signal userInput(string text)

    function showMessage(s) { textArea.append(s) }
    function clearLog()     { textArea.text = '' }
    function clearInput()   { textEntry.text = '' }
    function setStatus(s)   { status.text = s }

    Item {
        id: messages
        anchors.bottom: statusBox.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        TextArea {
            id: textArea
            anchors.fill: parent
            anchors.margins: -1
            readOnly: true
            textFormat: Qt.RichText
        }
    }

    Rectangle {
        id: statusBox
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: textEntry.top
        height: status.height + 4
        color: "white"
        Label {
            id: status
            color: "grey"
            wrapMode: Text.Wrap
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

        style: TextFieldStyle {
            background: Rectangle {
                color: "#eee"
                anchors.fill: parent
                anchors.margins: -1
            }
        }
    }
}
