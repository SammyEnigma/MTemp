import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
    id: root;

    Button{
        id: button1;
        text: qsTr("Prova Config");
        anchors.centerIn: parent;
        width: parent.width / 3;
        height: parent.height / 5;
        onClicked: console.log("config triggerata")
    }
}
