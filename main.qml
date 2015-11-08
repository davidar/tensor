import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0

ApplicationWindow {
    id: window
    title: "Tensor"
    visible: true
    width: 800
    height: 480

    menuBar: MenuBar {
        Menu {
            title: "&Menu"
            MenuItem { text: "Join Room..."; onTriggered: joinRoom.visible = true }
            MenuItem { text: "Close"; onTriggered: Qt.quit() }
            MenuItem { text: "About..."; onTriggered: aboutDialog.open() }
        }
    }

    statusBar: StatusBar {
        RowLayout {
            anchors.fill: parent
            Label { id: status; text: "..." }
        }
    }

    function addRoom(name, users) {
        roomList.visible = true
        var i = tabView.count
        tabView.addTab(name, roomTab)
        tabView.currentIndex = i
        tabView.getTab(i).item.users = users
        return i
    }
    function getRoom(room) {
        for(var i = 0; i < tabView.count; i++) {
            if(tabView.getTab(i).title === room) { return i }
        }
        return -1
    }
    function showMessage(room, s) {
        var i = getRoom(room)
        if(i === -1) { console.log("ERROR: cannot find room " + room) }
                else { tabView.getTab(i).item.showMessage(s) }
    }

    function currentRoom()  { return tabView.getTab(tabView.currentIndex).title }
    function setStatus(s)   { status.text = s }

    MessageDialog {
        id: aboutDialog
        icon: StandardIcon.Information
        title: "About"
        text: "<strong>Tensor</strong> client for Matrix"
        informativeText: "One Ping to rule them all,\n" +
                         "One Ping to find them,\n" +
                         "One Ping to bring them all\n" +
                         "and in the darkness bind them\n" +
                         "In the Land of Matrix\n" +
                         "where the Synapse lie."
    }

    JoinRoom {
        id: joinRoom
        parent: window
    }

    SplitView {
        anchors.fill: parent

        Rectangle {
            id: roomList
            width: parent.width / 5
            color: "#6a1b9a"
            visible: false

            ScrollView {
                anchors.fill: parent

                ListView {
                    id: roomListView
                    model: rooms

                    delegate: Rectangle {
                        width: parent.width
                        height: Math.max(20, roomLabel.implicitHeight + 4)
                        color: "transparent"

                        Label {
                            id: roomLabel
                            text: display
                            color: "white"
                            font.bold: roomListView.currentIndex == index
                            anchors.margins: 2
                            anchors.leftMargin: 6
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                roomListView.currentIndex = index
                                tabView.currentIndex = window.getRoom(display)
                            }
                        }
                    }

                    highlight: Rectangle {
                        anchors { left: parent.left; right: parent.right }
                        height: 20
                        radius: 2
                        color: "#9c27b0"
                    }
                }
            }
        }

        TabView {
            id: tabView
            Layout.fillWidth: true
            Layout.fillHeight: true
            style: TabViewStyle { tab:Item{} frame:Item{} frameOverlap:0 }
            Tab { title: "Sign in"; Login{} }
            Room { id: roomTab }
        }
    }
}
