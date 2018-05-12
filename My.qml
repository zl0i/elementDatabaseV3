import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2


MyForm {
    button.onClicked: { // add table element
       _dialog.open()
    }
    button1.onClicked: { // add table element
       _dialog2.open()
    }
    button2.onClicked: {
        _deleteDialogTable.open() // remove table
    }
    button3.onClicked: {
        _mydatabase.updatePriceElement()
    }
    button4.onClicked: {
        //opendialog
        if(treeView.currentIndex.parent.row === 0) {
            _elementDialog.new_or_edit = true;
            _elementDialog.clear()
            _elementDialog.show()
        }
        else {
            _projectDialog.new_or_edit = true;
            _projectDialog.clear();
            _projectDialog.show();
        }
    }
    button5.onClicked: {
        //opendialog with data
         if(treeView.currentIndex.parent.row === 0) {
            _elementDialog.new_or_edit = false;
            _elementDialog.setDataList(_mydatabase.getDataFromModel(tableElement.currentRow));
            _elementDialog.show();
         }
         else {
            _projectDialog.new_or_edit = false;
            _projectDialog.setDataList(_mydatabase.getDataFromModel(tableElement.currentRow));
            _projectDialog.show();
         }
    }
    button6.onClicked: {
        _deleteDialogElemnt.open()
    }


    treeView.onClicked: {
        _mydatabase.updateListRoles(treeView.currentIndex);
        tableElement.newColumns(_mydatabase.list_Roles);
        _mydatabase.updateTableModel(treeView.currentIndex);
    }
    tableElement.onDoubleClicked: {
        //_mydatabase.editElement();
    }

    CreateDialog {
        id: _dialog
        title: "Новая таблица элементов"
        button.onClicked: {
            _mydatabase.createTable(_textfield.text)
            close()
        }
        button1.onClicked: {
            close()
        }
    }
    CreateDialog {
        id: _dialog2
        title: "Новый проект"
        button.onClicked: {
            _mydatabase.createProject(_textfield.text)
            close()
        }
        button1.onClicked: {
            close()
        }
    }
    MessageDialog {
        id: _deleteDialogTable
        title: "Удаление"
        informativeText: "Вы действительно хотите удалить эту таблицу?"
        standardButtons: MessageDialog.Ok | MessageDialog.Cancel
        onAccepted: _mydatabase.deleteTableOrProject(treeView.currentIndex)
        onRejected: close()
    }

    ElementDialog {
        id: _elementDialog
        onAceptedd: {
            if(new_or_edit === true) {
                if(_mydatabase.addElement(_elementDialog.dataList) === false) {
                    console.log("Элемент не добавленd в БД")
                }
                else {
                    console.log("Элемент добавлен в БД")
                    _mydatabase.updateTableModel(treeView.currentIndex);
                    close()
                }
            }
            else {
                if(_mydatabase.editElement(_elementDialog.dataList) === false) {
                    console.log("Элемент не изменен")
                }
                else {
                    console.log("Элемент изменен")
                    _mydatabase.updateTableModel(treeView.currentIndex);
                    close()
                }
            }
        }
        onRejectedd: {
            close()
        }
    }
    ProjectDialog {
        id: _projectDialog
        onAceptedd: {
            if(new_or_edit === true) {
                if(_mydatabase.addProjectElement(_projectDialog.dataList) === false) {
                    console.log("Элемент не добавленd в БД")
                }
                else {
                    console.log("Элемент добавлен в БД")
                    _mydatabase.updateTableModel(treeView.currentIndex);
                    close()
                }
            }
            else {
                if(_mydatabase.editProjectElement(_projectDialog.dataList) === false) {
                    console.log("Элемент не изменен")
                }
                else {
                    console.log("Элемент изменен")
                    _mydatabase.updateTableModel(treeView.currentIndex);
                    close()
                }
            }
        }
        onRejectedd: {
            close()
        }
    }

    MessageDialog {
        id: _deleteDialogElemnt
        title: "Удаление"
        informativeText: "Вы действительно хотите удалить этот элемент из списка?"
        standardButtons: MessageDialog.Ok | MessageDialog.Cancel
        onAccepted: {
            _mydatabase.removeElemnt(tableElement.currentRow)
            _mydatabase.updateTableModel(treeView.currentIndex);
            close()
        }
        onRejected: {
            close()
        }
    }
}
