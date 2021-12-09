/*
 * This file is part of Maliit plugins
 *
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
 * Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick 2.6
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile 1.0

import org.nemomobile.configuration 1.0
import org.nemomobile.predictor 1.0

Item {
    id: canvas

    width: MInputMethodQuick.screenWidth
    height: MInputMethodQuick.screenHeight
    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight

    property bool portraitRotated: width > height
    property bool portraitLayout: portraitRotated ?
                                      (MInputMethodQuick.appOrientation == 90 || MInputMethodQuick.appOrientation == 270) :
                                      (MInputMethodQuick.appOrientation == 0 || MInputMethodQuick.appOrientation == 180)

    function updateIMArea() {
        if (!MInputMethodQuick.active)
            return

        var x = 0, y = 0, width = 0, height = 0;
        var angle = MInputMethodQuick.appOrientation

        switch (angle) {
        case 0:
            y = MInputMethodQuick.screenHeight - vkb_landscape.height
        case 180:
            x = (MInputMethodQuick.screenWidth - vkb_landscape.width) / 2
            width = keyboard.width
            height = keyboard.height

            break;

        case 270:
            x = MInputMethodQuick.screenWidth - vkb_portrait.height
        case 90:
            y = (MInputMethodQuick.screenHeight - vkb_portrait.width) / 2
            width = keyboard.height
            height = keyboard.width
            break;
        }

        MInputMethodQuick.setInputMethodArea(Qt.rect(x, y, width, height))
        MInputMethodQuick.setScreenRegion(Qt.rect(x, y, width, height))
    }

    ConfigurationValue {
        id: enablePredictor
        key: "/home/glacier/keyboard/enablePredictor"
        defaultValue: true
    }

    PresagePredictor {
        id: predictor
        language: "en"

        property int shiftState: keyboard.isShifted ? (keyboard.isShiftLocked ? PresagePredictor.ShiftLocked
                                                                              : PresagePredictor.ShiftLatched)
                                                    : PresagePredictor.NoShift
        onShiftStateChanged: setShiftState(shiftState)

        function abort(word) {
            var oldPreedit = presageHandler.preedit
            presageHandler.commit(word)
            presageHandler.preedit = oldPreedit.substr(word.length, oldPreedit.length-word.length)
            if (presageHandler.preedit !== "") {
                MInputMethodQuick.sendPreedit(presageHandler.preedit)
            }
        }
    }

    Item {
        // container at the of current orientation. allows actual keyboard to show relative to that.
        id: root

        property bool landscape: MInputMethodQuick.appOrientation == 90 || MInputMethodQuick.appOrientation == 270

        width: landscape ? parent.height : parent.width
        height: 1
        transformOrigin: Item.TopLeft
        onRotationChanged: updateIMArea()
        rotation: MInputMethodQuick.appOrientation
        x: MInputMethodQuick.appOrientation == 180 || MInputMethodQuick.appOrientation == 270
           ? parent.width : 0
        y: MInputMethodQuick.appOrientation == 0 || MInputMethodQuick.appOrientation == 270
           ? parent.height : 0

        Rectangle{
            id: keyboardBack
            anchors.fill: keyboard
            color: Theme.backgroundColor
        }

        Rectangle{
            id: predictorView
            width: keyboard.width
            height: Theme.itemHeightLarge
            color: Theme.backgroundColor

            anchors.bottom: keyboard.top
            visible: enablePredictor.value

            ListView{
                id: predictionList
                anchors.fill: parent
                orientation: ListView.Horizontal
                model: predictor.engine
                delegate: Rectangle{
                    id: candidate
                    height: Theme.itemHeightLarge
                    width: candidateLabel.width + Theme.itemSpacingSmall*2
                    color: Theme.backgroundColor

                    Label{
                        id: candidateLabel
                        text: model.text
                        anchors.centerIn: parent
                    }
                }
            }

            Connections {
                target: predictor.engine
                onPredictionsChanged: {
                    predictionList.positionViewAtBeginning()
                }
            }

            Connections{
                target: MInputMethodQuick
                onEditorStateUpdate: {
                    var text = MInputMethodQuick.surroundingText.substring(0, MInputMethodQuick.cursorPosition)
                    predictor.setContext(text)
                }
            }
        }

        KeyboardBase {
            id: keyboard
            layout: root.landscape ? vkb_landscape : vkb_portrait
            width: root.landscape ? MInputMethodQuick.screenHeight : MInputMethodQuick.screenWidth
            height: root.landscape ? canvas.width/2 : canvas.height/3
            anchors.horizontalCenter: parent.horizontalCenter

            portraitMode: portraitLayout

            onHeightChanged: {
                if (MInputMethodQuick.active)
                    y = -height
            }

            KeyboardLandscape {
                id: vkb_landscape
                visible: keyboard.layout == vkb_landscape
            }

            KeyboardPortrait {
                id: vkb_portrait
                visible: keyboard.layout == vkb_portrait
            }

            Connections {
                target: MInputMethodQuick
                function onActiveChanged() {
                    if (MInputMethodQuick.active) {
                        hideAnimation.stop()
                        showAnimation.start()
                    } else {
                        showAnimation.stop()
                        hideAnimation.start()
                    }
                }
            }

            SequentialAnimation {
                id: hideAnimation

                ScriptAction {
                    script: MInputMethodQuick.setInputMethodArea(Qt.rect(0, 0, 0, 0))
                }

                NumberAnimation {
                    target: keyboard
                    property: "y"
                    to: 0
                    duration: 500
                    easing.type: Easing.InOutCubic
                }

                ScriptAction {
                    script: {
                        MInputMethodQuick.setScreenRegion(Qt.rect(0, 0, 0, 0))
                        keyboard.resetKeyboard();
                        MInputMethodQuick.userHide();
                    }
                }
            }

            SequentialAnimation {
                id: showAnimation

                ScriptAction {
                    script: {
                        canvas.visible = true // framework currently initially hides. Make sure visible
                        updateIMArea()
                    }
                }

                NumberAnimation {
                    target: keyboard
                    property: "y"
                    to: -keyboard.height
                    duration: 500
                    easing.type: Easing.InOutCubic
                }
            }
        }

        Component.onCompleted: {
            MInputMethodQuick.actionKeyOverride.setDefaultIcon("icon-m-input-methods-enter.svg")
            MInputMethodQuick.actionKeyOverride.setDefaultLabel("")
        }
    }
}

