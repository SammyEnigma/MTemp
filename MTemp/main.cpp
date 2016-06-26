#include <QtQml>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "MClient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setApplicationName("MTemp");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("Unikore");
    app.setOrganizationDomain("www.unikore.it");

    qmlRegisterType<MClient>("mclient.testing", 1, 0, "MClient");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
