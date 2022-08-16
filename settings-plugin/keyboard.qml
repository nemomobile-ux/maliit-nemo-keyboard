/*
 * Copyright (C) 2018 Chupligin Sergey <neochapay@gmail.com>
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
import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0
import org.nemomobile.configuration 1.0

import "file:///usr/share/maliit/plugins/org/nemomobile/layouts.js" as KeyboardLayouts

Page {
    id: keyboardSettingsPlugin

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Keyboard")
    }

    property var enabledKeyboardsLayouts: []

    ListModel{
        id: keyboardModel
    }

    ConfigurationValue {
        id: enabledKeyboardLayouts
        key: "/home/glacier/keyboard/enabledLayouts"
        defaultValue: "en"
    }

    ListView{
        id: keyboardList
        width: parent.width
        height: parent.height

        model: keyboardModel

        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingLarge
            left: parent.left
        }

        delegate: ListViewItemWithActions {
            selected: is_enabled
            label: local_name + " (" + name +")"
            showNext: false
            iconVisible: false
            onClicked: {
                is_enabled = !is_enabled
                updateKeyboards();
            }
        }

    }


    Component.onCompleted: {
        enabledKeyboardsLayouts = enabledKeyboardLayouts.value.split(";")

        for(var layout in KeyboardLayouts.keyboards) {
            keyboardModel.append({
                     "id" :  layout,
                     "name": KeyboardLayouts.keyboards[layout]["name"],
                     "local_name": KeyboardLayouts.keyboards[layout]["local_name"],
                     "is_enabled": (enabledKeyboardsLayouts.indexOf(layout) > -1) })
        }
    }
    function updateKeyboards() {
        var aKeyboard = "";
        for(var i = 0; i < keyboardModel.count; i++) {
            var kLayout = keyboardModel.get(i);
            if(kLayout.is_enabled) {
                aKeyboard += kLayout.id+";"
            }
        }
        //TODO: Do we allow disable all keyboards layout ?
        enabledKeyboardLayouts.value = aKeyboard.slice(0,-1)
    }
}
