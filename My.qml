import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2


MyForm {

    button.onClicked: { // add table element
       _dialog.show()
    }
    button1.onClicked: { // add table element
       _dialog2.show()
    }
    button2.onClicked: {       
        _deleteDialogTable.show() // remove table
    }
    button3.onClicked: {
        button.enabled = false;
        button1.enabled = false;
        button2.enabled = false;
        button3.enabled = false;
        button4.enabled = false;
        button5.enabled = false;
        button6.enabled = false;
        button7.enabled = false;
        _mydatabase.updatePriceAndAvailability()
    }

    Timer {
        interval: 500
        running: true
        repeat: false
        onTriggered: {
            _mydatabase.chekUpdateTime()
        }
    }
    Connections {
           target: _mydatabase // Указываем целевое соединение

           onFinishUpdate: {
               button.enabled = true;
               button1.enabled = true;
               button2.enabled = true;
               button3.enabled = true;
               button4.enabled = true;
               button5.enabled = true;
               button6.enabled = true;
               button7.enabled = true;

               _mydatabase.updateTableModel(treeView.currentIndex);
               if(treeView.currentIndex.parent.row !== 0) {
                 _mydatabase.calculatePriceProject()
                 label.text = "Стоимость всех компонентов = " + _mydatabase.total +" руб.";
               }
               _myMsg.title = "Готово"
               _myMsg.text = "Обновление завершено"
               _myMsg.show()
           }
           onErrorUpdate: {
               button.enabled = true;
               button1.enabled = true;
               button2.enabled = true;
               button3.enabled = true;
               button4.enabled = true;
               button5.enabled = true;
               button6.enabled = true;
               button7.enabled = true;

               _myMsg.title = "Ошибка"
               _myMsg.text = "Не удалось обновить \n" + str
               _myMsg.show()

           }
           onTimeUpdate: {               
               _updateDialog.show()
           }

    }

    button4.onClicked: {
        //новый элемент
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
        //редактирование элемента
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
        //удаление элемента
        _deleteDialogElemnt.show()
    }
    button7.onClicked: {  //activate project
        _mydatabase.activateProject()
        button.enabled = false;
        button1.enabled = false;
        button2.enabled = false;
        button3.enabled = false;
        button4.enabled = false;
        button5.enabled = false;
        button6.enabled = false;
        button7.enabled = false;
        _mydatabase.updatePriceAndAvailability()
    }

    treeView.onClicked: {
        //выбор таблицы
        _mydatabase.updateListRoles(treeView.currentIndex);
        tableElement.newColumns(_mydatabase.list_Roles);
        _mydatabase.updateTableModel(treeView.currentIndex);
        if(treeView.currentIndex.parent.row === 0) {
           button7.visible = false;
           label.visible = false;
        }
        else {
            button7.visible = true;
            label.visible = true;
            _mydatabase.calculatePriceProject();
            label.text = "Стоимость всех компонентов = " + _mydatabase.total +" руб.";
        }
    }
    tableElement.onDoubleClicked: {
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

    CreateDialog {
        //создание новой таблицы элементов
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
        //создание новой таблицы проетка
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
    MyMessageDialog  {      //удаление таблицы
        id: _deleteDialogTable
        title: "Удаление"
        height: 200
        width: 300
        maximumWidth: 300
        text: "Вы действительно хотите удалить эту таблицу?"
        buttonCansel: true
        onAccepted: {
            _mydatabase.deleteTableOrProject(treeView.currentIndex)
            close()
        }
        onRejected: {
            close()
        }
    }

    ElementDialog {
        //добавление нового элемента в таблицу элементов
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
        //добавление нового элемента в таблицу проекта
        id: _projectDialog
        onAceptedd: {
            if(new_or_edit === true) {
                if(_mydatabase.addProjectElement(_projectDialog.dataList) === false) {
                    console.log("Элемент не добавлен в БД")
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

    MyMessageDialog {
        //удаление элемента из таблицы
        id: _deleteDialogElemnt
        title: "Удаление"
        height: 200
        width: 300
        maximumWidth: 300
        text: "Вы действительно хотите удалить этот элемент из списка?"
        buttonCansel: true
        onAccepted: {
            _mydatabase.removeElement(tableElement.currentRow)
            _mydatabase.updateTableModel(treeView.currentIndex);
            close()
        }
        onRejected: {
            close()
        }
    }
    MyMessageDialog  {      //обновление цен и наличия
            id: _updateDialog
            title: "Внимане"
            height: 200
            width: 300
            maximumWidth: 300
            text: "Пора обновляться"
            buttonCansel: true
            buttonOKText: "Обновить"
            buttonCanselText: "Отмена"
            onAccepted: {
                button.enabled = false;
                button1.enabled = false;
                button2.enabled = false;
                button3.enabled = false;
                button4.enabled = false;
                button5.enabled = false;
                button6.enabled = false;
                button7.enabled = false;
                _mydatabase.updatePriceAndAvailability()
                close()
            }
            onRejected: {
                close()
            }
        }
    MyMessageDialog {
        id: _myMsg
        width: 300
    }
}
