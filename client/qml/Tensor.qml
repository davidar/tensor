import QtQuick 2.0
import QtQuick.Controls 1.4
import Matrix 1.0

Rectangle {
    id: window
    visible: true
    width: 800
    height: 480
    focus: true
    color: "#eee"

    Connection {
        id: connection
    }

    function resync() {
        login.visible = false; mainView.visible = true
        connection.sync(30000)
    }

    function login(user, pass) {
        connection.connected.connect(function() {
            connection.connectionError.connect(connection.reconnect)
            connection.syncDone.connect(resync)
            connection.reconnected.connect(resync)
            connection.sync()
        })
        connection.connectToServer(user, pass)
    }

    Item {
        id: mainView
        anchors.fill: parent
        visible: false

        SplitView {
            anchors.fill: parent

            RoomList {
                id: roomListItem
                width: parent.width / 5
                height: parent.height

                Component.onCompleted: {
                    setConnection(connection)
                    enterRoom.connect(roomView.setRoom)
                    joinRoom.connect(connection.joinRoom)
                }
            }

            RoomView {
                id: roomView
                width: parent.width * 4/5
                height: parent.height
                Component.onCompleted: {
                    setConnection(connection)
                }
            }
        }
    }

    Login {
        id: login
        window: window
        anchors.fill: parent
    }
}
