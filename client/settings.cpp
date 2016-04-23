#include "settings.h"

Settings::Settings(QObject *parent)
    : QSettings(parent) {
}

Settings::~Settings() {
}

void Settings::setValue(const QString &key, const QVariant &value) {
    QSettings::setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return QSettings::value(key, defaultValue);
}
