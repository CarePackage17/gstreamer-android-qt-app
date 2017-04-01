#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <gst/gst.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    guint major, minor, micro, nano;
    gst_version(&major, &minor, &micro, &nano);
    qDebug() << "GStreamer version: " << major << "." << minor << "." << micro << "." << nano;

    return app.exec();
}
