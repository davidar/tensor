import QtQuick 2.0
import "../UC"
import "main.js" as Main

Rectangle {
    id: window
    visible: true
    width: 800
    height: 480
    focus: true
    color: "#eee"
    Component.onCompleted: Main.global.window = window

    property var matrix: Main.global.matrixcs
    property var user_id: null
    property var access_token: null
    property var matrixClient: null
    property var roomList: []
    property var viewingRoom: null

    function login(user, pass) {
        console.log("Logging in", user, "...")
        var client = matrix.createClient("https://matrix.org")
        client.login("m.login.password", {user:user, password:pass}, function(err, data) {
            if(err) {
                console.error(err)
                // TODO: better handling
                return
            }
            user_id = data.user_id
            access_token = data.access_token
            console.log("Logged in", user_id)
            main()
        });
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
                rooms: ListModel { id: roomListModel }

                Component.onCompleted: {
                    enterRoom.connect(handleEnterRoom)
                    joinRoom.connect(handleJoinRoom)
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

    function log() {
        login.visible = false; mainView.visible = true
        var args = Array.prototype.slice.call(arguments)
        var s = args[0]
        for(var i = 1; i < args.length; i++)
            s = s.arg(args[i])
        console.log(s)
        room.showMessage(s)
    }

    function clearLog() {
        room.clearLog()
    }

    function clearInput() {
        room.clearInput()
    }

    function fmtCol(color) {
        return function(s) {
            return "<font color=" + color + ">" + s + "</font>"
        }
    }

    function italic(s) {
        return "<em>" + s + "</em>"
    }

    function strong(s) {
        return "<strong>" + s + "</strong>"
    }

    function handleInput(line) {

        if (line.trim().length === 0) {
            clearInput();
            return;
        }
        if (line === "/help") {
            printHelp();
            clearInput();
            return;
        }

        if(!viewingRoom) {
            console.error("viewingRoom is null");
            return;
        }

        if       (line === "/members") {
            printMemberList(viewingRoom);
        } else if(line === "/roominfo") {
            printRoomInfo(viewingRoom);
        } else if(line === "/resend") {
            // get the oldest not sent event.
            var notSentEvent;
            for (var i = 0; i < viewingRoom.timeline.length; i++) {
                if (viewingRoom.timeline[i].status === matrix.EventStatus.NOT_SENT) {
                    notSentEvent = viewingRoom.timeline[i];
                    break;
                }
            }
            if (notSentEvent) {
                matrixClient.resendEvent(notSentEvent, viewingRoom).done(function() {
                    printMessages();
                    clearInput();
                }, function(err) {
                    printMessages();
                    printf("/resend Error: %1", err);
                    clearInput();
                });
                printMessages();
                clearInput();
            }
        } else if(line.indexOf("/more ") === 0) {
            var amount = parseInt(line.split(" ")[1]) || 20;
            matrixClient.scrollback(viewingRoom, amount).done(function(room) {
                printMessages();
                clearInput();
            }, function(err) {
                printf("/more Error: %1", err);
            });
        } else if(line.indexOf("/invite ") === 0) {
            var userId = line.split(" ")[1].trim();
            matrixClient.invite(viewingRoom.roomId, userId).done(function() {
                printMessages();
                clearInput();
            }, function(err) {
                printf("/invite Error: %1", err);
            });
        } else if(line.indexOf("/file ") === 0) {
            var filename = line.split(" ")[1].trim();
            var stream = fs.createReadStream(filename); // TODO
            matrixClient.uploadContent({
                stream: stream,
                name: filename
            }).done(function(url) {
                var content = {
                    msgtype: "m.file",
                    body: filename,
                    url: JSON.parse(url).content_uri
                };
                matrixClient.sendMessage(viewingRoom.roomId, content);
            });
        } else {
            matrixClient.sendTextMessage(viewingRoom.roomId, line).finally(function() {
                printMessages();
                clearInput();
            });
            printMessages(); // print local echo immediately
        }

        clearInput();
    }

    function handleJoinRoom(roomId) {
        matrixClient.joinRoom(roomId).done(function(room) {
            setRoomList();
            viewingRoom = room;
            printMessages();
            clearInput();
        }, console.error);
    }

    function handleEnterRoom(roomIndex) {
        viewingRoom = roomList[roomIndex];
        if(viewingRoom.getMember(user_id).membership === "invite")
            handleJoinRoom(viewingRoom.roomId);
        else printMessages();
    }

    function main() {
        matrixClient = matrix.createClient({
            baseUrl: "https://matrix.org",
            accessToken: access_token,
            userId: user_id
        });
        console.log("Created client")
        room.userInput.connect(handleInput);
        matrixClient.on("syncComplete", function() {
            console.log("Sync complete!")
            setRoomList();
            if(roomList.length > 0) handleEnterRoom(0);
            else printHelp();
        });
        matrixClient.on("Room", setRoomList);
        matrixClient.on("Room.timeline", function(event, room, toStartOfTimeline) {
            if(viewingRoom && viewingRoom.roomId === room.roomId
                           && !toStartOfTimeline)
                printLine(event);
        });
        console.log("Finished init")
        matrixClient.startClient(0);
        console.log("Started client")
        return;
    }

    function setRoomList() {
        roomList = matrixClient.getRooms();
        roomList.sort(function(a,b) {
            // < 0 = a comes first (lower index) - we want high indexes = newer
            var aMsg = a.timeline[a.timeline.length-1];
            if(!aMsg) return -1;
            var bMsg = b.timeline[b.timeline.length-1];
            if(!bMsg) return 1;
            if     (aMsg.getTs() > bMsg.getTs()) return 1;
            else if(aMsg.getTs() < bMsg.getTs()) return -1;
            return 0;
        });
        roomList.reverse();
        roomListModel.clear();
        for(var i = 0; i < roomList.length; i++)
            roomListModel.append({ room: roomList[i] })
        roomListItem.refresh();
    }

    function printHelp() {
        var hlp = strong;
        printf("Global commands:", hlp);
        printf("  '/help' : Show this help.");
        printf("Room list index commands:", hlp);
        printf("  '/join <index>' Join a room, e.g. '/join 5'");
        printf("Room commands:", hlp);
        printf("  '/members' Show the room member list.");
        printf("  '/invite @foo:bar' Invite @foo:bar to the room.");
        printf("  '/more 15' Scrollback 15 events");
        printf("  '/resend' Resend the oldest event which failed to send.");
        printf("  '/roominfo' Display room info e.g. name, topic.");
    }

    function printMessages() {
        if(!viewingRoom) return;
        clearLog();
        var mostRecentMessages = viewingRoom.timeline;
        for(var i = 0; i < mostRecentMessages.length; i++)
            printLine(mostRecentMessages[i]);
    }

    function printMemberList(room) {
        var fmts = {
            join:   fmtCol('green'),
            ban:    fmtCol('red'),
            invite: fmtCol('blue'),
            leave:  fmtCol('grey')
        };
        var members = room.currentState.getMembers();
        members.sort(function(a, b) {
            if (a.name > b.name) return -1;
            if (a.name < b.name) return 1;
            return 0;
        });
        printf("Membership list for room \"%1\"", room.name);
        printf(new Array(room.name.length + 28).join("-"));
        room.currentState.getMembers().forEach(function(member) {
            if(!member.membership) return;
            var fmt = fmts[member.membership] || function(a) { return a };
            var membershipWithPadding = (
                member.membership + new Array(10 - member.membership.length).join(" ")
            );
            printf(
                "%1"+fmt(" :: ")+"%2"+fmt(" (")+"%3"+fmt(")"),
                membershipWithPadding, member.name,
                (member.userId === user_id ? "Me" : member.userId),
                fmt
            );
        });
    }

    function printRoomInfo(room) {
        var eventDict = room.currentState.events;
        var eTypeHeader = "    Event Type(state_key)    ";
        var sendHeader = "        Sender        ";
        // pad content to 100
        var restCount = (
            100 - "Content".length - " | ".length - " | ".length -
            eTypeHeader.length - sendHeader.length
        );
        var padSide = new Array(Math.floor(restCount/2)).join(" ");
        var contentHeader = padSide + "Content" + padSide;
        printf(eTypeHeader+sendHeader+contentHeader);
        printf(new Array(100).join("-"));
        Object.keys(eventDict).forEach(function(eventType) {
            if (eventType === "m.room.member") { return; } // use /members instead.
            Object.keys(eventDict[eventType]).forEach(function(stateKey) {
                var typeAndKey = eventType + (
                    stateKey.length > 0 ? "("+stateKey+")" : ""
                );
                var typeStr = fixWidth(typeAndKey, eTypeHeader.length);
                var event = eventDict[eventType][stateKey];
                var sendStr = fixWidth(event.getSender(), sendHeader.length);
                var contentStr = fixWidth(
                    JSON.stringify(event.getContent()), contentHeader.length
                );
                printf(typeStr+" | "+sendStr+" | "+contentStr);
            });
        })
    }

    function printLine(event) {
        var time = new Date(event.getTs()).toLocaleTimeString("hh:mm:ss");
        var name = event.sender ? event.sender.name : event.getSender();
        var body = "";
        var fmt = function(s) { return s };

        if (event.getSender() === user_id) {
            name = "Me";
            if      (event.status === matrix.EventStatus.SENDING ) fmt = fmtCol('gray');
            else if (event.status === matrix.EventStatus.NOT_SENT) fmt = fmtCol('red');
        }

        if(event.getType() === "m.room.message") {
            body = event.getContent().body;
        } else if(event.isState()) {
            var stateName = event.getType();
            if(event.getStateKey().length > 0)
                stateName += " ("+event.getStateKey()+")";
            body = "[State: "+stateName+" updated to: "+JSON.stringify(event.getContent())+"]";
            fmt = fmtCol('gray');
        } else {
            body = "[Message: "+event.getType()+" content: "+JSON.stringify(event.getContent())+"]";
            fmt = fmtCol('gray');
        }

        printf("<font color=gray>[%1]</font> <strong>%2:</strong> %3", time, name, body, fmt);
    }

    function printf() {
        if(typeof arguments[arguments.length-1] === "function") {
            var fmt = arguments[arguments.length-1];
            var args = [];
            for(var i = 0; i < arguments.length-1; i++)
                args.push(fmt(arguments[i]));
            log.apply(log, args);
            return;
        }
        log.apply(log, arguments);
    }

    function fixWidth(str, len) {
        if(str.length > len)
            return str.substr(0, len-2) + "\u2026";
        else if (str.length < len)
            return str + new Array(len - str.length).join(" ");
        return str;
    }
}
