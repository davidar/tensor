import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Window {
    property variant parent

    id: joinRoom
    modality: Qt.WindowModal
    width: 400
    height: 75
    TextField {
        id: roomAlias
        anchors.centerIn: parent
        width: parent.width * 3/4
        placeholderText: "Room alias, e.g. #matrix:matrix.org"
        onAccepted: {
            main.joinRoom(text)
            text = ""
            joinRoom.close()
        }
    }

    onVisibleChanged: {
        setX(parent.x + parent.width  / 2 - width  / 2);
        setY(parent.y + parent.height / 2 - height / 2);
    }
}
