import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

Item {

    id: root;

    signal timeGetRequest
    signal timeSetRequest(string yrs, string mon, string day, string wday, string hrs, string min, string sec);
    signal timeGoBack

    function timeUpdate(year, month, day, wday, hours, minute, seconds){
          yearLine.textInput.text = year;
          monthLine.textInput.text = month;
          dayLine.textInput.text = day;
          weekdayCombo.currentIndex = wday - 1;
          hoursLine.textInput.text = hours;
          minutesLine.textInput.text = minute;
          secondsLine.textInput.text = seconds;
          tmr.start();
    }

    function timer(){
        var d = new Date();
        console.log(d);

        if(yearLine.textInput.focus  || monthLine.textInput.focus   || dayLine.textInput.focus     ||
           hoursLine.textInput.focus || minutesLine.textInput.focus || secondsLine.textInput.focus ||
           weekdayCombo.focus){
            return;
        }

        d.setFullYear(yearLine.textInput.text + 2000);
        d.setMonth(parseInt(monthLine.textInput.text) - 1);
        d.setDate(parseInt(dayLine.textInput.text));
        d.setHours(parseInt(hoursLine.textInput.text));
        d.setMinutes(parseInt(minutesLine.textInput.text));
        d.setSeconds(parseInt(secondsLine.textInput.text) + 1);

        yearLine.textInput.text = d.getFullYear() - 2000;
        monthLine.textInput.text = d.getMonth() + 1
        dayLine.textInput.text = d.getDate();
        weekdayCombo.currentIndex = d.getUTCDay() - 1;
        hoursLine.textInput.text = d.getHours();
        minutesLine.textInput.text = d.getMinutes();
        secondsLine.textInput.text = d.getSeconds();

        delete d;
    }

    Timer{
        id: tmr
        interval: 1000
        repeat: true;
        onTriggered: {
            timer();
        }
    }

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
                id: hoursLine
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
                id: minutesLine
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
                id: secondsLine
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
                id: dayLine
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
                id: monthLine
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
                id: yearLine
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
        }

        Row{
            spacing: 15
            anchors{
                top: weekdayCombo.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            MButton{
                id: setButton
                height: 30
                width: 75
                text: qsTr("Imposta");
                onClicked: {
                                root.timeSetRequest(yearLine.textInput.text,
                                                    monthLine.textInput.text,
                                                    dayLine.textInput.text,
                                                    weekdayCombo.currentIndex,
                                                    hoursLine.textInput.text,
                                                    minutesLine.textInput.text,
                                                    secondsLine.textInput.text);
                                focus = true;
                           }
            }

            MButton{
                id: cancelButton
                height: 30
                width: 75
                text: qsTr("Indietro");
                onClicked: {
                                root.timeGoBack();
                           }
            }
        }
    }

}
