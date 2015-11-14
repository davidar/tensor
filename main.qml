import QtQuick 2.2
import QtQuick.Controls 1.1
import "qml-matrix-0.3.0.js" as Matrix
import "secrets.js" as Secrets

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: "QML Matrix Test"

    Component.onCompleted: {
        Matrix.global.window = window
        main(Secrets.user_id, Secrets.access_token)
    }

    TextArea {
        id: textArea
        anchors.bottom: textField.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        readOnly: true
        textFormat: Qt.RichText
        text: "<h1>Please wait...</h1>"
    }

    TextField {
        id: textField
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        placeholderText: "Command..."
    }

    function log() {
        var args = Array.prototype.slice.call(arguments)
        var s = args[0]
        for(var i = 1; i < args.length; i++)
            s = s.arg(args[i])
        textArea.append(s)
    }

    function clearLog() {
        textArea.text = ''
    }

    function fmtCol(color) {
        return function(s) {
            return "<font color=" + color + ">" + s + "</font>"
        }
    }

    function italic(s) {
        return "<em>" + s + "</em>"
    }

    function main(myUserId, myAccessToken) {
        var sdk = Matrix.global.matrixcs;
        var matrixClient = sdk.createClient({
            baseUrl: "https://matrix.org",
            accessToken: myAccessToken,
            userId: myUserId
        });

        // Data structures
        var roomList = [];
        var viewingRoom = null;
        var numMessagesToShow = 20;

        textField.accepted.connect(function() {
            var line = textField.text;

            if (line.trim().length === 0) {
                textField.text = "";
                return;
            }
            if (line === "/help") {
                printHelp();
                textField.text = "";
                return;
            }

            if (viewingRoom) {
                if (line === "/exit") {
                    viewingRoom = null;
                    printRoomList();
                }
                else if (line === "/members") {
                    printMemberList(viewingRoom);
                }
                else if (line === "/roominfo") {
                    printRoomInfo(viewingRoom);
                }
                else if (line === "/resend") {
                    // get the oldest not sent event.
                    var notSentEvent;
                    for (var i = 0; i < viewingRoom.timeline.length; i++) {
                        if (viewingRoom.timeline[i].status == sdk.EventStatus.NOT_SENT) {
                            notSentEvent = viewingRoom.timeline[i];
                            break;
                        }
                    }
                    if (notSentEvent) {
                        matrixClient.resendEvent(notSentEvent, viewingRoom).done(function() {
                            printMessages();
                            textField.text = "";
                        }, function(err) {
                            printMessages();
                            print("/resend Error: %1", err);
                            textField.text = "";
                        });
                        printMessages();
                        textField.text = "";
                    }
                }
                else if (line.indexOf("/more ") === 0) {
                    var amount = parseInt(line.split(" ")[1]) || 20;
                    matrixClient.scrollback(viewingRoom, amount).done(function(room) {
                        printMessages();
                        textField.text = "";
                    }, function(err) {
                        print("/more Error: %1", err);
                    });
                }
                else if (line.indexOf("/invite ") === 0) {
                    var userId = line.split(" ")[1].trim();
                    matrixClient.invite(viewingRoom.roomId, userId).done(function() {
                        printMessages();
                        textField.text = "";
                    }, function(err) {
                        print("/invite Error: %1", err);
                    });
                }
                else if (line.indexOf("/file ") === 0) {
                    var filename = line.split(" ")[1].trim();
                    var stream = fs.createReadStream(filename);
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
                }
                else {
                    matrixClient.sendTextMessage(viewingRoom.roomId, line).finally(function() {
                        printMessages();
                        textField.text = "";
                    });
                    // print local echo immediately
                    printMessages();
                }
            }
            else {
                if (line.indexOf("/join ") === 0) {
                    var roomIndex = line.split(" ")[1];
                    viewingRoom = roomList[roomIndex];
                    if (viewingRoom.getMember(myUserId).membership === "invite") {
                        // join the room first
                        matrixClient.joinRoom(viewingRoom.roomId).done(function(room) {
                            setRoomList();
                            viewingRoom = room;
                            printMessages();
                            textField.text = "";
                        }, function(err) {
                            print("/join Error: %1", err);
                        });
                    }
                    else {
                        printMessages();
                    }
                }
            }
            textField.text = "";
        });
        // ==== END User input

        // show the room list after syncing.
        matrixClient.on("syncComplete", function() {
            setRoomList();
            printRoomList();
            printHelp();
            textField.text = "";
        });

        matrixClient.on("Room", function() {
            setRoomList();
            if (!viewingRoom) {
                printRoomList();
                textField.text = "";
            }
        });

        // print incoming messages.
        matrixClient.on("Room.timeline", function(event, room, toStartOfTimeline) {
            if (toStartOfTimeline) {
                return; // don't print paginated results
            }
            if (!viewingRoom || viewingRoom.roomId !== room.roomId) {
                return; // not viewing a room or viewing the wrong room.
            }
            printLine(event);
        });

        function setRoomList() {
            roomList = matrixClient.getRooms();
            roomList.sort(function(a,b) {
                // < 0 = a comes first (lower index) - we want high indexes = newer
                var aMsg = a.timeline[a.timeline.length-1];
                if (!aMsg) {
                    return -1;
                }
                var bMsg = b.timeline[b.timeline.length-1];
                if (!bMsg) {
                    return 1;
                }
                if (aMsg.getTs() > bMsg.getTs()) {
                    return 1;
                }
                else if (aMsg.getTs() < bMsg.getTs()) {
                    return -1;
                }
                return 0;
            });
        }

        function printRoomList() {
            clearLog();
            print("Room List:");
            var fmts = {
                "invite": fmtCol('blue'),
                "leave": fmtCol('grey')
            };
            for (var i = 0; i < roomList.length; i++) {
                var msg = roomList[i].timeline[roomList[i].timeline.length-1];
                var dateStr = "---";
                var fmt;
                if (msg) {
                    dateStr = new Date(msg.getTs()).toISOString().replace(
                        /T/, ' ').replace(/\..+/, '');
                }
                var me = roomList[i].getMember(myUserId);
                if (me) {
                    fmt = fmts[me.membership];
                }
                var roomName = fixWidth(roomList[i].name, 25);
                print(
                    "[%1] %2 (%3 members)  %4",
                    i, fmt ? fmt(roomName) : roomName,
                    roomList[i].getJoinedMembers().length,
                    dateStr
                );
            }
        }

        function printHelp() {
            var hlp = italic;
            print("Global commands:", hlp);
            print("  '/help' : Show this help.", fmtCol('black'));
            print("Room list index commands:", hlp);
            print("  '/join <index>' Join a room, e.g. '/join 5'", fmtCol('black'));
            print("Room commands:", hlp);
            print("  '/exit' Return to the room list index.", fmtCol('black'));
            print("  '/members' Show the room member list.", fmtCol('black'));
            print("  '/invite @foo:bar' Invite @foo:bar to the room.", fmtCol('black'));
            print("  '/more 15' Scrollback 15 events", fmtCol('black'));
            print("  '/resend' Resend the oldest event which failed to send.", fmtCol('black'));
            print("  '/roominfo' Display room info e.g. name, topic.", fmtCol('black'));
        }

        function completer(line) {
            var completions = [
                "/help", "/join ", "/exit", "/members", "/more ", "/resend", "/invite"
            ];
            var hits = completions.filter(function(c) { return c.indexOf(line) == 0 });
            // show all completions if none found
            return [hits.length ? hits : completions, line]
        }

        function printMessages() {
            if (!viewingRoom) {
                printRoomList();
                return;
            }
            clearLog();
            var mostRecentMessages = viewingRoom.timeline;
            for (var i = 0; i < mostRecentMessages.length; i++) {
                printLine(mostRecentMessages[i]);
            }
        }

        function printMemberList(room) {
            var fmts = {
                "join": fmtCol('green'),
                "ban": fmtCol('red'),
                "invite": fmtCol('blue'),
                "leave": fmtCol('grey')
            };
            var members = room.currentState.getMembers();
            // sorted based on name.
            members.sort(function(a, b) {
                if (a.name > b.name) {
                    return -1;
                }
                if (a.name < b.name) {
                    return 1;
                }
                return 0;
            });
            print("Membership list for room \"%1\"", room.name);
            print(new Array(room.name.length + 28).join("-"));
            room.currentState.getMembers().forEach(function(member) {
                if (!member.membership) {
                    return;
                }
                var fmt = fmts[member.membership] || function(a){return a;};
                var membershipWithPadding = (
                    member.membership + new Array(10 - member.membership.length).join(" ")
                );
                print(
                    "%1"+fmt(" :: ")+"%2"+fmt(" (")+"%3"+fmt(")"),
                    membershipWithPadding, member.name,
                    (member.userId === myUserId ? "Me" : member.userId),
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
            print(eTypeHeader+sendHeader+contentHeader);
            print(new Array(100).join("-"));
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
                    print(typeStr+" | "+sendStr+" | "+contentStr);
                });
            })
        }

        function printLine(event) {
            var fmt;
            var name = event.sender ? event.sender.name : event.getSender();
            var time = new Date(
                event.getTs()
            ).toISOString().replace(/T/, ' ').replace(/\..+/, '');
            var separator = "&lt;&lt;&lt;";
            if (event.getSender() === myUserId) {
                name = "Me";
                separator = "&gt;&gt;&gt;";
                if (event.status === sdk.EventStatus.SENDING) {
                    separator = "...";
                    fmt = fmtCol('purple');
                }
                else if (event.status === sdk.EventStatus.NOT_SENT) {
                    separator = " x ";
                    fmt = fmtCol('red');
                }
            }
            var body = "";

            var maxNameWidth = 15;
            if (name.length > maxNameWidth) {
                name = name.substr(0, maxNameWidth-1) + "\u2026";
            }

            if (event.getType() === "m.room.message") {
                body = event.getContent().body;
            }
            else if (event.isState()) {
                var stateName = event.getType();
                if (event.getStateKey().length > 0) {
                    stateName += " ("+event.getStateKey()+")";
                }
                body = (
                    "[State: "+stateName+" updated to: "+JSON.stringify(event.getContent())+"]"
                );
                separator = "---";
                fmt = italic;
            }
            else {
                // random message event
                body = (
                    "[Message: "+event.getType()+" Content: "+JSON.stringify(event.getContent())+"]"
                );
                separator = "---";
                fmt = italic;
            }
            if (fmt) {
                print(
                    "[%1] %2 %3 %4", time, name, separator, body, fmt
                );
            }
            else {
                print("[%1] %2 %3 %4", time, name, separator, body);
            }
        }

        function print(str, formatter) {
            if (typeof arguments[arguments.length-1] === "function") {
                // last arg is the formatter so get rid of it and use it on each
                // param passed in but not the template string.
                var newArgs = [];
                var i = 0;
                for (i=0; i<arguments.length-1; i++) {
                    newArgs.push(arguments[i]);
                }
                var fmt = arguments[arguments.length-1];
                for (i=0; i<newArgs.length; i++) {
                    newArgs[i] = fmt(newArgs[i]);
                }
                log.apply(log, newArgs);
            }
            else {
                log.apply(log, arguments);
            }
        }

        function fixWidth(str, len) {
            if (str.length > len) {
                return str.substr(0, len-2) + "\u2026";
            }
            else if (str.length < len) {
                return str + new Array(len - str.length).join(" ");
            }
            return str;
        }

        matrixClient.startClient(numMessagesToShow);  // messages for each room.
    }
}
