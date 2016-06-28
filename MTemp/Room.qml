import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2


Page {

    id: root;

    property int number
    property int temperature
    property alias name: roomNameLine.textInput
    property alias mode: modeCombo.currentIndex
    property bool status

    signal roomSetRequest
    signal configRequest
    signal roomUpdateRequest

    Row{
        id: roomHeader
        spacing: 15
        anchors{
            top: parent.top
            left: parent.left
            topMargin: 45
            leftMargin: 15
        }

        Image {
            width: 30
            height: 30
            source: "ico/icons/room-64.png"
        }

        Label{
            width: root.width / 2
            text: qsTr("Stanza %1").arg(number + 1);
            font.pixelSize: 25
        }
    }

    Grid{
        id: roomFrame
        anchors{
            top: roomHeader.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 8
        columns: 2

        //  NOME STANZA
        Label{
            width: root.width / 3
            height: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Nome Stanza");
        }

        MTextInput{

            id: roomNameLine
            width: root.width / 2
            height: 30
            textInput.validator: RegExpValidator{
                                    regExp: /^([a-z]||[A-Z]||[0-9])+$/
                                 }
        }

        //  TEMPERATURA
        Label{
            width: root.width / 3
            height: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Temperatura");
        }

        MTextInput{
            id: temperatureLine
            width: root.width / 2
            height: 30
            textInput.text: temperature;
            textInput.readOnly: true;
        }

        //  STATO
        Label{
            width: root.width / 3
            height: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Stato");
        }

        MTextInput{
            id: statusLine
            width: root.width / 2
            height: 30
            textInput.text: {
                                status ? qsTr("On") : qsTr("Off");
                            }
            textInput.font.bold: true;
            textInput.onTextChanged: {
                color = status ? "#73ff73" : "#ff5d5d"
            }

            textInput.readOnly: true;
        }

        //  MODALITA'
        Label{
            width: root.width / 3
            height: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Modalità");
        }

        ComboBox{
            id: modeCombo
            width: root.width / 2
            height: 30
            model: ListModel {
                id: model
                ListElement { text: qsTr("Auto");      }
                ListElement { text: qsTr("Forza On");  }
                ListElement { text: qsTr("Forza Off"); }
            }
        }

        //  CONFIGURAZIONE PROGRAMMI
        Label{
            width: root.width / 3
            height: 60
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Programmi");
        }

        Rectangle{
            width: root.width / 2
            height: 60
            MouseArea{
                id: programConfigButton
                anchors.centerIn: parent
                height: 60
                width: 60
                Image {
                    width: 50
                    height: 50
                    source: "ico/icons/settings-48.png"
                }

                onClicked: {
                    root.configRequest();
                }
            }
        }
    }
    Row{
        id: buttons
        spacing: 15
        anchors{
            top: roomFrame.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }

        MButton{
            id: saveButton
            height: 30
            width: 75
            text: qsTr("Salva");
            onClicked: {
                root.roomSetRequest();
            }
        }

        MButton{
            id: updateButton
            height: 30
            width: 75
            text: qsTr("Aggiorna");
            onClicked: {
                root.roomUpdateRequest();
            }
        }
    }
}


