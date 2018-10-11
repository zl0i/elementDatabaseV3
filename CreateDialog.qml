import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

Window {
    id: dialog
    width: 315
    height: 110
    maximumWidth: 315
    maximumHeight: 110
    minimumWidth: 315
    minimumHeight: 110


    property alias _textfield: _textfield
    property alias button1: button1
    property alias button: button

    title: "create.."
    Column {
        anchors.fill: parent
        spacing: 15
        Row {
            id: row
            /*anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height/2
            anchors.margins: 10*/
            anchors.horizontalCenter: parent.horizontalCenter
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
            /*anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: row.bottom
            anchors.bottomMargin: 5
            anchors.leftMargin: 50*/
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            Button {
                id: button
                text: "Создать"

            }
            Button {
                id: button1
                text: "Отмена"

            }
        }
    }


}
