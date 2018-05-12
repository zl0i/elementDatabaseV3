import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.3



Dialog {
    id: dialog
    width: 275
    height: 110



    property alias _textfield: _textfield
    property alias button1: button1
    property alias button: button

    title: "create.."
    contentItem: Rectangle {
        id: rectangle
        anchors.fill: parent
        Row {
            id: row
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height/2
            anchors.margins: 10
            spacing: 5
            Label {
                anchors.leftMargin: 10
                id: text1
                text: "Название "
                anchors.verticalCenter: _textfield.verticalCenter

            }
            TextField {
                id: _textfield
                height: 30

            }
        }
        Row {
            id: row1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: row.bottom
            anchors.bottomMargin: 5
            anchors.leftMargin: 50
            spacing: 15
            Button {
                id: button
                text: "Ok"

            }
            Button {
                id: button1
                text: "Cansel"

            }
        }
    }


}

