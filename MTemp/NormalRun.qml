import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Item {
    id: root

    signal roomTriggered

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0

        Room{
            name: "Stanza 1"
            onForceOn: {
                console.log(forceCommand);
                root.roomTriggered();
            }
        }
        Room{
            name: "Stanza 2"
        }

    }

    /*
    TabBar {
        id: tabBar
        anchors.bottom: parent.bottom
        width: parent.width
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Nome Stanza 1")
        }
        TabButton {
            text: qsTr("Nome Stanza 2")
        }
    }
    */
}
