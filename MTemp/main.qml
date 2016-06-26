import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import mclient.testing 1.0

ApplicationWindow{
    id: root
    visible: true
    width: 320
    height: 480
    title: qsTr("MTemp");
    //icon: ":/icons/mtemp-ico-50.png"


    Loader{
        id: loader
        anchors.fill: parent
        source: "PreLogin.qml"

        onSourceChanged: animation.running = true

        NumberAnimation {
            id: animation
            target: loader.item
            property: "y"
            from: root.height
            to: 0
            duration: 250
            easing.type: Easing.Linear
        }
    }

    Connections{
        target: loader.item
        onConnectionRequest: {
                                console.log("ConnectionRequest");
                                console.log(bAddr);
                                console.log(bPort);
                                console.log(bUser);
                                console.log(bPass);
                                client.address = bAddr;
                                client.port = bPort;
                                client.username = bUser;
                                client.password = bPass;
                                client.connectToHost();
                             }
        onRoomTriggered: loader.source = "PreLogin.qml";
    }

    MClient{
        id: client
        onConnected: {
                        loader.source = "NormalRun.qml"
                     }
    }

}





/*
SwipeView {
    id: swipeView
    anchors.fill: parent
    currentIndex: tabBar.currentIndex

    Page1 {
    }

    Page {
        Label {
            text: qsTr("Second page")
            anchors.centerIn: parent
        }
    }
}

footer: TabBar {
    id: tabBar
    currentIndex: swipeView.currentIndex
    TabButton {
        text: qsTr("First")
    }
    TabButton {
        text: qsTr("Second")
    }
}
*/
