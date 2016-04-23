TEMPLATE = app

QT += qml quick
CONFIG += c++11

include(lib/libqmatrixclient.pri)

HEADERS += \
    client/models/messageeventmodel.h \
    client/models/roomlistmodel.h \
    client/settings.h

SOURCES += client/main.cpp \
    client/models/messageeventmodel.cpp \
    client/models/roomlistmodel.cpp \
    client/settings.cpp

RESOURCES += client/resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
