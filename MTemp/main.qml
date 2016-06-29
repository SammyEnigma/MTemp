import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.6
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
                                control.running = true;
                                //loader.source = "UserLocker.qml"
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
                                control.running = true;
                                client.roomstat(rNum);
                             }
        onRoomSet:           {
                                console.log("RoomSet");
                                control.running = true;
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
                                control.running = true;
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
                            control.running = false;
                        }
        onProgGetData:  {
                            loader.item.temperature = temp;
                            loader.item.weekday = wday;
                            loader.item.startHours = sh;
                            loader.item.startMinutes = sm;
                            loader.item.endHours = eh;
                            loader.item.endMinutes = em;
                            loader.item.enableProgram = en;
                            buzzer.play();
                            control.running = false;
                        }

    }

    MClient{
        id: client
        onConnected:    {
                            control.running = false;
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
        onBoardError:   {
                            dialog.text = qsTr("Errore autenticazione");
                            dialog.open();
                            client.disconnectFromHost();
                        }
        onBoardFailure: {
                            dialog.text = qsTr("Errore nel comando, ricontrolla i parametri.");
                            dialog.open();
                        }
        onError:        {
                            dialog.text = qsTr("Errore: ") + sockErr;
                            dialog.open();
                        }
    }

    SoundEffect{
        id: buzzer
        source: "/media/sounds/buzzer.wav"
    }

    BusyIndicator {
        id: control

        anchors.centerIn: parent
        running: false

        contentItem: Item {
            implicitWidth: 64
            implicitHeight: 64

            Item {
                id: item
                x: parent.width / 2 - 32
                y: parent.height / 2 - 32
                width: 64
                height: 64
                opacity: control.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: control.visible && control.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 6

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: "black"
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: 5
                                origin.y: 5
                            }
                        ]
                    }
                }
            }
        }
        onRunningChanged: {
            if(running){
                loader.item.opacity = 0.5;
                loader.item.enabled = false;
                menuButton.enabled = false;
            }else{
                loader.item.opacity = 1;
                loader.item.enabled = true;
                menuButton.enabled = true;
            }
        }
    }


    // MESSAGE BOX
    MessageDialog{
        id: dialog
        standardButtons: StandardButton.Ok;
        title: "Errore";
    }
}

