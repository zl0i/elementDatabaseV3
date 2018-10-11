import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

Window {
    id: _item

    property alias text: _tx1.text
    property alias buttonCansel: _buttonCansel.visible
    property alias buttonOKText: _buttonOk.text
    property alias buttonCanselText: _buttonCansel.text
    property alias title: _item.title
    signal accepted();
    signal rejected();

    property alias height: _item.height
    property alias width: _item.width
    property alias minimumHeight: _item.minimumHeight
    property alias minimumWidth: _item.minimumWidth
    property alias maximumHeight: _item.maximumHeight
    property alias maximumWidth: _item.maximumWidth

    title: ""
    height: 100
    width: 300
    minimumHeight: 100
    minimumWidth: 300
    maximumHeight: 100
    maximumWidth: 300
    modality: Qt.ApplicationModal

    Column {
        anchors.fill: parent
        anchors.topMargin: 10
        spacing: 20
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            id: _tx1
            text: qsTr("text")
        }
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                //anchors.horizontalCenter: parent.horizontalCenter
                id: _buttonOk
                text: "Ок"
                onClicked: {
                    _item.accepted()
                    _item.close()
                }
            }
            Button {
                //anchors.horizontalCenter: parent.horizontalCenter
                id: _buttonCansel
                text: "Отмена"
                visible: false
                onClicked: {
                    _item.rejected()
                    _item.close()
                }
            }
        }
    }
}
