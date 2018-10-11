#include "workdatabase.h"



WorkDatabase::WorkDatabase(QObject *parent) : QObject(parent)
{

    base = QSqlDatabase::addDatabase("QSQLITE");
    QString path = qApp->applicationDirPath() + "\\Database.db";
    list_Roles << "id" << "name" << "count" << "location" << "availability";
    base.setDatabaseName(path);
    SelectElementTableModel = new MySQLTableModel(this);

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
           list_ElementTableModel.append(query->record().value(0).toString());
        }

        if(list_ElementTableModel.size() > 0) {
            SelectElementTableModel->setTable(list_ElementTableModel.at(0));
            SelectElementTableModel->select();
            emit SelectElementTableModelChanged();
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
    else {

    }
    TableModel->setEditStrategy(QSqlTableModel::OnFieldChange);
    myWebElement = new WebElement(this);
    connect(myWebElement, SIGNAL(finishUpdate()), this, SIGNAL(finishUpdate()));
    connect(myWebElement, SIGNAL(errorUpdate(QString)), this, SIGNAL(errorUpdate(QString)));
    connect(myWebElement, SIGNAL(timeUpdate()), this, SIGNAL(timeUpdate()));
    //myWebElement->ChekUpdateTime();
}

void WorkDatabase::chekUpdateTime() {
   myWebElement->ChekUpdateTime();
}

WorkDatabase::~WorkDatabase() {
    //delete myWebElement;
}


void WorkDatabase::createTable(QString str) {
    if(str.isEmpty()) return;
    query->exec("create table if not exists\"" + str + "\" (id INTEGER PRIMARY KEY, "
                                                  "name CHAR(50) NOT NULL UNIQUE, "
                                                  "count INTEGER, "
                                                  "location CHAR(30) NOT NULL, "
                                                  "description CHAR(255), "
                                                  "url CHAR(255), "
                                                  "price CHAR, "
                                                  "availability CHAR);");
    query->exec("insert into main (name, type) values (\"" + str +  "\", \"element\");");
    list_ElementTableModel.append(str);
    emit list_ElementTableModelChanged();
    updatelist_TableModel();
}

void WorkDatabase::createProject(QString str) {
    if(str.isEmpty()) return;
    query->exec("create table if not exists \"" + str + "\" (id INTEGER PRIMARY KEY, "
                                                  "name CHAR(50) NOT NULL UNIQUE,"
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
    list_ElementTableModel.removeOne(str);
     emit list_ElementTableModelChanged();

}


void WorkDatabase::updateListRoles(QModelIndex index) {
    delete TableModel;
    TableModel = new MySQLTableModel(this);
    QString name = list_TableModel->data(index).toString();
    if(name == "Проекты" || name == "Элементы") {
        list_Roles.clear();
        return;
    }
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
    if(TableModel->tableName().size() == 0) return false;
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
    if(TableModel->tableName().size() == 0) return false;
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
    if(TableModel->tableName().size() == 0) return false;
    qDebug() << list;
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
    if(TableModel->tableName().size() == 0) return false;
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

bool WorkDatabase::removeElement(uint row) {
    QModelIndex index = TableModel->index(row, 2);
    QString name = TableModel->data(index, Qt::UserRole+2).toString();
    if(!query->exec("delete from \"" + TableModel->tableName() + "\" where name = \"" + name + "\";")) {
        qDebug() << query->lastError().text();
        return false;
    }
    return true;

}

void WorkDatabase::updatePriceAndAvailability() {
    QStringList list;

    query->exec("select name from main where type = \"element\";");
    for(int i = 0; query->next(); i++) {
      list.append(query->record().value(0).toString());
    }
    myWebElement->SetListTableElement(list);

    list.clear();

    query->exec("select name from main where type = \"project\";");
    for(int i = 0; query->next(); i++) {
      list.append(query->record().value(0).toString());
    }
    myWebElement->SetListTableProject(list);

    myWebElement->start();
}

void WorkDatabase::calculatePriceProject() {
    total = myWebElement->CalculatePrice(TableModel->tableName());
}

void WorkDatabase::activateProject() {
    for(int i = 0; i < TableModel->rowCount(); i++) { //проверка
        QModelIndex index = TableModel->index(i, 1);
        QString str = TableModel->data(index, Qt::UserRole+3).toString();
        QStringList list = str.split("/");
        if(list.size() == 2) {
            if(list.at(1).toUInt() > list.at(0).toUInt()) return;
        }
        else  return;

    }
    for(int i = 0; i < TableModel->rowCount(); i++) { //занесение в таблицу
        QModelIndex index = TableModel->index(i, 1);
        QString nameElement = TableModel->data(index, Qt::UserRole+2).toString();
        QString count = TableModel->data(index, Qt::UserRole+3).toString();
        QString nameTable = TableModel->data(index, Qt::UserRole+4).toString();
        QStringList list = count.split("/");
        QString str1 = "update \"" + TableModel->tableName() + "\" set count = '"+ QString::number(list.at(1).toUInt()) + "' where name = '" + nameElement + "';";
        //qDebug() << TableModel->setData(index, list.at(1), Qt::UserRole+3);
        query->exec(str1);
        qDebug() << query->lastError().text();
        QString str2 = "update \"" + nameTable + "\" set count = '"+ QString::number(list.at(0).toUInt() - list.at(1).toUInt()) + "' where name = '" + nameElement + "';";
        //qDebug() << str;
        query->exec(str2);
        qDebug() << query->lastError().text();
    }
    emit TableModelChanged();


}

void WorkDatabase::saveDtBs(QString path) {
    if(path.right(3) != ".db") {
        path += ".db";
    }
    QString oldpath = qApp->applicationDirPath() + "\\Database.db";
    path = path.mid(8);

    if(!QFile::copy(oldpath, path)) {
       qDebug() << "ошибка сохранения" << oldpath;
    }
}

void WorkDatabase::updateSelectedTableElementModel(int row) {
    //qDebug() << index.row();
    QString name = list_ElementTableModel.at(row);
    qDebug() << name;
    SelectElementTableModel->setTable(name);
    SelectElementTableModel->select();
    emit SelectElementTableModelChanged();
}

QString WorkDatabase::getName_SelectedTableElementModel(int row) {
    QModelIndex index = SelectElementTableModel->index(row, 1);
    return SelectElementTableModel->data(index, Qt::UserRole+2).toString();
}

uint WorkDatabase::getCount_SelectedTableElementModel(int row) {
    QModelIndex index = SelectElementTableModel->index(row, 1);
    return SelectElementTableModel->data(index, Qt::UserRole+3).toUInt();
}

uint WorkDatabase::getPrice_SelectedTableElementModel(int row) {
    QModelIndex index = SelectElementTableModel->index(row, 1);
    QString str = SelectElementTableModel->data(index, Qt::UserRole+7).toString();   
    return str.mid(0, str.size()-5).toUInt();
}

uint WorkDatabase::getAvailability_SelectedTableElementModel(int row) {
    QModelIndex index = SelectElementTableModel->index(row, 1);
    QString str =  SelectElementTableModel->data(index, Qt::UserRole+8).toString();
    return str.mid(0, str.size()-4).toUInt();
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

uint WorkDatabase::getTotal() {
    return total;
}

QStringList WorkDatabase::getlist_ElementTableModel() {
    return list_ElementTableModel;
}

MySQLTableModel *WorkDatabase::getSelectElementTableModel() {
    return SelectElementTableModel;
}

WebElement* WorkDatabase::getWebElement() {
    return myWebElement;
}

void WorkDatabase::setWebElement(WebElement *p) {
    myWebElement = p;
}

