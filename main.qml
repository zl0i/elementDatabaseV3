import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Window 2.3
import WorkDatabase 1.0
import Qt.labs.platform 1.0
//import QtQuick.Dialogs 1.1


ApplicationWindow  {
    visible: true
    width: 640
    height: 480
    minimumHeight: 320
    minimumWidth: 420
    title: qsTr("ElementDatabase 3.0")

    WorkDatabase {
        id: _mydatabase

    }

    MenuBar {

        Menu {
            title: "Файл"
            /*MenuItem {
                text: "Открыть БД"
                onTriggered: {
                    fileDialog.fileMode = FileDialog.OpenFile
                    fileDialog.open()
                }
            }*/
            MenuItem {
                text: "Сохранить БД как.."
                onTriggered: {
                    fileDialog.fileMode = FileDialog.SaveFile
                    fileDialog.open()
                }
            }
            MenuItem {
                text: "Закрыть"
                onTriggered: {
                    Qt.quit()
                }
            }
        }
        Menu {
            title: "Настройки"
            MenuItem {
                text: "Настройки"
                onTriggered: {
                    _setting.show()
                }
            }
        }
    }
    My {
        id: _mainForm
        anchors.fill: parent
        treeView {
            model: _mydatabase.list_TableModel
        }

        tableElement {
            model: _mydatabase.TableModel
        }
    }

    SettingDialog {
        id:_setting        
        shopList: _mydatabase.myWebElement.shop_list
        townList: _mydatabase.myWebElement.town_list
        periodUpdate: _mydatabase.myWebElement.periodUpdate
        town: _mydatabase.myWebElement.currentTownIndex

        onAcepted: {
            _mydatabase.myWebElement.setPeriodUpdate(period)
            _mydatabase.myWebElement.setShop(shop)
            _mydatabase.myWebElement.setTown(town)
            close();
        }
    }
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        //selectExisting: true
        fileMode: FileDialog.SaveFile
        nameFilters: ["Database(*.db)"]
        onAccepted: {
            if(fileMode === FileDialog.SaveFile) {
                console.log(fileDialog.file)
                _mydatabase.saveDtBs(fileDialog.file)
            }
            else {
                console.log("You Open chose: " + fileDialog.fileUrls)
            }
            close()
        }
        onRejected: {
            close()
        }
    }
}
