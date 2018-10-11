#include "webelement.h"

WebElement::WebElement(QObject *parent) : QThread(parent)
{    
    query = new QSqlQuery();
    manager = new QNetworkAccessManager(this);
    shop_list << "Чип и Дип";
    currentShop = setting.value("shop/name").toString();
    if(currentShop.size() == 0) {       //создаем таблицы магазинов с данными
        fillTableChipDip();
        currentShop = shop_list.at(0);
        SaveCurrentShop();
    }
    if(currentShop == "Чип и Дип") {
        query->exec("select town, town_id from ChipDip_town_id;");
        for(int i = 0; query->next(); i++) {
            town_id[query->value(0).toString()] = query->value(1).toString();
        }
        town_list = town_id.keys();
        town_list.sort();
        currentTown = setting.value("shop/town").toString();
        if(currentTown.size() == 0) currentTown = town_list.at(0);
        currentId = town_id[currentTown];

    }
}

void WebElement::ChekUpdateTime() {
    uint LastTimeUpdate = setting.value("time").toUInt();
    periodUpdate = setting.value("PeriodUpdate").toUInt();
    if(QDateTime::currentSecsSinceEpoch() - LastTimeUpdate > periodUpdate) {
       emit timeUpdate();
    }
    periodUpdate = periodUpdate/86400;
}

void WebElement::SetListTableElement(QStringList list) {
    elementTable = list;
}

void WebElement::SetListTableProject(QStringList list) {
    projectTable = list;
}

void WebElement::SaveCurrentShop() {
    setting.setValue("shop/name", currentShop);
}

void WebElement::SaveCurrentTown() {
    setting.setValue("shop/town", currentTown);
}


void WebElement::SaveNowDataTime() {
    setting.setValue("time", QDateTime::currentSecsSinceEpoch());
}

void WebElement::setPeriodUpdate(uint period) {
    periodUpdate = period;
    setting.setValue("PeriodUpdate", period*86400);
}


void WebElement::run() {    
    ElementPA el;
    QSqlQuery write;
    for(int i = 0; i < elementTable.size(); i++) {
        query->exec("select name, url from \"" + elementTable.at(i) + "\";");
        for(int j = 0; query->next(); j++) {
            if(query->value(1).toString().size() > 0) {
                el = getPriceAvailability(query->value(1).toString());
                write.exec("update \"" + elementTable.at(i) + "\" set "
                           "price = '" + QString::number(el.price) + " руб.', "
                           "availability = '" + QString::number(el.availability) + " шт.' "
                           "where name = '" + query->value(0).toString() + "';");
            }
        }
    }
    for(int i = 0; i < projectTable.size(); i++) {
        query->exec("select name, count, url from \"" + projectTable.at(i) + "\";");
        for(int j = 0; query->next(); j++) {
            QString url = query->value(2).toString();
            QStringList count = query->value(1).toString().split("/");
            if(count.size() != 2) break;
            if(url.size() > 0) {                
                write.exec("select count, price, availability from \"" + url + "\" "
                           "where name = '" + query->value(0).toString() + "';");
                if(write.lastError().text().size() <=1) {
                    write.next();
                    QRegExp reg("\\d+");
                    int price = reg.indexIn(write.value("price").toString());
                    //price =.toInt();
                    price = write.value("price").toString().mid(price, reg.matchedLength()).toInt();
                    write.exec("update \"" + projectTable.at(i) + "\" set "
                              "count = '" + write.value("count").toString() + "/" + count.at(1) + "', "
                              "total = '" + QString::number(price  * count.at(1).toInt()) + " руб.', "
                              "availability = '" + write.value("availability").toString() + "' "
                              "where name = '" + query->value(0).toString() + "';");
                }
            }
        }
    }
    SaveNowDataTime();
    emit finishUpdate();
    this->exit(0);
}

uint WebElement::getPeriodUpdate() {
    return periodUpdate;
}

QStringList WebElement::getShopList() {
    return shop_list;
}

QStringList WebElement::getTownList() {
    return town_list;
}

void WebElement::setShop(QString shop) {
    currentShop = shop;
    SaveCurrentShop();
}

void WebElement::setTown(QString town) {
    if(currentShop == "Чип и Дип") {
         currentTown = town;
         SaveCurrentTown();
         currentId = town_id[currentTown];
    }

}

QString WebElement::getShop() {
    return currentShop;
}

QString WebElement::getTown() {
    return currentTown;
}

uint WebElement::getTownIndex() {
    return uint(town_list.indexOf(currentTown));
}

QString WebElement::getId() {
    return currentId;
}

ElementPA WebElement::getPriceAvailability(QString url) {
    QNetworkConfigurationManager managerConfig;


    ElementPA el;
    QNetworkRequest req;
    req.setSslConfiguration(QSslConfiguration::defaultConfiguration());

    QString str = "_ym_uid=15073811881024191894; rrpvid=904377671869671; rcuid=5a5e3ccb8a80240001d25f22; rrlpuid=; "
                  "SpecialPriceMode=off; _ym_isad=1; CQ=[0]; ChipDipVisitedItems=2bF1vsa13AnBCp1pqxWYB1sDP1xqgZSp0Cqi41vXiB; TownId="+currentId;

    manager->setCookieJar(new QNetworkCookieJar());
    req.setUrl(QUrl(url));
    req.setRawHeader("user-agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36 OPR/51.0.2830.55");
    req.setRawHeader("Cookie", str.toLocal8Bit());

    QNetworkReply *reply = manager->get(req);
    /*if(!managerConfig.isOnline()) {
        qDebug() << "Нет подключения к сети";
        //emit errorUpdate("offline");
        //this->exit();
        el.price = 0;
        el.availability = 0;
        return el;
    }*/
    QEventLoop loop;
    connect(manager, SIGNAL(finished(QNetworkReply*)), &loop, SLOT(quit()));
    loop.exec();

    QString html = reply->readAll();
    QString temp;

    QRegExp price("(ordering__value){1,1}(.){1,50}(\n){1,1}");
    int pos = price.indexIn(html);
    if(pos > 0){
        temp =  html.mid(pos, price.matchedLength());
        QRegExp number("(>)(\\d+)");
        pos = number.indexIn(temp);
        temp = temp.mid(pos+1, number.matchedLength()-1);
        el.price = temp.toInt();

    }
    else {
       qDebug() << "Цена не найдена";
       el.price = 0;
    }

    QRegExp presence("(product__status-delivery-row){1,1}(.){1,150}(\n){1,1}");
    int pos2 = presence.indexIn(html);
    if(pos2 > 0) {
        temp.clear();
        temp = html.mid(pos2, presence.matchedLength());
        QRegExp number2("(\\d+|нет)");
        pos2 = number2.indexIn(temp);
        temp = temp.mid(pos2, number2.matchedLength());
        if(temp == "нет") temp = "0";
        el.availability = temp.toInt();
    }
    else {
       qDebug() << "Наличие не найдено";
       el.availability = 0;
    }
    return el;
}

uint WebElement::CalculatePrice(QString name) {
    uint total = 0;
    query->exec("select total from \"" + name + "\";");
    for(;query->next();) {
        QString str = query->value(0).toString();
        total += str.mid(0, str.size()-5).toUInt();
    }
    return total;
}

void WebElement::fillTableChipDip() {
    if(!query->exec("create table ChipDip_town_id (id  INTEGER PRIMARY KEY, "
                                                "town CHAR(50) NOT NULL,"
                                                "town_id CHAR(50) NOT NULL);")) {
        qDebug() << query->lastError().text();
    }
    QStringList town;
    town << "Москва" << "Санкт-Петербург" << "Волгоград" << "Воронеж" << "Екатеринбург"  << "Казань" << "Калуга";
    town << "Краснодар" << "Красноярск" << "Минск" << "Нижний Новгород" << "Новосибирск"  << "Омск" << "Пермь";
    town << "Ростов-на-Дону" << "Рязань" << "Самара" << "Тверь" << "Тула"  << "Уфа" << "Челябинск";


    QStringList id;
    id << "7700000000" << "7800000000" << "3400000100" << "3600000100" << "6600000100" << "1600000100" << "4000000100";
    id << "2300000100" << "2400000100" << "5000000000" << "5200000100" << "5400000100" << "5500000100" << "5900000100";
    id << "6100000100" << "6200000100" << "6300000100" << "6900100100" << "7100000100" << "0200100100" << "7400000100";

    query->exec("BEGIN TRANSACTION;");
    for(int i = 0; i < town.size(); i++) {
        if(!query->exec("insert into ChipDip_town_id (town, town_id) values ('" + town.at(i)+ "', '" + id.at(i) + "');")) {
            qDebug() << query->lastError().text();
        }
    }
    query->exec("COMMIT;");
}
