import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Window 2.3
import WorkDatabase 1.0
import Qt.labs.platform 1.0
//import Qt.labs.settings 1.0
//import "myjs.js" as tjs

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
            title: "File"
            MenuItem {
                text: "Save"
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

}
