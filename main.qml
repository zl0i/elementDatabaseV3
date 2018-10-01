import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Window 2.3
import WorkDatabase 1.0
import Qt.labs.platform 1.0


ApplicationWindow  {
    visible: true
    width: 640
    height: 480
    minimumHeight: 320
    minimumWidth: 420
    title: qsTr("elementDtabase V3")
    WorkDatabase {
        id: _mydatabase
    }


    MenuBar {

        Menu {
            title: "Файл"
            MenuItem {
                text: "Открыть БД"
            }
            MenuItem {
                text: "Сохранить БД"
            }
            MenuItem {
                text: "Сохранить БД как.."
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
}
