import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    color: "#eee"
    property variant window

    function login() {
        label.text = "Please wait..."
        window.login(userNameField.text, passwordField.text)
        userNameField.enabled = false
        passwordField.enabled = false
        userNameField.opacity = 0
        passwordField.opacity = 0
    }

    GridLayout {
        width: parent.width / 2
        anchors.centerIn: parent
        opacity: 0

        columns: 1
        rowSpacing: 18

        Item {
            width: 256
            height: 256
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                source: "logo.png"

                RotationAnimation on rotation {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 60000
                }
            }
        }

        Label { id: phantomLabel; visible: false }

        Label {
            id: label
            font.pixelSize: 3 * phantomLabel.font.pixelSize
            text: "Tensor"
            color: "#888"
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
            onAccepted: login()
        }

        NumberAnimation on opacity {
            id: fadeIn
            to: 1.0
            duration: 3000
        }

        Component.onCompleted: fadeIn.start()
    }
}
