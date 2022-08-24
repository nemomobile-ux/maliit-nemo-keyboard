/*
 * This file is part of Glacier Keyboards
 *
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

    property int totalCharButtons: 4

    property int keyHeight: keyArea.height / 4
    property int keyWidth: (keyArea.width-leftPadding*(totalCharButtons+1))/totalCharButtons

    Row { //Row 1
        anchors.horizontalCenter: parent.horizontalCenter
        DigitKey {
            caption: "1"
        }
        DigitKey {
            caption: "2"
        }
        DigitKey {
            caption: "3"
        }
        DigitKey {
            caption: "-"
        }
    } //end Row1

    Row { //Row 2
        anchors.horizontalCenter: parent.horizontalCenter
        DigitKey {
            caption: "4"
        }
        DigitKey {
            caption: "5"
        }
        DigitKey {
            caption: "6"
        }
        DigitKey {
            caption: "."
        }
    }

    Row { //Row 3
        anchors.horizontalCenter: parent.horizontalCenter

        DigitKey {
            caption: "7"
        }
        DigitKey {
            caption: "8"
        }
        DigitKey {
            caption: "9"
        }
        BackspaceKey {
            width: keyArea.width / 4
            height: keyArea.height / 4
        }
    }

    Row { //Row 4
        anchors.horizontalCenter: parent.horizontalCenter

        DigitKey {
        }
        DigitKey {
            caption: "0"
        }
        DigitKey {
        }
        EnterKey {
            id: entKey
            width: keyArea.width / 4
            height: keyArea.height / 4
        }
    }
}
