#include "workdatabase.h"



WorkDatabase::WorkDatabase(QObject *parent) : QObject(parent)
{
    base = QSqlDatabase::addDatabase("QSQLITE");
    QString path = qApp->applicationDirPath() + "\\Database.db";
    list_Roles << "id" << "name" << "count" << "location" << "availability";
    base.setDatabaseName(path);
    if(base.open()) {
        query = new QSqlQuery();
        query->exec("create table if not exists main (id  INTEGER PRIMARY KEY, "
                                                      "name CHAR(50) NOT NULL,"
                                                      "type CHAR(10) NOT NULL);");
        list_TableModel = new QStandardItemModel(2, 1, this);

        list_TableModel->setHorizontalHeaderItem(0, new QStandardItem("myName"));
        QModelIndex index = list_TableModel->index(0, 0);
        list_TableModel->setData(index, "Элементы");
        query->exec("select name from main where type = \"element\";");
        list_TableModel->insertColumns(0, 1, index);
        for(int i = 0;  query->next(); i++) {
           list_TableModel->insertRow(i, index);
           list_TableModel->setData(list_TableModel->index(i, 0, index), query->record().value(0).toString());
        }

        index = list_TableModel->index(1, 0);
        list_TableModel->setData(index, "Проекты");
        query->exec("select name from main where type = \"project\";");
        list_TableModel->insertColumns(0, 1, index);
        for(int i = 0; query->next(); i++) {
            list_TableModel->insertRow(i, index);
            list_TableModel->setData(list_TableModel->index(i, 0, index), query->record().value(0).toString());
        }
    }
    TableModel = new MySQLTableModel(this);
}


void WorkDatabase::createTable(QString str) {
    if(str.isEmpty()) return;
    query->exec("create table if not exists\"" + str + "\" (id INTEGER PRIMARY KEY, "
                                                  "name CHAR(50) NOT NULL, "                                                  
                                                  "count INTEGER, "
                                                  "location CHAR(30) NOT NULL, "
                                                  "description CHAR(255), "
                                                  "url CHAR(255), "
                                                  "price CHAR, "
                                                  "availability CHAR);");
    query->exec("insert into main (name, type) values (\"" + str +  "\", \"element\");");
    updatelist_TableModel();
}

void WorkDatabase::createProject(QString str) {
    if(str.isEmpty()) return;
    query->exec("create table if not exists \"" + str + "\" (id INTEGER PRIMARY KEY, "
                                                  "name CHAR(50) NOT NULL,"
                                                  "count INTEGER NOT NULL, "
                                                  "url CHAR(255), "
                                                  "total CHAR, "
                                                  "availability CHAR);");
    query->exec("insert into main (name, type) values (\"" + str +  "\", \"project\");");
    updatelist_TableModel();
}

void WorkDatabase::updatelist_TableModel() {
    query->exec("create table if not exists main (id INTEGER PRIMARY KEY, "
                                                  "name CHAR(50) NOT NULL, "
                                                  "type CHAR(10) NOT NULL);");
    list_TableModel = new QStandardItemModel(2, 1, this);

    list_TableModel->setHorizontalHeaderItem(0, new QStandardItem("myName"));
    QModelIndex index = list_TableModel->index(0, 0);
    list_TableModel->setData(index, "Элементы");
    query->exec("select name from main where type = \"element\";");
    list_TableModel->insertColumns(0, 1, index);
    for(int i = 0;  query->next(); i++) {
       list_TableModel->insertRow(i, index);
       list_TableModel->setData(list_TableModel->index(i, 0, index), query->record().value(0).toString());
    }

    index = list_TableModel->index(1, 0);
    list_TableModel->setData(index, "Проекты");
    query->exec("select name from main where type = \"project\";");
    list_TableModel->insertColumns(0, 1, index);
    for(int i = 0; query->next(); i++) {
        list_TableModel->insertRow(i, index);
        list_TableModel->setData(list_TableModel->index(i, 0, index), query->record().value(0).toString());
    }
    emit list_TableModelChanged();
}

void WorkDatabase::deleteTableOrProject(QModelIndex index) {
    QString str = list_TableModel->data(index).toString();
    if(str.isEmpty()) return;
    query->exec("drop table \"" + str +"\";");
    query->exec("delete from main where name = \"" + str + "\";");
    updatelist_TableModel();
}


void WorkDatabase::updateListRoles(QModelIndex index) {
    delete TableModel;
    TableModel = new MySQLTableModel(this);
    QString name = list_TableModel->data(index).toString();
    if(name == "Проекты" || name == "Элементы") return;
    query->exec("select * from \"" + name + "\";");
    list_Roles.clear();
    for(int i = 0; i < query->record().count(); i++) {
        list_Roles.append(query->record().fieldName(i).toUtf8());
    }
    TableModel->setListRole(list_Roles);
}

void WorkDatabase::updateTableModel(QModelIndex index) {
    QString name = list_TableModel->data(index).toString();
    if(name == "Проекты" || name == "Элементы") return;
    TableModel->setTable(name);
    TableModel->select();   
    emit TableModelChanged();
}

QStringList WorkDatabase::getDataFromModel(uint row) {
    QStringList list;
    for(int i = 0; i < list_Roles.size(); i++) {
        QModelIndex index = TableModel->index(row, i);
        list.append(TableModel->data(index, Qt::UserRole+i+1).toString());
    }

    return list;
}

bool WorkDatabase::addElement(QStringList list) {
    if(TableModel->tableName() == 0) return false;
    if(list.size() < 7) return false;
    QString str = "insert into \"" + TableModel->tableName() + "\" "
                  "(name, count, location, description, url, price, availability) values ("
                    "'"+ list.at(1) + "', " + list.at(2) + ", '" + list.at(3) + "', "
                    "'" + list.at(4) + "', '" + list.at(5) + "', '" + list.at(6) + "', '"+ list.at(7) +"');";
    if(!query->exec(str))  {
        qDebug() << query->lastError().text();
        return false;
    }
    return true;
}



bool WorkDatabase::editElement(QStringList newList) {
    if(TableModel->tableName() == 0) return false;
    if(newList.size() < 7) return false;
    QString str = "update \"" + TableModel->tableName() + "\" set "
                  "name = \"" + newList.at(1) + "\", count = " + newList.at(2) + ", location = \"" + newList.at(3) + "\", "
                  "description = '" + newList.at(4) + "', url = '" + newList.at(5) + "', price = '" + newList.at(6) + "', "
                  "availability = '" + newList.at(7) + "' where id = " + newList.at(0) + ";";
    if(!query->exec(str)) {
        qDebug() << query->lastError().text();
        return false;
    }
    return true;
}

bool WorkDatabase::addProjectElement(QStringList list) {
    if(TableModel->tableName() == 0) return false;
     if(list.size() < 5) return false;
     QString str = "insert into \"" + TableModel->tableName() + "\" "
                   "(name, count, url, total, availability) values ("
                     "'"+ list.at(1) + "', '" + list.at(2) + "', '" + list.at(3) + "', "
                     "'" + list.at(4) + "', '" + list.at(5) + "');";
     if(!query->exec(str)) {
         qDebug() << query->lastError().text();
         return false;
     }
     return true;
}

bool WorkDatabase::editProjectElement(QStringList newList) {
    if(TableModel->tableName() == 0) return false;
    if(newList.size() < 5) return false;
    QString str = "update \"" + TableModel->tableName() + "\" set "
                  "name = \"" + newList.at(1) + "\", count = '" + newList.at(2) + "', "
                  "url = '" + newList.at(3) + "', total = '" + newList.at(4) + "', "
                  "availability = '" + newList.at(5) + "' where id = " + newList.at(0) + ";";
    if(!query->exec(str)) {
        qDebug() << query->lastError().text();
        return false;
    }
    return true;
}

bool WorkDatabase::removeElemnt(uint row) {
    QModelIndex index = TableModel->index(row, 2);
    QString name = TableModel->data(index, Qt::UserRole+2).toString();
    if(!query->exec("delete from \"" + TableModel->tableName() + "\" where name = \"" + name + "\";")) {
        qDebug() << query->lastError().text();
        return false;
    }
    return true;

}

void WorkDatabase::updatePriceElement() {

}


MySQLTableModel *WorkDatabase::getTableModel() {
    return TableModel;
}

void WorkDatabase::setTableModel(MySQLTableModel *model) {
    TableModel = model;
}

QStandardItemModel  *WorkDatabase::getlist_TableModel() {
    return list_TableModel;
}

void WorkDatabase::setlist_TableModel(QStandardItemModel  *model) {
    list_TableModel = model;
}


QStringList WorkDatabase::getlist_Roles() {
    return list_Roles;
}
