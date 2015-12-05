import QtQuick 2.0
import "../UC"
import "util.js" as Util
import "main.js" as Main

Rectangle {
    id: window
    visible: true
    width: 800
    height: 480
    focus: true
    color: "#eee"

    property var matrix: null
    property var user_id: null
    property var matrixClient: null
    property var viewingRoom: null

    function login(user, pass) {
        Main.global.window = window
        window.matrix = Main.global.matrixcs

        console.log("Logging in", user, "...")
        var client = matrix.createClient("https://matrix.org")
        client.login("m.login.password", {user:user, password:pass}, function(err, data) {
            if(err) return console.error(err) // TODO
            user_id = data.user_id
            var access_token = data.access_token
            console.log("Logged in", user_id)

            matrixClient = matrix.createClient({
                baseUrl: "https://matrix.org",
                accessToken: access_token,
                userId: user_id
            })
            room.userInput.connect(function(line) {
                if(line.trim().length === 0) return
                if(!viewingRoom) return console.error("viewingRoom is null")
                matrixClient.sendTextMessage(viewingRoom.roomId, line).finally(printMessages)
                printMessages() // echo
                room.clearInput()
            })
            room.loadBacklog.connect(function() {
                console.log("Loading backlog...")
                matrixClient.scrollback(viewingRoom, 20).done(printMessages)
            })
            matrixClient.on("syncComplete", function() {
                console.log("Sync complete!")
                roomListItem.update()
                roomListItem.enterRoom(0)
            })
            matrixClient.on("Room", roomListItem.update)
            matrixClient.on("Room.timeline", function(event, room, toStartOfTimeline) {
                if(viewingRoom && viewingRoom.roomId === room.roomId
                               && !toStartOfTimeline)
                    printMessages()
            })
            matrixClient.startClient(0)
        })
    }

    function printMessages() {
        if(!viewingRoom) return
        console.log("printMessages")
        var log = ""
        for(var i = 0; i < viewingRoom.timeline.length; i++) {
            var event = viewingRoom.timeline[i]
            login.visible = false; mainView.visible = true // TODO

            if(event.getType() === "m.room.message") {
                var time = new Date(event.getTs()).toLocaleTimeString("hh:mm:ss")
                var name = event.sender ? event.sender.name : event.getSender()
                var body = Util.escapeHTML(event.getContent().body)

                if (event.getSender() === user_id) {
                    name = "Me"
                    switch(event.status) {
                    case matrix.EventStatus.SENDING:  body = "<font color=gray>" + body + "</font>"; break
                    case matrix.EventStatus.NOT_SENT: body = "<font color=red>"  + body + "</font>"; break
                    }
                }

                log += "<font color=gray>[" + time + "]</font> <strong>" + name + ":</strong> " + body + "<br>"
            } else {
                log += "<font color=lightgray>" + event.getType() + JSON.stringify(event.getContent()) + "</font><br>"
            }
        }
        room.show(log)
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
                rooms: []

                function update(lazy) {
                    var matrixRooms = matrixClient.getRooms()
                    if(lazy !== true || rooms.length !== matrixRooms.length) {
                        console.log("Updating rooms...")
                        rooms = matrixRooms
                    }
                    return matrixRooms
                }

                Component.onCompleted: {
                    enterRoom.connect(function(roomIndex) {
                        var roomsList = update(true)
                        viewingRoom = roomsList[roomIndex]
                        if(viewingRoom.getMember(user_id).membership === "invite")
                            joinRoom(viewingRoom.roomId)
                        printMessages()
                    })
                    joinRoom.connect(function(roomId) {
                        matrixClient.joinRoom(roomId).done(function(room) {
                            viewingRoom = room
                            roomListItem.update()
                            printMessages()
                        }, console.error);
                    })
                }
            }

            Room {
                id: room
                width: parent.width * 4/5
                height: parent.height
            }
        }
    }

    Login {
        id: login
        window: window
        anchors.fill: parent
    }
}
