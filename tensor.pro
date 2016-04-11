TEMPLATE = app

QT += qml quick
CONFIG += c++11

include(lib/package.pri)

HEADERS += \
    client/models/messageeventmodel.h \
    client/models/roomlistmodel.h

SOURCES += client/main.cpp \
    client/models/messageeventmodel.cpp \
    client/models/roomlistmodel.cpp

RESOURCES += client/resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
