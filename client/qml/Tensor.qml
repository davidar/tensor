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

    property var syncJob: null

    Connection {
        id: connection
    }

    function resync() {
        login.visible = false; mainView.visible = true
        syncJob = connection.sync(30000)
    }

    function login(user, pass) {
        connection.connected.connect(function() {
            connection.connectionError.connect(connection.reconnect)
            connection.syncDone.connect(resync)
            connection.reconnected.connect(resync)
            syncJob = connection.sync()
        })
        var userParts = user.split(':')
        if(userParts.length === 1) {
            connection.connectToServer(user, pass)
        } else {
            connection.resolved.connect(function() {
                connection.connectToServer(user, pass)
            })
            connection.resolveError.connect(function() {
                console.log("Couldn't resolve server!")
            })
            connection.resolveServer(userParts[1])
        }
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
