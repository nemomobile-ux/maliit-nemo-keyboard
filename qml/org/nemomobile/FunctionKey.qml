/*
 * This file is part of Maliit nemo keyboard
 *
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
 * Copyright (C) 2022-2025 Chupligin Sergey (NeoChapay) <neochapay@gmail.com>
 *
 * Contact: Jakub Pavelek <jpavelek@live.com>
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
import QtQuick.Controls

import Nemo
import Nemo.Controls

KeyBase {
    id: aFunctKey

    property alias icon: functionImage.source
    property string caption
    property int sourceWidth: -1
    property int sourceHeight: -1
    property string imagesrc: bgimg.source

    topPadding: Theme.itemSpacingExtraSmall
    bottomPadding: topPadding
    leftPadding: Theme.itemSpacingExtraSmall/2
    rightPadding: leftPadding

    showPopper: false

    BorderImage {
        id: bgimg
        border {
            left: 1;
            top: 4;
            right: 1;
            bottom:0
        }

        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat
        source: parent.pressed ? "keyboard-key-portrait-function-pressed.png" : "keyboard-key-portrait-function.png"
        anchors {
            fill:parent
            topMargin: topPadding
            leftMargin: leftPadding
            rightMargin: rightPadding
            bottomMargin: bottomPadding
        }

        Image {
            id: functionImage
            anchors.centerIn: parent
            width: parent.width > parent.height ? parent.height*0.8 : parent.width*0.8
            height: width

            fillMode: Image.PreserveAspectFit

            anchors.horizontalCenterOffset: (leftPadding - rightPadding) / 2

            sourceSize.width: (sourceWidth == -1) ? width : sourceWidth
            sourceSize.height: (sourceHeight == -1) ? height : sourceHeight
        }
    }


    Text {
        id: text
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: Math.round((leftPadding - rightPadding) / 2)
        width: parent.width - leftPadding - rightPadding - 4
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        FontLoader {
            id: localFont
            source: Theme.fontPath
        }
        font.family: localFont.font.family
        font.styleName: localFont.font.styleName
        fontSizeMode: Text.HorizontalFit
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.textColor
        text: caption
    }
}
