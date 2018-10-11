import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3



TableView {
    id: tableViewElement
    alternatingRowColors: false
    selectionMode: SelectionMode.SingleSelection


    function clearColumn() {
        var i = columnCount
        while(i--) {
            removeColumn(i)
        }
    }
    function addColumnsFromList(list_roles) {
        var cnt = 0
        //console.log(list_roles.length, list_roles)
        while(cnt < list_roles.length) {
            var wd = 50 + 2*list_roles[cnt].length
            var str = 'import QtQuick 2.10; import QtQuick.Controls 1.4;
                        TableViewColumn {role: "' + list_roles[cnt] + '";
                                         title: "'+ list_roles[cnt] + '";
                                         movable: false;
                                         horizontalAlignment: Text.AlignHCenter;
                                         width: ' + wd +';}';


            var column = Qt.createQmlObject(str, tableViewElement)
            //console.log(list_roles[cnt])
            tableViewElement.insertColumn(cnt, column)
            cnt++
        }
        tableViewElement.resizeColumnsToContents()
    }
    function newColumns(list_roles) {
        clearColumn();
        addColumnsFromList(list_roles);
    }
}

