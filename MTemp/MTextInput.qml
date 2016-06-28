import QtQuick 2.0

Rectangle{

    property alias textInput: input
    property alias text: input.text
    radius: 5
    border.width: 1
    border.color: "LightSlateGrey"
    clip: true


    TextInput{
        id: input
        anchors.fill: parent
        visible: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        onFocusChanged: {
            cursorVisible: focus
        }
    }
}
