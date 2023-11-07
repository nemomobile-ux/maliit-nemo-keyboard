/*
 * This file is part of Maliit Plugins
 * Copyright (C) 2022-2023 Chupligin Sergey (NeoChapay) <neochapay@gmail.com>
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
 *
 * Contact: Mohammad Anwari <Mohammad.Anwari@nokia.com>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Nokia Corporation nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

import QtQuick

Column {
    id: keyArea

    width: parent.width
    height: parent.height

    property bool isShifted
    property bool isShiftLocked
    property bool inSymView
    property bool inSymView2

    property variant keyboardLayout: keyboard.keyboardLayout
    property var enabledKeyboards: keyboard.enabledKeyboards

    topPadding: Theme.itemSpacingExtraSmall
    bottomPadding: topPadding
    leftPadding: Theme.itemSpacingExtraSmall/2
    rightPadding: leftPadding

    property int keyHeight: keyArea.height / 4

    property int totalCharButtons: Math.max(keyboardLayout["row1"].length, keyboardLayout["row2"].length, keyboardLayout["row3"].length)
    property int keyWidth: (keyArea.width-leftPadding*(totalCharButtons+1))/totalCharButtons

    function changeCurrentKeyboard() {
        keyboard.changeCurrentKeyboard()
    }

    Row { //Row 1
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: keyboardLayout["row1"]
            LandscapeCharacterKey {
                caption: keyboardLayout["row1"][index][0]
                captionShifted: keyboardLayout["row1"][index][0].toUpperCase()
                symView: keyboardLayout["row1"][index][1]
                symView2: keyboardLayout["row1"][index][2]
                accents: keyboardLayout["accents_row1"][index]
            }
        }
    } //end Row1

    Row { //Row 2
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: keyboardLayout["row2"]
            LandscapeCharacterKey {
                caption: keyboardLayout["row2"][index][0]
                captionShifted: keyboardLayout["row2"][index][0].toUpperCase()
                symView: keyboardLayout["row2"][index][1]
                symView2: keyboardLayout["row2"][index][2]
                accents: keyboardLayout["accents_row2"][index]
            }
        }
    } //end Row2

    Row { //Row 3
        anchors.horizontalCenter: parent.horizontalCenter

        ShiftKey {
            width: keyArea.width / 8
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
            bottomPadding: keyArea.bottomPadding
            landscape: true
        }

        Repeater {
            model: keyboardLayout["row3"]
            LandscapeCharacterKey {
                caption: keyboardLayout["row3"][index][0]
                captionShifted: keyboardLayout["row3"][index][0].toUpperCase()
                symView: keyboardLayout["row3"][index][1]
                symView2: keyboardLayout["row3"][index][2]
                accents: keyboardLayout["accents_row3"][index]
            }
        }

        BackspaceKey {
            width: keyArea.width / 8
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
            bottomPadding: keyArea.bottomPadding
            landscape: true
        }
    } //end Row3

    Row { //Row 4
        anchors.horizontalCenter: parent.horizontalCenter

        SymbolKey {
            width: keyArea.width / 8
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
            bottomPadding: keyArea.bottomPadding
        }

        FunctionKey{
            id: switchKey
            width: keyArea.width / 10
            height: keyHeight
            icon: "image://theme/globe"
            onClicked: {
                keyArea.changeCurrentKeyboard();
            }
            visible: enabledKeyboards.lenght > 1
        }


        LandscapeCharacterKey {
            width: keyArea.width / 10
            caption: ","
            captionShifted: ","
        }
        LandscapeCharacterKey {
            width: (enabledKeyboards.length > 1) ? keyArea.width/2 : keyArea.width/2+(keyArea.width/10)
            caption: keyboardLayout["local_name"]
            captionShifted: keyboardLayout["local_name"]
            key: Qt.Key_Space
            showPopper: false
        }
        LandscapeCharacterKey {
            width: keyArea.width / 10
            caption: "."
            captionShifted: "."
        }

        EnterKeyItem {
            id: entKey
            width: keyArea.width / 8
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
        }

    } //end Row4
}

