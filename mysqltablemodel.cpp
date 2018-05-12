#include "mysqltablemodel.h"

MySQLTableModel::MySQLTableModel(QObject *parent) : QSqlTableModel(parent)
{

}

QVariant MySQLTableModel::data(const QModelIndex & index, int role) const {

    // Определяем номер колонки, адрес так сказать, по номеру роли
    int columnId = role - Qt::UserRole - 1;
    // Создаём индекс с помощью новоиспечённого ID колонки
    QModelIndex modelIndex = this->index(index.row(), columnId);

    /* И с помощью уже метода data() базового класса
     * вытаскиваем данные для таблицы из модели
     * */
    return QSqlTableModel::data(modelIndex, Qt::DisplayRole);
}

QHash<int, QByteArray> MySQLTableModel::roleNames() const {
     //То есть сохраняем в хеш-таблицу названия ролей
     // по их номеру
    QHash<int, QByteArray> roles;
    /*roles[Qt::DisplayRole] = "display";
    roles[idRole] = "id";
    roles[NameRole] = "name";
    roles[LocationRole] = "location";
    roles[CountRole] = "count";
    roles[MessageRole] = "message";
    roles[PriceRole] = "price";
    roles[TotalRole] = "total";
    roles[AvailabilityRole] = "availability";*/


    /*QSqlQuery myquery;
    myquery.exec("select * from \"" + this->tableName() + "\";");*/
    // record() returns an empty QSqlRecord


    for (int i = 0; i <record().count(); i ++) {
        //QString str = list_role.at(i);
        roles.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }


    return roles;
}

void MySQLTableModel::setListRole(QStringList list) {
    list_role = list;

}





