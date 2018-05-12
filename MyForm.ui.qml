import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3


Item {
    id: item1
    width: 640
    height: 480
    property alias rectangle: rectangle
    property alias button3: button3
    property alias button6: button6
    property alias button5: button5
    property alias button4: button4
    property alias tableElement: tableElement
    property alias button2: button2
    property alias button: button
    property alias button1: button1
    property alias treeView: treeView

    Rectangle {
        id: rectangle
        width: 50
        color: "#312e2e"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Column {
            id: column
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            spacing: 15
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Button {
                id: button
                height: 50
                text: qsTr("")
                highlighted: false
                antialiasing: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                background: Rectangle {
                    color: button.pressed ?  "#959595" : rectangle.color
                }
                Image {
                    id: image
                    antialiasing: true
                    anchors.rightMargin: 7
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 7
                    anchors.topMargin: 7
                    anchors.fill: parent
                    source: "qrc:/icon/new_table.png"
                }



            }

            Button {
                id: button1
                height: 50
                text: qsTr("")
                highlighted: false
                antialiasing: true
                transformOrigin: Item.Center
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                background: Rectangle {
                    color: button1.pressed ?  "#959595" : rectangle.color
                }

                Image {
                    id: image1
                    antialiasing: true
                    anchors.rightMargin: 7
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 7
                    anchors.topMargin: 7
                    anchors.fill: parent
                    source: "qrc:/icon/new_proj.png"
                }
            }

            Button {
                id: button2
                height: 50
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                background: Rectangle {
                    color: button2.pressed ?  "#959595" : rectangle.color
                }

                Image {
                    id: image2
                    antialiasing: true
                    anchors.rightMargin: 7
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 7
                    anchors.topMargin: 7
                    anchors.fill: parent
                    source: "qrc:/icon/delete.png"
                }
            }

            Button {
                id: button3
                height: 50
                text: qsTr("")
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                background: Rectangle {
                    color: button3.pressed ?  "#959595" : rectangle.color
                }

                Image {
                    id: image3
                    antialiasing: true
                    anchors.rightMargin: 7
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 7
                    anchors.topMargin: 7
                    anchors.fill: parent
                    source: "qrc:/icon/update.png"
                }
            }
        }


    }

    TreeView {
        id: treeView
        width: parent.width/6
        anchors.left: rectangle.right
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        alternatingRowColors: false
        headerVisible: false
        selectionMode: SelectionMode.SingleSelection
        TableViewColumn {
            title: "Name"
            role: "display"

        }
    }

    TableElement {
        id: tableElement
        anchors.left: treeView.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.bottomMargin: 50
    }

    Rectangle {
        id: rectangle1
        color: "#ffffff"
        anchors.top: tableElement.bottom
        anchors.topMargin: 0
        anchors.left: treeView.right
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        
        Row {
            id: row
            anchors.rightMargin: 10
            spacing: 10
            layoutDirection: Qt.RightToLeft
            anchors.fill: parent
            
            Button {
                id: button6
                width: 40
                text: qsTr("")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5

                Image {
                    id: image4
                    antialiasing: true
                    anchors.rightMargin: 3
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.topMargin: 3
                    anchors.fill: parent
                    source: "qrc:/icon/remove.png"
                }
            }
            
            Button {
                id: button5
                width: 40
                text: qsTr("")
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5

                Image {
                    id: image5
                    antialiasing: true
                    anchors.rightMargin: 3
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.topMargin: 3
                    anchors.fill: parent
                    source: "qrc:/icon/edit.png"
                }
            }

            Button {
                id: button4
                width: 40
                text: qsTr("")
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5

                Image {
                    id: image6
                    antialiasing: true
                    anchors.rightMargin: 3
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.topMargin: 3
                    anchors.fill: parent
                    source: "qrc:/icon/add.png"
                }
            }
        }
    }









}
