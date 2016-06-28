import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {

    id: root;

    property int room
    property string name
    property alias temperature: temperatureDial.value
    property alias weekday: weekdayCombo.currentIndex
    property alias startHours: startHoursLine.text
    property alias startMinutes: startMinutesLine.text
    property alias endHours: endHoursLine.text
    property alias endMinutes: endMinutesLine.text
    property alias enableProgram: enableCheckBox.checked

    signal programGoBack(int rNum)

    signal progGet(int rNum, int wday)

    signal progSet(int rNum, int wday, string sh, string sm, string eh, string em, string tt, bool en)

    Rectangle{

        anchors.fill: parent

        //  INTESTAZIONE
        Row{
            id: programHeader
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
                source: "ico/icons/calendar-52.png"
            }

            Label{
                width: root.width / 2
                text: qsTr("Programmi");
                font.pixelSize: 25
            }
        }

        //  NOME STANZA
        Row{
            id: roomHeader
            spacing: 15
            anchors{
                top: programHeader.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            Label{
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("NomeStanza");
            }

            MTextInput{
                width: root.width / 2
                height: 30
                textInput.text: name;
                textInput.readOnly: true;
            }
        }

        //  GIORNO DELLA SETTIMANA
        Row{
            id: weekdayHeader
            spacing: 15
            anchors{
                top: roomHeader.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            Label{
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Giorno");
            }

            ComboBox{
                id: weekdayCombo
                width: root.width / 2
                height: 30
                model: ListModel {
                    id: model
                    ListElement { text: "Domenica"; }
                    ListElement { text: "Lunedì";   }
                    ListElement { text: "Martedì";  }
                    ListElement { text: "Mercoledì";}
                    ListElement { text: "Giovedì";  }
                    ListElement { text: "Venerdì";  }
                    ListElement { text: "Sabato";   }
                }
                currentIndex: 1
                onCurrentIndexChanged:  {

                                            root.progGet(room, weekday);
                                        }
            }
        }

        //  FRAME TEMPERATURA
        Grid{
            id: temperatureFrame
            anchors{
                top: weekdayHeader.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 8
            columns: 3

            Label{
                width: root.width / 3
                height: temperatureDial.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Temperatura");
            }

            Dial{
                id: temperatureDial
                width: root.width / 4
                height: root.width / 4
                from: 18
                to: 40
            }

            MTextInput{
                id: temperatureDisplay
                width: root.width / 4
                height: temperatureDial.height
                textInput.text: Math.round(temperatureDial.value)
                textInput.readOnly: true;
                textInput.font.pixelSize: 25
                textInput.font.bold: true
            }

            // ORA INIZIO
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
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Ora Inizio");
            }

            MTextInput{
                id: startHoursLine
                width: root.width / 6
                height: 30
                textInput.text: "00"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        id: startHourValidator
                                                        bottom: 0
                                                        top: 23
                                                    }
            }

            MTextInput{
                id: startMinutesLine
                width: root.width / 6
                height: 30
                textInput.text: "00"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        id: startMinutesValidator
                                                        bottom: 0
                                                        top: 59
                                                    }
            }

            // ORA FINE
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
                width: root.width / 3
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Ora Fine");
            }

            MTextInput{
                id: endHoursLine
                width: root.width / 6
                height: 30
                textInput.text: "23"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        id: endHourValidator
                                                        bottom: 0
                                                        top: 23
                                                    }
            }

            MTextInput{
                id: endMinutesLine
                width: root.width / 6
                height: 30
                textInput.text: "59"
                textInput.maximumLength: 2
                textInput.validator: IntValidator   {
                                                        id: endMinutesLineValidator
                                                        bottom: 0
                                                        top: 59
                                                    }
            }
        }


        //  ABILITAZIONE
        CheckBox{
            id: enableCheckBox
            width: root.width / 3
            height: 30
            anchors{
                top: temperatureFrame.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("Abilita");
            checked: true;
        }

        //  BOTTONI
        Row{
            spacing: 15
            anchors{
                top: enableCheckBox.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            MButton{
                id: saveButton
                height: 30
                width: 75
                text: qsTr("Salva");
                onClicked: {

                                root.progSet(room, weekday, startHours, startMinutes, endHours, endMinutes, Math.round(temperature), enableProgram);
                           }
            }

            MButton{
                id: backButton
                height: 30
                width: 75
                text: qsTr("Indietro");
                onClicked: {
                    root.programGoBack(room);
                }
            }
        }
    }
}
