import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    GridLayout {
        width: parent.width / 2
        anchors.centerIn: parent

        columns: 1
        rowSpacing: 12
        
        Item {
            width: parent.width
            Label {
                anchors.centerIn: parent
                font.pointSize: 22
                text: "Tensor"
                anchors.verticalCenterOffset: -42
            }
        }

        TextField {
            id: userNameField
            Layout.fillWidth: true
            placeholderText: "User name"
        }

        TextField {
            id: passwordField
            echoMode: TextInput.Password
            Layout.fillWidth: true
            placeholderText: "Password"
            onAccepted: {
                main.login(userNameField.text, passwordField.text)
                userNameField.enabled = false
                passwordField.enabled = false
            }
        }
    }
}
