import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Item {
    id: root

    signal connectionRequest(string bAddr, int bPort, string bUser, string bPass);

    SwipeView {
        id: swipeView
        anchors.fill: parent

        Login{
            id: loginPage
            onConnectionRequest: {
                root.connectionRequest(bAddr, bPort, bUser, bPass);
            }
        }
    }

}
