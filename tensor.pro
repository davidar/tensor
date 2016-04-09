TEMPLATE = app

QT += qml quick network
CONFIG += c++11
INCLUDEPATH += lib lib/kcoreaddons/src/lib/jobs client/models

HEADERS += \
    lib/connectiondata.h \
    lib/connection.h \
    lib/connectionprivate.h \
    lib/room.h \
    lib/user.h \
    lib/logmessage.h \
    lib/state.h \
    lib/events/event.h \
    lib/events/roommessageevent.h \
    lib/events/roomnameevent.h \
    lib/events/roomaliasesevent.h \
    lib/events/roomcanonicalaliasevent.h \
    lib/events/roommemberevent.h \
    lib/events/roomtopicevent.h \
    lib/events/typingevent.h \
    lib/events/receiptevent.h \
    lib/events/unknownevent.h \
    lib/jobs/basejob.h \
    lib/jobs/checkauthmethods.h \
    lib/jobs/passwordlogin.h \
    lib/jobs/postmessagejob.h \
    lib/jobs/postreceiptjob.h \
    lib/jobs/joinroomjob.h \
    lib/jobs/leaveroomjob.h \
    lib/jobs/roommembersjob.h \
    lib/jobs/roommessagesjob.h \
    lib/jobs/syncjob.h \
    lib/jobs/mediathumbnailjob.h \
    lib/kcoreaddons/src/lib/jobs/kjob.h \
    lib/kcoreaddons/src/lib/jobs/kcompositejob.h \
    lib/kcoreaddons/src/lib/jobs/kjobtrackerinterface.h \
    lib/kcoreaddons/src/lib/jobs/kjobuidelegate.h \
    client/models/messageeventmodel.h \
    client/models/roomlistmodel.h

SOURCES += \
    lib/connectiondata.cpp \
    lib/connection.cpp \
    lib/connectionprivate.cpp \
    lib/room.cpp \
    lib/user.cpp \
    lib/logmessage.cpp \
    lib/state.cpp \
    lib/events/event.cpp \
    lib/events/roommessageevent.cpp \
    lib/events/roomnameevent.cpp \
    lib/events/roomaliasesevent.cpp \
    lib/events/roomcanonicalaliasevent.cpp \
    lib/events/roommemberevent.cpp \
    lib/events/roomtopicevent.cpp \
    lib/events/typingevent.cpp \
    lib/events/receiptevent.cpp \
    lib/events/unknownevent.cpp \
    lib/jobs/basejob.cpp \
    lib/jobs/checkauthmethods.cpp \
    lib/jobs/passwordlogin.cpp \
    lib/jobs/postmessagejob.cpp \
    lib/jobs/postreceiptjob.cpp \
    lib/jobs/joinroomjob.cpp \
    lib/jobs/leaveroomjob.cpp \
    lib/jobs/roommembersjob.cpp \
    lib/jobs/roommessagesjob.cpp \
    lib/jobs/syncjob.cpp \
    lib/jobs/mediathumbnailjob.cpp \
    lib/kcoreaddons/src/lib/jobs/kjob.cpp \
    lib/kcoreaddons/src/lib/jobs/kcompositejob.cpp \
    lib/kcoreaddons/src/lib/jobs/kjobtrackerinterface.cpp \
    lib/kcoreaddons/src/lib/jobs/kjobuidelegate.cpp \
    client/models/messageeventmodel.cpp \
    client/models/roomlistmodel.cpp \
    client/main.cpp

RESOURCES += client/resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
