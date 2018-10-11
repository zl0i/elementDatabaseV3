import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2


Dialog {
    id: item1
    width: 400
    height: 450
    property alias switch1: switch1

 contentItem: Rectangle {
     anchors.fill: parent
    Label {
        id: label
        x: 30
        y: 74
        text: qsTr("Название")
        anchors.verticalCenterOffset: -199
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 12
    }

    Switch {
        id: switch1
        y: 244
        text: position ? "Авто" : "Ручной"
        anchors.verticalCenterOffset: 0
        anchors.left: textField.left
        anchors.leftMargin: 0
        anchors.verticalCenter: label3.verticalCenter
    }

    Button {
        id: button
        x: 138
        y: 351
        text: qsTr("Button")
    }

    Button {
        id: button1
        x: 261
        y: 351
        text: qsTr("Button")
    }

    TextField {
        id: textField
        y: 60
        text: qsTr("")
        anchors.verticalCenterOffset: 0
        font.pointSize: 12
        anchors.left: textField1.left
        anchors.leftMargin: 0
        anchors.verticalCenter: label.verticalCenter
    }

    Label {
        id: label1
        text: qsTr("Местоположение")
        anchors.top: label2.bottom
        anchors.topMargin: 30
        anchors.left: label.left
        anchors.leftMargin: 0
        font.pointSize: 12
    }

    TextField {
        id: textField1
        x: 2
        y: 62
        text: qsTr("")
        anchors.verticalCenterOffset: 0
        font.pointSize: 12
        anchors.verticalCenter: label1.verticalCenter
        anchors.leftMargin: 6
        anchors.left: label1.right
    }

    SpinBox {
        id: spinBox
        x: 160
        y: 117
        anchors.verticalCenter: label2.verticalCenter
    }

    Label {
        id: label2
        text: qsTr("Количество")
        anchors.top: label.bottom
        anchors.topMargin: 30
        font.pointSize: 12
        anchors.left: label.left
        anchors.leftMargin: 0
    }

    Label {
        id: label3
        text: qsTr("Цена и наличие")
        anchors.top: label1.bottom
        anchors.topMargin: 30
        anchors.left: label.left
        anchors.leftMargin: 0
        font.pointSize: 12
    }

    Label {
        id: label4
        text: qsTr("Сообщение")
        anchors.top: label3.bottom
        anchors.topMargin: 30
        anchors.left: label.left
        anchors.leftMargin: 0
        font.pointSize: 12
    }
    Rectangle {
        anchors.top: label4.top
        anchors.topMargin: 0
        anchors.right: textField.right
        anchors.rightMargin: 0
        anchors.left: textField.left
        anchors.leftMargin: 0
        height: 108
        border {
            color: textEdit.focus ? "#1E90FF" :"#D3D3D3"
            width: textEdit.focus ? 2 : 1

        }

        TextEdit {
            id: textEdit
            anchors.fill: parent
            anchors.margins: 2
            text: qsTr("Text Edit")
            cursorVisible: true
            font.pixelSize: 12

        }
    }
 }

}
