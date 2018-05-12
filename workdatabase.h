#ifndef WORKDATABASE_H
#define WORKDATABASE_H

#include <QObject>
#include <QSqlTableModel>
#include <QStandardItemModel>
#include "mysqltablemodel.h"
#include <QtSql/QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QtQml>



class WorkDatabase : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStandardItemModel *list_TableModel READ getlist_TableModel WRITE setlist_TableModel NOTIFY list_TableModelChanged)
    Q_PROPERTY(MySQLTableModel *TableModel READ getTableModel WRITE setTableModel NOTIFY TableModelChanged)
    Q_PROPERTY(QStringList list_Roles READ getlist_Roles)

    QSqlDatabase base;
    QSqlQuery *query;

    QStandardItemModel *list_TableModel;
    MySQLTableModel *TableModel;

    QStringList list_Roles;
public:
    explicit WorkDatabase(QObject *parent = nullptr);

    QStandardItemModel *getlist_TableModel();
    void setlist_TableModel(QStandardItemModel *model);
    void updatelist_TableModel();

    MySQLTableModel *getTableModel();
    void setTableModel(MySQLTableModel *model);

    bool getisElemnt();
    QStringList getlist_Roles();


    Q_INVOKABLE void createTable(QString str);
    Q_INVOKABLE void createProject(QString str);
    Q_INVOKABLE void deleteTableOrProject(QModelIndex index);
    Q_INVOKABLE void updateTableModel(QModelIndex index);
    Q_INVOKABLE void updateListRoles(QModelIndex index);

    Q_INVOKABLE QStringList getDataFromModel(uint row);

    Q_INVOKABLE bool addElement(QStringList list);
    Q_INVOKABLE bool editElement(QStringList newList);

    Q_INVOKABLE bool addProjectElement(QStringList list);
    Q_INVOKABLE bool editProjectElement(QStringList newList);

     Q_INVOKABLE bool removeElemnt(uint row);

    Q_INVOKABLE void updatePriceElement();

signals:
     void list_TableModelChanged();
     void TableModelChanged();
     void list_RolesChanged();


public slots:
};

#endif // WORKDATABASE_H
