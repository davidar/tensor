import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    id: room
    Layout.fillWidth: true

    signal userInput(string text)

    function showMessage(s) { textArea.append(s) }
    function clearLog()     { textArea.text = '' }
    function clearInput()   { textEntry.text = '' }

    Item {
        id: messages
        anchors.bottom: textEntry.top
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
