import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.3


Window {
    id: _item
    title: "Настройки"
    width: 315
    height: 250
    modality: Qt.ApplicationModal
    signal acepted(string shop, string town, int period);
    property alias shopList: _cmb1.model
    property alias townList: _cmb2.model

    property alias periodUpdate: _spb1.value
    property alias town: _cmb2.currentIndex



    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15
        Row {
            spacing: 10
            Text {
                id: _tx1
                anchors.verticalCenter: _cmb1.verticalCenter
                text: qsTr("Магазин")
            }
            ComboBox {
                id: _cmb1
            }
        }

        Row {
            spacing: 10
            Text {
                id: _tx2
                anchors.verticalCenter: _cmb2.verticalCenter
                text: qsTr("Город")
            }
            ComboBox {
                id: _cmb2
                //currentIndex: find(_mydatabase.myWebElement.currentTown)
            }
        }
        Row {
            spacing: 10
            Text {
                id: _tx3
                anchors.verticalCenter: _spb1.verticalCenter
                text: qsTr("Период обновления")
            }
            SpinBox {
                id: _spb1
                from: 1
                to: 99
                onValueChanged: {
                    if(value%10 == 1) _tx4.text = "день"
                    if(value%10 > 1 && value%10 < 5) _tx4.text = "дня"
                    if(value%10 > 4) _tx4.text = "дней"
                }

            }
            Text {
                id: _tx4
                anchors.verticalCenter: _spb1.verticalCenter
                //text:
            }
        }
        Row {
            spacing: 10
            Button {
                id: _bt1
                text: "Принять"
                onClicked: {
                    _item.acepted(_cmb1.currentText, _cmb2.currentText, _spb1.value);
                }
            }
            Button {
                id:_bt2
                text: "Отмена"
                onClicked: {
                    close();
                }
            }
        }
    }


}
