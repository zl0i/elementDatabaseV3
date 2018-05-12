import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

Window {
    id: _item

    property var dataList:[];
    property bool new_or_edit: true;
    signal aceptedd;
    signal rejectedd;
    title: new_or_edit ? "Добавить элемент в проект" : "Изменить элемент в проекте"

    height: 330
    width: 380
    minimumHeight: 330
    minimumWidth: 380
    maximumHeight: 350
    maximumWidth: 330
    modality: Qt.ApplicationModal

    Column {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 10
        anchors.rightMargin: 20
        spacing: 10
        Row {
            spacing: 5
            Label {
                id: _lbl1
                anchors.verticalCenter: _txf1.verticalCenter
                text: "Название"
            }
            TextField {
                id: _txf1
                width: 175
            }
            Button {
                anchors.top: _txf1.top
                anchors.bottom: _txf1.bottom
                //anchors.left: _txf1.right
                //anchors.margins: 4

                width: 50
                text: "..."
            }
        }
        Row {
            spacing: 5
            Label {
                id: _lbl2
                anchors.verticalCenter: _spb1.verticalCenter
                text: "Количество"
            }
            SpinBox {
                id: _spb1
                value:  5
                width: 120
            }
            Label {
                anchors.verticalCenter: _spb1.verticalCenter
                text: "из"
            }
            SpinBox {
                id: _spb2
                anchors.verticalCenter: _spb1.verticalCenter
                value:  5
                width: 120
            }
            Label {
                id: _lbl3
                anchors.verticalCenter: _spb1.verticalCenter
                text: "штук"
            }
        }
        Row {
            spacing: 5
            Label {
                text: "Url"
                anchors.verticalCenter: _txf2.verticalCenter
            }
            TextField {
                id: _txf2
                width: 175
            }
        }

        Row {
            spacing: 5
            Label {
                id: _lbl4
                anchors.verticalCenter: _txf3.verticalCenter
                text: "Сумма"
            }
            TextField {
                id: _txf3
                width: 175
            }
            Label {
                id: _lbl5
                anchors.verticalCenter: _txf3.verticalCenter
                text: "рублей"
            }
        }
        Row {
            spacing: 5
            Label {
                id: _lbl6
                anchors.verticalCenter: _txf4.verticalCenter
                text: "Наличие"
            }
            TextField {
                id: _txf4
                width: 175

            }
            Label {
                id: _lbl7
                anchors.verticalCenter: _txf4.verticalCenter
                text: "штук"
            }
        }
        Row {
            spacing: 15
            Button {
                text: new_or_edit ? "Добавить" : "Изменить"
                onClicked: {
                    fillDataList()
                    _item.aceptedd();
                }
            }
            Button {
                text: "Отмена"
                onClicked: {
                    _item.rejectedd();
                }
            }
        }
    }
    function clear() {
        _txf1.text = ""
        _spb1.value = 0
        _spb2.value = 0
        _txf2.text = ""
        _txf3.text = ""
        _txf4.text = ""
    }
    function fillDataList() {
        dataList[1] = String(_txf1.text);
        dataList[2] = String(_spb1.value) + "/" + String(_spb2.value);
        dataList[3] = String(_txf2.text);
        dataList[4] = String(_txf3.text);
        dataList[5] = String(_txf4.text);
    }

    function setDataList(list) {

        _txf1.text = list[1]
        _spb1.value = Number(list[2].charAt(0))
        _spb2.value = Number(list[2].charAt(2))
        _txf2.text = list[3]
        _txf3.text = list[4]
        _txf4.text = list[5]

        dataList[0] = Number(list[0])
        dataList[1] = list[1]
        dataList[2] = list[2]
        dataList[3] = list[3]
        dataList[4] = list[4]
        dataList[5] = list[5]
    }

}
