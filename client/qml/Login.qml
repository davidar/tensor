import QtQuick 2.0
import QtQuick.Controls 1.0

Item {
    //color: "#eee"
    property variant window

    function login(pretend) {
        label.text = "Please wait..."
        if(!pretend) window.login(userNameField.text, passwordField.text)
        userNameField.enabled = false
        passwordField.enabled = false
        userNameField.opacity = 0
        passwordField.opacity = 0
    }

    Column {
        width: parent.width / 2
        anchors.centerIn: parent
        opacity: 0
        spacing: 18

        Item {
            width: parent.width
            height: 1
        }

        Item {
            width: 256
            height: 256
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                source: "qrc:/logo.png"

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
            font.pixelSize: phantomLabel.font.pixelSize * 5/2
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
