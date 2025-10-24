#include "fakekeyoverridequick.h"

FakeKeyOverrideQuick::FakeKeyOverrideQuick(QObject* parent)
    : QObject { parent }
{
}

QString FakeKeyOverrideQuick::label() const
{
    return m_label;
}

void FakeKeyOverrideQuick::setLabel(const QString &newLabel)
{
    if (m_label == newLabel)
        return;
    m_label = newLabel;
    emit labelChanged();
}

QString FakeKeyOverrideQuick::defaultLabel() const
{
    return m_defaultLabel;
}

void FakeKeyOverrideQuick::setDefaultLabel(const QString &newDefaultLabel)
{
    if (m_defaultLabel == newDefaultLabel)
        return;
    m_defaultLabel = newDefaultLabel;
    emit defaultLabelChanged();
}

QString FakeKeyOverrideQuick::defaultIcon() const
{
    return m_defaultIcon;
}

void FakeKeyOverrideQuick::setDefaultIcon(const QString &newDefaultIcon)
{
    if (m_defaultIcon == newDefaultIcon)
        return;
    m_defaultIcon = newDefaultIcon;
    emit defaultIconChanged();
}
