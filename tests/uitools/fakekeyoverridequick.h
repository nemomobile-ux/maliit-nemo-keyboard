#ifndef FAKEKEYOVERRIDEQUICK_H
#define FAKEKEYOVERRIDEQUICK_H

#include <QObject>

class FakeKeyOverrideQuick : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY labelChanged FINAL)

    Q_PROPERTY(QString defaultLabel READ defaultLabel WRITE setDefaultLabel NOTIFY defaultLabelChanged)
    Q_PROPERTY(QString defaultIcon READ defaultIcon WRITE setDefaultIcon NOTIFY defaultIconChanged)

public:
    explicit FakeKeyOverrideQuick(QObject* parent = nullptr);

    QString label() const;
    QString defaultLabel() const;
    QString defaultIcon() const;

public slots:
    void setLabel(const QString& newLabel);
    void setDefaultLabel(const QString& newDefaultLabel);
    void setDefaultIcon(const QString& newDefaultIcon);

signals:
    void labelChanged();
    void defaultLabelChanged();

    void defaultIconChanged();

private:
    QString m_label;
    QString m_defaultLabel;
    QString m_defaultIcon;
};

#endif // FAKEKEYOVERRIDEQUICK_H
