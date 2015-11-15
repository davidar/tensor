#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlFileSelector>
#include <QQuickView> //Not using QQmlApplicationEngine because many examples don't have a Window{}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc,argv);
    app.setOrganizationName("David A Roberts");
    app.setOrganizationDomain("davidar.io");
    app.setApplicationName("Tensor");
    QQuickView view;
    if(qgetenv("QT_QUICK_CORE_PROFILE").toInt()) {
        QSurfaceFormat f = view.format();
        f.setProfile(QSurfaceFormat::CoreProfile);
        f.setVersion(4, 4);
        view.setFormat(f);
    }
    view.connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    new QQmlFileSelector(view.engine(), &view);
    view.setSource(QUrl("qrc:///main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    if(QGuiApplication::platformName() == QLatin1String("qnx") ||
       QGuiApplication::platformName() == QLatin1String("eglfs")) {
        view.showFullScreen();
    } else {
        view.show();
    }
    return app.exec();
}
