import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import mclient.testing 1.0

ApplicationWindow{
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("MTemp");

    property bool menuFlag: false

    header: ToolBar {
                    RowLayout {
                        anchors.fill: parent
                        Item { Layout.fillWidth: true }

                        Button  {
                            id: menuButton
                            text: qsTr("\u25BA %1").arg(Qt.application.name)
                            onClicked:  {
                                            menu.open();
                                        }

                            Menu{
                                  id: menu
                                  y: menuButton.height
                                  MenuItem{
                                      id: time
                                      text: qsTr("Data e ora")
                                      enabled: false
                                      onTriggered: {
                                                      loader.source = "Time.qml"
                                                   }
                                  }
                                  MenuItem{
                                      id: logout
                                      text: qsTr("Logout")
                                      enabled: false
                                      onTriggered: {
                                                      client.disconnectFromHost();
                                                   }
                                  }
                                onOpened:   {
                                                menuButton.text = qsTr("\u25BC %1").arg(Qt.application.name);
                                            }
                                onClosed:   {
                                                menuButton.text = qsTr("\u25BA %1").arg(Qt.application.name);
                                            }
                            }
                        }
                    }
                }

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
                                client.address = bAddr;
                                client.port = bPort;
                                client.username = bUser;
                                client.password = bPass;
                                client.connectToHost();
                             }
        onTimeGetRequest:    {
                                console.log("TimeGet");
                                client.timeget();
                             }

        onRoomTriggered: loader.source = "PreLogin.qml";
    }

    Connections{
        target: client
        onTimeGetData:  {
                            loader.item.y.text = y;
                            loader.item.m.text = m;
                            loader.item.d.text = d;
                            loader.item.w.currentIndex = parseInt(w);
                            loader.item.hh.text = hh;
                            loader.item.mm.text = mm;
                            loader.item.ss.text = ss;
                        }
    }

    MClient{
        id: client
        onConnected:    {
                            loader.source = "NormalRun.qml"
                            time.enabled = true
                            logout.enabled = true
                        }
        onDisconnected: {
                            loader.source = "PreLogin.qml"
                            time.enabled = false
                            logout.enabled = false
                        }
    }
}

