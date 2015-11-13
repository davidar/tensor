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

    function currentRoom()  {
        return tabView.getTab(tabView.currentIndex).title
    }

    function showMessage(room, s) {
        var i = getRoom(room)
        if(i === -1) { console.log("ERROR: cannot find room " + room) }
                else { tabView.getTab(i).item.showMessage(s) }
    }

    function setStatus(room, s) {
        var i = getRoom(room)
        if(i === -1) { console.log("ERROR: cannot find room " + room) }
                else { tabView.getTab(i).item.setStatus(s) }
    }


    SplitView {
        anchors.fill: parent

        RoomList {
            id: roomList
            width: parent.width / 5
            visible: false
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
