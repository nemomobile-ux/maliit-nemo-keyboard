/*
 * This file is part of Maliit plugins
 * Copyright (C) 2022-2023 Chupligin Sergey (NeoChapay) <neochapay@gmail.com>
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
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

KeyBase  {
    id: aCharKey

    property string caption
    property string captionShifted
    property string symView
    property string symView2
    property string accents
    property alias text: key_label.text
    key: Qt.Key_Multi_key


    Rectangle {
        color: parent.pressed ? Theme.fillDarkColor : Theme.fillColor
        anchors.fill: parent
        anchors.leftMargin: leftPadding
        anchors.rightMargin: rightPadding
        anchors.topMargin: topPadding
        anchors.bottomMargin: bottomPadding
    }

    Text {
        id: key_label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        FontLoader {
            id: localFont
            source: Theme.fontPath
        }
        font.family: localFont.font.family
        font.styleName: localFont.font.styleName
        font.pixelSize: aCharKey.height*0.5
        font.bold: true
        color:Theme.textColor
        text: (inSymView && symView.length) > 0 ? (inSymView2 ? symView2 : symView)
                                                : (isShifted ? captionShifted : caption)
    }

    Connections{
        target: MInputMethodQuick
        function onActiveChanged() {
            showMore.visible = false
        }
    }

    function showMeMore() {
        if(accents != "") {
            showMore.visible = true
        }
    }

    onAccentsChanged: {
        for(var i=0; i < accents.length; i++) {
            accentsListModel.append({ "keyData" : accents[i] })
        }
    }

    Rectangle {
        id: showMore
        height: aCharKey.height
        width: aCharKey.height * accents.length
        color: Theme.accentColor
        visible: false

        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.top
        }

        onVisibleChanged: {
            if(x < 0) {
                x = 0
            }
        }

        InverseMouseArea{
            id: closeShowMore
            anchors.fill: parent
            onPressed: showMore.visible = false
        }

        ListModel{
            id: accentsListModel
        }

        Row {
            Repeater{
                model: accentsListModel
                delegate: Text{
                    width: aCharKey.height
                    height: aCharKey.height
                    text: keyData
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    FontLoader {
                        id: accentsListModelLocalFont
                        source: Theme.fontPath
                    }
                    font.family: accentsListModelLocalFont.font.family
                    font.styleName: accentsListModelLocalFont.font.styleName
                    font.pixelSize: aCharKey.height*0.5
                    font.bold: true
                    color:Theme.textColor
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            MInputMethodQuick.sendCommit(keyData)
                            showMore.visible = false
                        }
                    }
                }
            }
        }
    }
}

