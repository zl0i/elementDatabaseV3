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


#include "webelement.h"

class WorkDatabase : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStandardItemModel *list_TableModel READ getlist_TableModel WRITE setlist_TableModel NOTIFY list_TableModelChanged)
    Q_PROPERTY(MySQLTableModel *TableModel READ getTableModel WRITE setTableModel NOTIFY TableModelChanged)
    Q_PROPERTY(QStringList list_Roles READ getlist_Roles)
    Q_PROPERTY(uint total READ getTotal)

    Q_PROPERTY(QStringList list_ElementTableModel READ getlist_ElementTableModel NOTIFY list_ElementTableModelChanged)
    Q_PROPERTY(MySQLTableModel *SelectElementTableModel READ getSelectElementTableModel NOTIFY SelectElementTableModelChanged)

    Q_PROPERTY(WebElement *myWebElement READ getWebElement WRITE setWebElement NOTIFY WebElementChanged)

    QSqlDatabase base;
    QSqlQuery *query;

    QStandardItemModel *list_TableModel;
    MySQLTableModel *TableModel = new MySQLTableModel();
    MySQLTableModel *SelectElementTableModel;

    QStringList list_Roles;
    QStringList list_ElementTableModel;

    uint total = 0;

    WebElement *myWebElement;

public:
    explicit WorkDatabase(QObject *parent = nullptr);
    ~WorkDatabase();

    QStandardItemModel *getlist_TableModel();
    void setlist_TableModel(QStandardItemModel *model);
    void updatelist_TableModel();

    MySQLTableModel *getTableModel();
    void setTableModel(MySQLTableModel *model);

    bool getisElemnt();
    QStringList getlist_Roles();

    uint getTotal();

    QStringList getlist_ElementTableModel();
    MySQLTableModel *getSelectElementTableModel();

    WebElement* getWebElement();
    void setWebElement(WebElement *p);

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

    Q_INVOKABLE bool removeElement(uint row);



    Q_INVOKABLE void updatePriceAndAvailability();

    Q_INVOKABLE void updateSelectedTableElementModel(int row);
    Q_INVOKABLE QString getName_SelectedTableElementModel(int row);
    Q_INVOKABLE uint getCount_SelectedTableElementModel(int row);
    Q_INVOKABLE uint getPrice_SelectedTableElementModel(int row);
    Q_INVOKABLE uint getAvailability_SelectedTableElementModel(int row);

    Q_INVOKABLE void calculatePriceProject();
    Q_INVOKABLE void activateProject();


signals:
     void list_TableModelChanged();
     void TableModelChanged();
     void list_RolesChanged();
     void list_ElementTableModelChanged();
     void SelectElementTableModelChanged();
     void WebElementChanged();

     void startUpdate();
     void finishUpdate();
     void errorUpdate(QString str);
     void timeUpdate();


public slots:
     void myslot();



};

#endif // WORKDATABASE_H
