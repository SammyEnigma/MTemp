import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Item {
    id: root

    signal roomStat(int rNum)

    signal roomSet(int rNum, string name, int mode);

    signal showProgram(int rNum, string roomName);

    function roomUpdate(name, status, mode, temp){

        swipeView.currentItem.name.text = ((temp === 0) ? "Sensore non trovato" : name);
        swipeView.currentItem.mode = mode;
        swipeView.currentItem.status = status;
        swipeView.currentItem.temperature = temp;
    }

    property alias currentIndex: swipeView.currentIndex

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0

        Room{
            id: room0
            number: 0
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 1"
        }
        Room{
            id: room1
            number: 1
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 2"
        }
        Room{
            id: room2
            number: 2
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 3"
        }
        Room{
            id: room3
            number: 3
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 4"
        }
        Room{
            id: room4
            number: 4
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 5"
        }
        Room{
            id: room5
            number: 5
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 6"
        }
        Room{
            id: room6
            number: 6
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 7"
        }
        Room{
            id: room7
            number: 7
            status: false
            mode: 0
            temperature: 25
            name.text: "Stanza 8"
        }

        onCurrentIndexChanged: {
            root.roomStat(currentIndex);
        }
        Component.onCompleted: {
            root.roomStat(0);
        }
    }

    Connections{
        target: swipeView.currentItem

        onRoomSetRequest: {
            root.roomSet(swipeView.currentItem.number, swipeView.currentItem.name.text, swipeView.currentItem.mode);
        }

        onConfigRequest:{
            root.showProgram(swipeView.currentItem.number, swipeView.currentItem.name.text)
        }

        onRoomUpdateRequest: {
            root.roomStat(currentIndex);
        }

    }
}
