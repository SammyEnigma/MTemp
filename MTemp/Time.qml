import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

Item {

    id: root;

    property alias yrs  : year.textInput
    property alias mon  : month.textInput
    property alias day  : day.textInput
    property alias week  : weekdayCombo
    property alias hrs : hours.textInput
    property alias min : minutes.textInput
    property alias sec : seconds.textInput


    signal timeGetRequest
    signal timeSetRequest

    Rectangle{

        anchors.fill: parent

        Row{
            id: dateTimeHeader
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
                source: "ico/icons/clock-48.png"
            }

            Label{
                width: root.width / 2
                text: qsTr("Data e Ora");
                font.pixelSize: 25
            }
        }

        Grid{
            id: dateTimeFrame
            anchors{
                top: dateTimeHeader.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 8
            columns: 4

            Label{
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label{
                width: root.width / 6
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Ore");
            }

            Label{
                width: root.width / 6
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Minuti");
            }

            Label{
                width: root.width / 6
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Secondi");
            }

            Label{
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Orario");
            }

            MTextInput{
                id: hours
                width: root.width / 6
                height: 30
                textInput.text: "12"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        bottom: 0
                                                        top: 23
                                                    }
            }

            MTextInput{
                id: minutes
                width: root.width / 6
                height: 30
                textInput.text: "30"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        bottom: 0
                                                        top: 59
                                                    }
            }

            MTextInput{
                id: seconds
                width: root.width / 6
                height: 30
                textInput.text: "30"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        bottom: 0
                                                        top: 59
                                                    }
            }

            Label{
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label{
                width: root.width / 6
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Giorno");
            }

            Label{
                width: root.width / 6
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Mese");
            }

            Label{
                width: root.width / 6
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Anno");
            }
            Label{
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Data");
            }

            MTextInput{
                id: day
                width: root.width / 6
                height: 30
                textInput.text: "12"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        id: dayValidator
                                                        bottom: 0
                                                        top: 31
                                                    }
            }

            MTextInput{
                id: month
                width: root.width / 6
                height: 30
                textInput.text: "30"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        bottom: 1
                                                        top: 12
                                                    }
            }

            MTextInput{
                id: year
                width: root.width / 6
                height: 30
                textInput.text: "30"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        bottom: 0
                                                        top: 99
                                                    }
            }
        }

        ComboBox{
            id: weekdayCombo
            anchors{
                top: dateTimeFrame.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }
            width: root.width / 2
            height: 30
            editable: false
            model: ListModel {
                id: model
                ListElement { text: "Domenica";     number: 1}
                ListElement { text: "Lunedì";       number: 2}
                ListElement { text: "Martedì";      number: 3}
                ListElement { text: "Mercoledì";    number: 4}
                ListElement { text: "Giovedì";      number: 5}
                ListElement { text: "Venerdì";      number: 6}
                ListElement { text: "Sabato";       number: 7}
                ListElement { text: "Domenica";     number: 8}
            }
            currentIndex: 1
        }

        Row{
            spacing: 15
            anchors{
                top: weekdayCombo.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            MButton{
                id: updateButton
                height: 30
                width: 75
                text: qsTr("Aggiorna");
                onClicked: {
                                root.timeGetRequest();
                           }
            }

            MButton{
                id: setButton
                height: 30
                width: 75
                text: qsTr("Imposta");
                onClicked: {
                           }
            }

            MButton{
                id: cancelButton
                height: 30
                width: 75
                text: qsTr("Annulla");
                onClicked: {
                           }
            }
        }
    }
}
