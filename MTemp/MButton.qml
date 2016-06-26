import QtQuick 2.0

Item {
    id: root
    signal clicked;

    property alias text: btnText.text

    MouseArea{
        anchors.fill: parent;
        onClicked:  {
                        anim1.restart();
                        anim2.restart();
                        root.clicked();
                    }
        Rectangle{
            id: container
            anchors.fill: parent
            border.color: "LightSlateGrey"
            border.width: 1
            radius: 9
            color: "#c7c7c7"

            Text {
                id: btnText
                anchors.centerIn: parent
                text: qsTr("Button")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 11
            }

        }
    }
    ColorAnimation {
        id: anim1;
        target: container
        properties: "color"
        from: "#c7c7c7"
        to: "#aaaaaa"
        duration: 150
    }
    ColorAnimation {
        id: anim2;
        target: container
        properties: "color"
        from: "#aaaaaa"
        to: "#c7c7c7"
        duration: 150
    }


}
