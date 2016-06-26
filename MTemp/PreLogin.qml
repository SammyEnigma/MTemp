import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Item {
    id: root

    signal connectionRequest(string bAddr, int bPort, string bUser, string bPass);

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Login{
            id: loginPage
            onConnectionRequest: {
                root.connectionRequest(bAddr, bPort, bUser, bPass);
            }
        }
        NetConfig{
            id: netConfigPage
        }

    }

    TabBar {
        id: tabBar
        anchors.bottom: parent.bottom
        width: parent.width
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Login")
        }
        TabButton {
            text: qsTr("Configura Rete")
        }
    }
}
