#ifndef MYSQLTABLEMODEL_H
#define MYSQLTABLEMODEL_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlTableModel>
#include <QSqlError>
#include <QStringList>


class MySQLTableModel : public QSqlTableModel
{
    Q_OBJECT
    QStringList list_role;

public:
    explicit MySQLTableModel(QObject *parent = nullptr);
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    void setListRole(QStringList list);

protected:
      QHash<int, QByteArray> roleNames() const;

signals:

public slots:
};

#endif // MYSQLTABLEMODEL_H
