import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3
import QtQuick.Window 2.3
import QtQuick.Layouts 1.3

Window {
    id: _item
    width: 455
    height: 250
    minimumWidth: 455
    minimumHeight: 200
    maximumWidth: 700
    maximumHeight: 500
    modality: Qt.ApplicationModal
    signal selected(string nameTable, string nameElement, int count, int price, int availability);

       Row {
        anchors.fill: parent
        spacing: 3
        Column {
            width: 90
            height: parent.height
            spacing: 5
            TableView {
                id: _list
                width: 90
                height: parent.height - 40
                alternatingRowColors: false
                currentRow: 0
                model: _mydatabase.list_ElementTableModel


                TableViewColumn {
                    title: "Таблица"
                    resizable: false
                }
                onClicked: {
                    if(_button.enabled) _button.enabled = false;
                    _mydatabase.updateSelectedTableElementModel(row)
                }

            }
            Button {
                id: _button
                width: 80
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Выбрать"
                enabled: false
                onClicked: {
                    _item.selected(_mydatabase.list_ElementTableModel[_list.currentRow],
                                   _mydatabase.getName_SelectedTableElementModel(_tableview.currentRow),
                                   _mydatabase.getCount_SelectedTableElementModel(_tableview.currentRow),
                                   _mydatabase.getPrice_SelectedTableElementModel(_tableview.currentRow),
                                   _mydatabase.getAvailability_SelectedTableElementModel(_tableview.currentRow));
                }
            }

        }
        TableView {
            id: _tableview
            height: parent.height - 5
            width: parent.width - _list.width - 5
            alternatingRowColors: false
            model: _mydatabase.SelectElementTableModel
            onClicked: {
                if(!_button.enabled) _button.enabled = true;
            }

            TableViewColumn {
                width: 45
                title: "Name"
                role: "name"
            }
            TableViewColumn {
                width: 50
                title: "Count"
                role: "count"
            }
            TableViewColumn {
                width: 60//_tableview.width - 285 //> 80 ? parent.width - 285 : 80
                title: "Location"
                role: "location"
            }
            TableViewColumn {
                width: _tableview.width-275
                title: "Description"
                role: "description"
            }
            TableViewColumn {
                width: 60
                title: "Price"
                role: "price"
            }
            TableViewColumn {
                width: 80
                title: "Availability"
                role: "availability"
            }
        }
    }
}
