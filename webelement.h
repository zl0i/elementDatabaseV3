#ifndef WEBELEMENT_H
#define WEBELEMENT_H

#include <QObject>

class WebElement : public QObject
{
    Q_OBJECT
public:
    explicit WebElement(QObject *parent = nullptr);

signals:

public slots:
};

#endif // WEBELEMENT_H