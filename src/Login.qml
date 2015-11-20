import QtQuick 2.0
import "../UC"

Item {
    //color: "#eee"
    property variant window

    function login() {
        label.text = "Please wait..."
        window.login(userNameField.text, passwordField.text)
        userNameField.enabled = false
        passwordField.enabled = false
        userNameField.opacity = 0
        passwordField.opacity = 0
    }

    Column {
        width: parent.width / 2
        anchors.centerIn: parent
        opacity: 0
        //spacing: 18

        Item {
            width: parent.width
            height: 50
        }

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
            font.pixelSize: 2 * phantomLabel.font.pixelSize
            text: "Tensor"
            color: "#888"
        }

        TextField {
            id: userNameField
            width: parent.width
            placeholderText: "User name"
        }

        TextField {
            id: passwordField
            echoMode: TextInput.Password
            width: parent.width
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
