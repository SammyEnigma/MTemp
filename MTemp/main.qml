import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import mclient.testing 1.0

ApplicationWindow{
    id: root
    visible: true
    width: 320
    height: 620
    title: qsTr("MTemp");

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
                                                      client.timeget();
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
            duration: 500
            easing.type: Easing.Linear
        }
    }

    Connections{
        target: loader.item
        onConnectionRequest: {
                                console.log("ConnectionRequest");
                                loader.source = "UserLocker.qml"
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

        onTimeSetRequest:    {
                                console.log("TimeSet");
                                client.timeset(yrs, mon, day, wday, hrs, min, sec);
                             }
        onTimeGoBack:        {
                                loader.source = "NormalRun.qml"
                                client.roomstat(0);
                             }
        onRoomStat:          {
                                console.log("RoomStat");
                                client.roomstat(rNum);
                             }
        onRoomSet:           {
                                console.log("RoomSet");
                                client.roomset(rNum, name, mode);
                             }
        onShowProgram:       {
                                console.log("ShowProgram");
                                loader.source = "Program.qml"
                                loader.item.room = rNum;
                                loader.item.name = roomName;
                                loader.item.weekday = 0;
                             }

        onProgramGoBack:     {
                                console.log("ProgramGoBack");
                                loader.source = "NormalRun.qml";
                                loader.item.currentIndex = rNum;
                                client.roomstat(rNum);
                             }
        onProgGet:           {
                                console.log("ProgGet");
                                client.progget(rNum, wday);
                             }

        onProgSet:           {

                                console.log("ProgSet");
                                client.progset(rNum, wday, sh, sm, eh, em, tt, en);
                             }

    }




    Connections{
        target: client
        onTimeGetData:  {
                            loader.item.timeUpdate(yrs, mon, day, wday, hrs, min, sec);
                        }
        onRoomStatData: {
                            loader.item.roomUpdate(roomName, state, mode, temperature);
                        }
        onProgGetData:  {
                            loader.item.temperature = temp;
                            loader.item.weekday = wday;
                            loader.item.startHours = sh;
                            loader.item.startMinutes = sm;
                            loader.item.endHours = eh;
                            loader.item.endMinutes = em;
                            loader.item.enableProgram = en;
                        }

    }

    MClient{
        id: client
        onConnected:    {
                            loader.source = "NormalRun.qml"
                            client.roomstat(0);
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

