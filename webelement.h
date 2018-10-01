#ifndef WEBELEMENT_H
#define WEBELEMENT_H

#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>

#include <QThread>
#include <QFile>
#include <QEventLoop>

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkConfigurationManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkCookieJar>
#include <QtNetwork/QNetworkCookie>

#include <QSettings>
#include <QDateTime>
#include <QStringListModel>

typedef struct {
    QString name;
    int count;
    int price;
    int total;
    int availability;
}ElementPA;

class WebElement : public QThread
{
    Q_OBJECT
    Q_PROPERTY(uint periodUpdate WRITE setPeriodUpdate READ getPeriodUpdate)
    Q_PROPERTY(QString currentShop READ getShop)
    Q_PROPERTY(QString currentTown READ getTown)
    Q_PROPERTY(uint currentTownIndex READ getTownIndex)

    Q_PROPERTY(QStringList shop_list READ getShopList NOTIFY ShopListChanged)
    Q_PROPERTY(QStringList town_list READ getTownList NOTIFY TownListChanged)

    QNetworkAccessManager *manager;
    QSettings setting;

    uint periodUpdate;

    QString currentShop;
    QString currentTown;
    QString currentId;

    QStringList shop_list;
    QStringList town_list;

    QSqlQuery *query;
    QHash <QString, QString> town_id;
    QStringList elementTable;
    QStringList projectTable;

    void fillTableChipDip();

    void SaveCurrentShop();
    void SaveCurrentTown();
    void SavePeriodUpdate();
    void SaveNowDataTime();



public:
    explicit WebElement(QObject *parent = nullptr);
    void run();


    uint getPeriodUpdate();
    QStringList getShopList();
    QStringList getTownList();

    Q_INVOKABLE void setShop(QString shop);
    Q_INVOKABLE void setTown(QString town);
    Q_INVOKABLE void setPeriodUpdate(uint p);

    QString getShop();
    QString getTown();
    uint getTownIndex();
    QString getId();

    void ChekUpdateTime();
    void SetListTableElement(QStringList list);
    void SetListTableProject(QStringList list);


    ElementPA getPriceAvailability(QString url);

    uint CalculatePrice(QString name);


signals:
    void ShopListChanged();
    void TownListChanged();


    void timeUpdate();
    void errorUpdate(QString str);
    void finishUpdate();

public slots:

};

#endif // WEBELEMENT_H
