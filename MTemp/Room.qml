import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
    id: root;

    property alias name: roomName.text

    signal forceOn(string forceCommand)

    function forceOnString(){
        var str = "admin*admin";
        return str;
    }

    Column{
        anchors.centerIn: parent
        width: parent.width / 2
        Text {
            id: roomName
            text: qsTr("Nome stanza")
        }
        Button{
            id: forceOnBtn;
            text: "Forza acceso";
            onClicked: {
                root.forceOn(forceOnString());
            }
        }
    }


}
