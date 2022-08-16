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

#ifndef KEYBOARDSETTINGSPLUGIN_H
#define KEYBOARDSETTINGSPLUGIN_H

#include "glaciersettingsplugin.h"

class KeyboardSettingsPlugin : public GlacierSettingsPlugin
{
    Q_OBJECT
    Q_INTERFACES(GlacierSettingsPlugin)
    Q_PLUGIN_METADATA(IID "Glacier.SettingsPlugin")
public:
    KeyboardSettingsPlugin(QObject *parent = nullptr);
    PluginCategory category() { return PluginCategory::Personalization; }
    QString id() { return "keyboard";}
    QString title() { return tr("Keyboard");}
    QString description() { return tr("Keyboard layout");}
    QString qmlPath() { return "/usr/share/glacier-settings/plugins/keyboard/keyboard.qml";}
    QString icon() { return "/usr/share/glacier-settings/plugins/keyboard/keyboard.svg";}
    bool enabled() { return true; };
};

#endif // KEYBOARDSETTINGSPLUGIN_H
