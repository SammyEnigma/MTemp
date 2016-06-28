import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

Item {

    id: root

    anchors.fill: parent

    property alias text: message.text

    AnimatedImage{
        id: gif
        height: 60
        width: 60

        anchors.centerIn: parent
        source: "ico/icons/ajaxloader.gif"
    }
    Label{
        id: message
        anchors{
            top: gif.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 25
        }

        width: root.width / 2
        text: qsTr("Attendi...");
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
