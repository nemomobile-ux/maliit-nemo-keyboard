/*
 * This file is part of Maliit plugins
 *
 * Copyright (C) Jakub Pavelek <jpavelek@live.com>
 * Copyright (C) 2012 John Brooks <john.brooks@dereferenced.net>
 * Copyright (C) 2013 Jolla Ltd.
 * Copyright (C) 2022 Chupligin Sergey (NeoChapay) <neochapay@gmail.com>
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

import QtQuick 2.0

Column {
    id: keyArea

    width: parent.width
    height: parent.height

    property int topPadding: Theme.itemSpacingExtraSmall
    property int bottomPadding: topPadding
    property int leftPadding: Theme.itemSpacingExtraSmall/2
    property int rightPadding: leftPadding

    property bool isShifted
    property bool isShiftLocked
    property bool inSymView
    property bool inSymView2

    property string name: parent.name
    property variant row1: parent.row1
    property variant row2: parent.row2
    property variant row3: parent.row3
    property variant accents_row1: parent.accents_row1
    property variant accents_row2: parent.accents_row2
    property variant accents_row3: parent.accents_row3

    property var enabledKeyboards: parent.enabledKeyboards

    property int totalCharButtons: Math.max(row1.length, row2.length, row3.length)

    property int keyHeight: keyArea.height / 4
    property int keyWidth: (keyArea.width-leftPadding*(totalCharButtons+1))/totalCharButtons

    function changeCurrentKeyboard() {
        parent.changeCurrentKeyboard()
    }

    Row { //Row 1
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: row1
            PortraitCharacterKey {
                width: keyArea.width / totalCharButtons
                caption: row1[index][0]
                captionShifted: row1[index][0].toUpperCase()
                symView: row1[index][1]
                symView2: row1[index][2]
                accents: accents_row1[index]
            }
        }
    } //end Row1

    Row { //Row 2
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: row2
            PortraitCharacterKey {
                width: keyArea.width / totalCharButtons
                caption: row2[index][0]
                captionShifted: row2[index][0].toUpperCase()
                symView: row2[index][1]
                symView2: row2[index][2]
                accents: accents_row2[index]
            }
        }
    }

    Row { //Row 3
        anchors.horizontalCenter: parent.horizontalCenter
        ShiftKey {
            width: keyWidth
            height: keyHeight
            topPadding: keyArea.topPadding
        }

        Row {
            Repeater {
                model: row3
                PortraitCharacterKey {
                    width: keyArea.width / totalCharButtons
                    caption: row3[index][0]
                    captionShifted: row3[index][0].toUpperCase()
                    symView: row3[index][1]
                    symView2: row3[index][2]
                    accents: accents_row3[index]
                }
            }
        }

        BackspaceKey {
            width: keyWidth
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
        }
    }

    Row { //Row 4
        anchors.horizontalCenter: parent.horizontalCenter

        SymbolKey {
            id: symbolKey
            width: keyArea.width / 10
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
        }

        FunctionKey{
            id: switchKey
            width: keyArea.width / 10
            height: keyHeight
            icon: "image://theme/globe"
            onClicked: {
                keyArea.changeCurrentKeyboard();
            }
            visible: enabledKeyboards.length > 1
        }

        PortraitCharacterKey {
            id: commaPutton
            width: keyArea.width / 10
            caption: ","
            captionShifted: ","
        }

        PortraitCharacterKey {
            id: spaceKey
            width: (enabledKeyboards.length != 1) ? keyArea.width/2 : keyArea.width/2+(keyArea.width/10)
            caption: keyArea.name
            captionShifted: keyArea.name
            key: Qt.Key_Space
            showPopper: false
        }

        PortraitCharacterKey {
            id: dotKey
            width: keyArea.width / 10
            caption: "."
            captionShifted: "."
        }

        EnterKey {
            id: entKey
            width: keyArea.width / 10
            height: keyHeight
            topPadding: keyArea.topPadding
            leftPadding: keyArea.leftPadding
            rightPadding: keyArea.rightPadding
        }
    }
}
