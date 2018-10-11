#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "workdatabase.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("zloi");
    QCoreApplication::setApplicationName("elementDatabaseV3");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);    

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/icon/ElementDatabaseV3.png"));
    qmlRegisterType<WorkDatabase>("WorkDatabase", 1, 0, "WorkDatabase");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
