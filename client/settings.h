#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QSettings
{
    Q_OBJECT
public:
    Settings(QObject *parent = NULL);
    virtual ~Settings();

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
};

#endif // SETTINGS_H
