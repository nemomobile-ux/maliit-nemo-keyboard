/*
 * Copyright (C) 2022 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "keyboardslayoutmodel.h"
#include "qjsondocument.h"

#include <QDebug>
#include <QDirIterator>
#include <QJsonDocument>
#include <QJsonObject>

KeyboardsLayoutModel::KeyboardsLayoutModel(QObject* parent)
    : m_enabledLayoutConfigItem("/home/glacier/keyboard/enabledLayouts")
    , m_lastKeyboardLayout("/home/glacier/keyboard/lastKeyboard")
    , m_contentType(0)
{
    QDirIterator it(m_layoutsDir, QStringList() << "*.json", QDir::Files);
    while (it.hasNext()) {
        m_layoutsFiles << it.next();
    }

    m_hash.insert(Qt::UserRole, QByteArray("code"));
    m_hash.insert(Qt::UserRole + 1, QByteArray("name"));
    m_hash.insert(Qt::UserRole + 2, QByteArray("local_name"));
    m_hash.insert(Qt::UserRole + 3, QByteArray("row1"));
    m_hash.insert(Qt::UserRole + 4, QByteArray("row2"));
    m_hash.insert(Qt::UserRole + 5, QByteArray("row3"));
    m_hash.insert(Qt::UserRole + 6, QByteArray("accents_row1"));
    m_hash.insert(Qt::UserRole + 7, QByteArray("accents_row2"));
    m_hash.insert(Qt::UserRole + 8, QByteArray("accents_row3"));
    m_hash.insert(Qt::UserRole + 9, QByteArray("is_enabled"));

    if (!m_enabledLayoutConfigItem.value().isValid()) {
        m_enabledLayoutConfigItem.set("en");
        m_enabledLayoutConfigItem.sync();
    }

    if (!m_lastKeyboardLayout.value().isValid() || m_lastKeyboardLayout.value().toString().isEmpty()) {
        m_lastKeyboardLayout.set("en");
        m_lastKeyboardLayout.sync();
    }
}

int KeyboardsLayoutModel::rowCount(const QModelIndex& parent) const
{
    return m_layoutsFiles.count();
}

QVariant KeyboardsLayoutModel::data(const QModelIndex& index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid()) {
        return QVariant();
    }

    QFile file(m_layoutsFiles.at(index.row()));
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString val = file.readAll();

    if (index.row() >= m_layoutsFiles.size()) {
        return QVariant();
    }

    qDebug() << QJsonDocument::fromJson(val.toUtf8()).object().value("name").toString();

    QJsonObject layout = getContentTypeLayout(val.toUtf8());

    if (role == Qt::UserRole) {
        return QJsonDocument::fromJson(val.toUtf8()).object().value("code").toString();
    } else if (role == Qt::UserRole + 1) {
        return QJsonDocument::fromJson(val.toUtf8()).object().value("name").toString();
    } else if (role == Qt::UserRole + 2) {
        return QJsonDocument::fromJson(val.toUtf8()).object().value("local_name").toString();
    } else if (role == Qt::UserRole + 3) {
        return layout.value("row1").toString();
    } else if (role == Qt::UserRole + 4) {
        return layout.value("row2").toString();
    } else if (role == Qt::UserRole + 5) {
        return layout.value("row3").toString();
    } else if (role == Qt::UserRole + 6) {
        return layout.value("accents_row1").toString();
    } else if (role == Qt::UserRole + 7) {
        return layout.value("accents_row2").toString();
    } else if (role == Qt::UserRole + 8) {
        return layout.value("accents_row3").toString();
    } else if (role == Qt::UserRole + 9) {
        return this->isKeyboardLayoutEnabled(layout.value("code").toString());
    }

    return QVariant();
}

bool KeyboardsLayoutModel::isKeyboardLayoutEnabled(QString code) const
{
    return m_enabledLayoutConfigItem.value().toString().split(";").contains(code);
}

void KeyboardsLayoutModel::setKeyboardLayoutEnabled(QString code, bool enabled)
{
    if (isKeyboardLayoutEnabled(code) != enabled) {
        beginResetModel();
        QStringList enabledLayouts = m_enabledLayoutConfigItem.value().toString().split(";", Qt::SkipEmptyParts);
        if (enabled) {
            enabledLayouts.push_back(code);
        } else {
            enabledLayouts.removeAt(enabledLayouts.lastIndexOf(code));
        }
        m_enabledLayoutConfigItem.set(enabledLayouts.join(";"));
        endResetModel();
        emit enabledKeyboardsChanged();
    }
}

QStringList KeyboardsLayoutModel::enabledKeyboards()
{
    return m_enabledLayoutConfigItem.value().toString().split(";", Qt::SkipEmptyParts);
}

QString KeyboardsLayoutModel::lastKeyboardLayout()
{
    return m_lastKeyboardLayout.value().toString();
}

void KeyboardsLayoutModel::setLastKeyboardLayout(QString code)
{
    if (isKeyboardLayoutEnabled(code) && !code.isEmpty()) {
        m_lastKeyboardLayout.set(code);
        m_lastKeyboardLayout.sync();
        emit lastKeyboardLayoutChanged();
    }
}

void KeyboardsLayoutModel::setContentType(int type)
{
    if (m_contentType == type) {
        return;
    }

    m_contentType = type;
    beginResetModel();
    emit contentTypeChanged();
    endResetModel();
}

QJsonObject KeyboardsLayoutModel::getContentTypeLayout(QString jsonString) const
{
    QJsonObject keyboardlayout;
    QString layoutObject = "base";
    if (m_contentType == 3) {
        layoutObject = "email";
    }

    if (m_contentType == 4) {
        layoutObject = "url";
    }

    keyboardlayout = QJsonDocument::fromJson(jsonString.toUtf8()).object().value(layoutObject).toObject();
    if (keyboardlayout.isEmpty()) {
        qWarning() << "layout" << layoutObject << "is empty. Use base layout";
        keyboardlayout = QJsonDocument::fromJson(jsonString.toUtf8()).object().value("base").toObject();
    }
    keyboardlayout.insert("code", QJsonDocument::fromJson(jsonString.toUtf8()).object().value("code"));
    keyboardlayout.insert("name", QJsonDocument::fromJson(jsonString.toUtf8()).object().value("name"));
    keyboardlayout.insert("local_name", QJsonDocument::fromJson(jsonString.toUtf8()).object().value("local_name"));

    return keyboardlayout;
}

QJsonObject KeyboardsLayoutModel::getKeyboardByCode(QString code)
{
    QJsonObject keyboard;
    QFile keyboardLayoutFile(m_layoutsDir + "/" + code + ".json");
    if (keyboardLayoutFile.exists()) {
        keyboardLayoutFile.open(QIODevice::ReadOnly | QIODevice::Text);
        QString layout = keyboardLayoutFile.readAll();
        keyboard = getContentTypeLayout(layout);
    }

    return keyboard;
}
