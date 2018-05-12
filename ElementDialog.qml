import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

Window {
    id: _item

    property var dataList:[];
    property bool new_or_edit: true;
    signal aceptedd;
    signal rejectedd;
    title: new_or_edit ? "Добавить элемент в таблицу" : "Изменить элемент в таблице"

    height: 350
    width: 350
    minimumHeight: 350
    minimumWidth: 350
    modality: Qt.ApplicationModal

    Column {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 10
        anchors.rightMargin: 20
        spacing: 10
        Row {
            Label {
                id: _lbl1
                anchors.verticalCenter: _txf1.verticalCenter
                text: "Название "
            }
            TextField {
                id: _txf1
                width: 175
                onTextChanged: {
                    _txf3.text = _sw1.position ? "https://www.chipdip.ru//product//" + _txf1.text : _txf3.text
                }
            }
        }
        Row {
            Label {
                id: _lbl3
                anchors.verticalCenter: _spb1.verticalCenter
                text: "Количество "
            }
            SpinBox {
                id: _spb1
                value:  5
            }
            Label {
                id: _lbl4
                anchors.verticalCenter: _spb1.verticalCenter
                text: " штук"
            }
        }
        Row {
            Label {
                id: _lbl2
                anchors.verticalCenter: _txf2.verticalCenter
                text: "Местоположение "
            }
            TextField {
                id: _txf2
                width: 175
            }
        }        
        Row {
            Label {
                id: _lbl5
                anchors.verticalCenter: _txf3.verticalCenter
                text: _sw1.position ? "URL " : "Цена "
            }
            TextField {
                id: _txf3
                width: 175
                text:  _sw1.position ? "https://www.chipdip.ru//product//" + _txf1.text : ""
            }
            Switch {
                id: _sw1
                anchors.verticalCenter: _txf3.verticalCenter
                text: position ? "Авто" : "Вручную"
                onClicked: {
                    _txf3.text = _sw1.position ? "https://www.chipdip.ru//product//" + _txf1.text : ""
                }
            }
        }
        Row {
            Label {
                id: _lbl6
                text: "Описание "
            }
            Rectangle {
                width: 150
                height: 70
                anchors.top: _lbl6.top
                border.color: "gray"
                border.width: 1
                TextArea {
                    id: _txr1
                    anchors.fill: parent
                }
            }
        }
        Row {
            spacing: 15
            Button {
                text: new_or_edit ? "Создать" : "Изменить"
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

    function fillDataList() {
        dataList[1] = _txf1.text  //название
        dataList[2] = _spb1.value //количество
        dataList[3] = _txf2.text  //местоположение
        dataList[4] = _txr1.text  //описание
        if(_sw1.position) {
            dataList[5] = _txf3.text  //url
            dataList[6] = ''
        }
        else {
            dataList[5] = ''
            dataList[6] = _txf3.text // цена
        }
        dataList[7] = '' //наличие
    }

    function setDataList(list) {
        _txf1.text = list[1]
        _spb1.value = Number(list[2])
        _txf2.text = list[3]
        _txr1.text = list[4]
        if(list[5].slice(0, 4) === 'http') {
            if(!_sw1.position) _sw1.toggle()
            _txf3.text = list[5]
            _lbl5.text =  "URL "
        }
        else {
            if(_sw1.position) _sw1.toggle()
            _txf3.text = list[6]
            _lbl5.text =  "Цена "
        }

        dataList[0] = Number(list[0])
        dataList[1] = list[1]
        dataList[2] = list[2]
        dataList[3] = list[3]
        dataList[4] = list[4]
        dataList[5] = list[5]
        dataList[6] = list[6]
        dataList[7] = list[7]
    }

    function clear() {
        _txf1.text = ""
        _txf2.text = ""
        _txf3.text = _sw1.position ? "https://www.chipdip.ru//product//" + _txf1.text : ""
        _lbl5.text =  _sw1.position ? "URL " : "Цена "
        _spb1.value = 0
        _txr1.text = ""
    }

}
