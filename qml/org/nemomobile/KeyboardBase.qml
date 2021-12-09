/*
 * This file is part of Maliit plugins
 *
 * Copyright (C) 2017 Eetu Kahelin
 * Copyright (C) 2012-2013 Jolla Ltd.
 * Copyright (C) 2012 John Brooks <john.brooks@dereferenced.net>
 * Copyright (C) Jakub Pavelek <jpavelek@live.com>
 * Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
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
import QtQuick.Controls.Styles.Nemo 1.0
import com.meego.maliitquick 1.0
import org.nemomobile.configuration 1.0

import "touchpointarray.js" as ActivePoints
import "layouts.js"  as KLayouts


Item {
    id: keyboard

    property Item layout
    property bool portraitMode
    property string languageCode: "en"

    //property Item pressedKey
    property Item lastPressedKey
    property Item lastInitialKey

    property string deadKeyAccent
    property bool shiftKeyPressed
    // counts how many character keys have been pressed since the ActivePoints array was empty
    property int characterKeyCounter
    property bool closeSwipeActive
    property int closeSwipeThreshold: height*.3

    property variant row1: KLayouts.keyboards[lastKeyboardLayout.value]["row1"]
    property variant row2: KLayouts.keyboards[lastKeyboardLayout.value]["row2"]
    property variant row3: KLayouts.keyboards[lastKeyboardLayout.value]["row3"]
    property variant accents_row1: KLayouts.keyboards[lastKeyboardLayout.value]["accents_row1"]
    property variant accents_row2: KLayouts.keyboards[lastKeyboardLayout.value]["accents_row2"]
    property variant accents_row3: KLayouts.keyboards[lastKeyboardLayout.value]["accents_row3"]

    property var availableKeyboards: []

    height: layout ? layout.height : 0
    onPortraitModeChanged: cancelAllTouchPoints()
    onLayoutChanged: if (layout) layout.parent = keyboard
    // if height changed while touch point was being held
    // we can't rely on point values anymore
    onHeightChanged: closeSwipeActive = false

    ConfigurationValue {
        id: enabledKeyboardLayouts
        key: "/home/glacier/keyboard/enabledLayouts"
        defaultValue: "en"
        onValueChanged: {
            availableKeyboards = enabledKeyboardLayouts.value.split(";")
        }
    }

    ConfigurationValue {
        id: lastKeyboardLayout
        key: "/home/glacier/keyboard/lastKeyboard"
        defaultValue: "en"
        onValueChanged: keyboard.languageCode = lastKeyboardLayout.value
    }

    Component.onCompleted: {
        availableKeyboards = enabledKeyboardLayouts.value.split(";")
        if(availableKeyboards.length == 1) {
            lastKeyboardLayout.value = availableKeyboards[0]
        }
    }

    // Can be changed to PreeditTestHandler to have another mode of input
    InputHandler {
        id: inputHandler
    }

    Popper {
        id: popper
        z: 10
        target: lastPressedKey
    }
    Timer {
        id: pressTimer
        interval: 500
    }

    Rectangle {
        id: tracker
        width: Theme.itemWidthExtraSmall/2
        height: width
        radius: width
        border.width: width/12
        x:parent.width/2-tracker.width/2
        y:parent.height/2-tracker.height/2
        z: 100
        color: Theme.accentColor
        Drag.active: mouseArea.drag.active
        Timer {
            id: movetimer
            interval: 200
            repeat: true
            property int key
            onTriggered: {
                MInputMethodQuick.sendKey(key)
            }
        }

        MouseArea {
            id:mouseArea
            width: parent.width*1.5
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            property int _startlX: keyboard.width/2 - parent.width/2
            property int _startlY: keyboard.height/2 - parent.width/2
            property bool moved
            drag.target: tracker
            drag.axis: Drag.XAndYAxis
            drag {
                maximumX: _startlX+tracker.width
                minimumX: _startlX-tracker.width
                minimumY: _startlY-tracker.width
                maximumY: _startlY+tracker.width
            }
            drag.onActiveChanged: {
                if(!drag.active)
                {
                    movetimer.stop()
                    movetimer.key = -1
                }
            }
            onPositionChanged: {
                moved=true
                if(Math.abs(tracker.x - mouseArea._startlX)>=Math.abs(tracker.y - mouseArea._startlY)){
                    if (tracker.x < mouseArea._startlX) {
                        movetimer.key = Qt.Key_Left
                        movetimer.start()
                    }else if (tracker.x > mouseArea._startlX) {
                        movetimer.key = Qt.Key_Right
                        movetimer.start()
                    }
                }else if (tracker.y < mouseArea._startlY) {
                    movetimer.key = Qt.Key_Up
                    movetimer.start()
                }else if (tracker.y > mouseArea._startlY) {
                    movetimer.key = Qt.Key_Down
                    movetimer.start()
                }
            }
            onReleased: {
                if(!moved) {
                    keyboard.handlePressed(keyboard.createPointArray((tracker.x + mouse.x), tracker.y + mouse.y))
                    keyboard.handleReleased(keyboard.createPointArray((tracker.x + mouse.x), tracker.y + mouse.y))
                }
                moved=false
            }

            states: [
                State {
                    name: "default"
                    when: !mouseArea.drag.active
                }
            ]

            transitions: [
                Transition {
                    to: "default"
                    NumberAnimation {
                        target: tracker
                        properties: "x"
                        to: mouseArea._startlX
                        duration: 100
                    }
                    NumberAnimation {
                        target: tracker
                        properties: "y"
                        to: mouseArea._startlY
                        duration: 100
                    }
                }
            ]
        }
    }

    BorderImage {
        width: parent.width;
        height: parent.height
        border { left: 1; top: 4; right: 1; bottom:0 }
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat
        source: "vkb-body.png"
    }

    Connections {
        target: MInputMethodQuick
        function onCursorPositionChanged() {
            applyAutocaps()
        }

        function onInputMethodReset() {
            inputHandler._reset()
        }
    }


    MouseArea {
        enabled: false
        anchors.fill: parent

        onPressed: keyboard.handlePressed(keyboard.createPointArray(mouse.x, mouse.y))
        onPositionChanged: keyboard.handleUpdated(keyboard.createPointArray(mouse.x, mouse.y))
        onReleased: keyboard.handleReleased(keyboard.createPointArray(mouse.x, mouse.y))
        onCanceled: keyboard.cancelAllTouchPoints()
    }

    MultiPointTouchArea {
        anchors.fill: parent

        onPressed: keyboard.handlePressed(touchPoints)
        onUpdated: keyboard.handleUpdated(touchPoints)
        onReleased: keyboard.handleReleased(touchPoints)
        onCanceled: keyboard.handleCanceled(touchPoints)
    }

    function createPointArray(pointX, pointY) {
        var pointArray = new Array
        pointArray.push({"pointId": 1, "x": pointX, "y": pointY,
                            "startX": pointX, "startY": pointY })
        return pointArray
    }

    function handlePressed(touchPoints) {
        closeSwipeActive = true
        pressTimer.start()
        for (var i = 0; i < touchPoints.length; i++) {
            var point = ActivePoints.addPoint(touchPoints[i])
            updatePressedKey(point)
        }
    }

    function handleUpdated(touchPoints) {
        for (var i = 0; i < touchPoints.length; i++) {
            var incomingPoint = touchPoints[i]
            var point = ActivePoints.findById(incomingPoint.pointId)
            if (point === null)
                continue

            point.x = incomingPoint.x
            point.y = incomingPoint.y

            if (ActivePoints.array.length === 1
                    && closeSwipeActive
                    && pressTimer.running
                    && (point.y - point.startY > closeSwipeThreshold)) {
                // swiped down to close keyboard
                hideAnimation.running = true;
                MInputMethodQuick.userHide()
                if (point.pressedKey) {
                    inputHandler._handleKeyRelease()
                    point.pressedKey.pressed = false
                }
                lastPressedKey = null
                pressTimer.stop()
                ActivePoints.remove(point)
                return
            }

            updatePressedKey(point)
        }
    }

    function triggerKey(pressedKey) {

        if (pressedKey === null)
            return

        inputHandler._handleKeyClick(pressedKey)

        pressedKey.clicked()
        inputHandler._handleKeyRelease()

        pressedKey.pressed = false
        pressedKey = null
    }

    function handleReleased(touchPoints) {

        for (var i = 0; i < touchPoints.length; i++) {
            var point = ActivePoints.findById(touchPoints[i].pointId)
            if (point === null)
                continue

            if (point.pressedKey === null) {
                ActivePoints.remove(point)
                continue
            }


            triggerKey(point.pressedKey)


            if (point.pressedKey.key !== Qt.Key_Shift) {
                deadKeyAccent = ""
            }
            if (point.pressedKey === lastPressedKey) {
                lastPressedKey = null
            }

            ActivePoints.remove(point)
        }

        if (ActivePoints.array.length === 0) {
            characterKeyCounter = 0
        }
    }

    function isPressed(keyType) {
        return ActivePoints.findByKeyType(keyType) !== null
    }

    function handleCanceled(touchPoints) {
        for (var i = 0; i < touchPoints.length; i++) {
            cancelTouchPoint(touchPoints[i].pointId)
        }
    }

    function cancelTouchPoint(pointId) {
        var point = ActivePoints.findById(pointId)
        if (!point)
            return

        if (point.pressedKey) {
            inputHandler._handleKeyRelease()
            point.pressedKey.pressed = false
            if (lastPressedKey === point.pressedKey) {
                lastPressedKey = null
            }
        }
        if (lastInitialKey === point.initialKey) {
            lastInitialKey = null
        }

        ActivePoints.remove(point)
    }

    function cancelAllTouchPoints() {
        while (ActivePoints.array.length > 0) {
            cancelTouchPoint(ActivePoints.array[0].pointId)
        }
    }

    function updatePressedKey(point) {
        var key = keyAt(point.x, point.y)
        if (point.pressedKey === key)
            return

        if (point.pressedKey !== null) {
            inputHandler._handleKeyRelease()
            point.pressedKey.pressed = false
        }

        point.pressedKey = key
        if (!point.initialKey) {
            point.initialKey = point.pressedKey
            lastInitialKey = point.initialKey
        }

        lastPressedKey = point.pressedKey

        if (point.pressedKey !== null) {
            // when typing fast with two finger, one finger might be still pressed when the other hits screen.
            // on that case, trigger input from previous character
            releasePreviousCharacterKey(point)
            point.pressedKey.pressed = true
            inputHandler._handleKeyPress(point.pressedKey)
        }
    }

    function existingCharacterKey(ignoredPoint) {
        for (var i = 0; i < ActivePoints.array.length; i++) {
            var point = ActivePoints.array[i]
            if (point !== ignoredPoint
                    && point.pressedKey
                    && point.pressedKey.key === Qt.Key_Multi_key) {
                return point
            }
        }
    }

    function releasePreviousCharacterKey(ignoredPoint) {
        var existing = existingCharacterKey(ignoredPoint)
        if (existing) {
            triggerKey(existing.pressedKey)
            ActivePoints.remove(existing)
        }
    }

    function keyAt(x, y) {
        if (layout === null)
            return null

        var item = layout
        x -= layout.x
        y -= layout.y

        while ((item = item.childAt(x, y)) != null) {
            if (typeof item.text !== 'undefined' && typeof item.pressed !== 'undefined') {
                return item
            }

            // Cheaper mapToItem, assuming we're not using anything fancy.
            x -= item.x
            y -= item.y
        }

        return null
    }

    function resetKeyboard() {
        if (!layout)
            return
        cancelAllTouchPoints()
        layout.isShifted = false
        layout.isShiftLocked = false
        layout.inSymView = false
        layout.inSymView2 = false
        inputHandler._reset()
        lastPressedKey = null
        lastInitialKey = null
        deadKeyAccent = ""
    }

    function applyAutocaps() {
        if (MInputMethodQuick.surroundingTextValid
                && MInputMethodQuick.contentType === Maliit.FreeTextContentType
                && MInputMethodQuick.autoCapitalizationEnabled
                && !MInputMethodQuick.hiddenText
                && layout && layout.isShiftLocked === false) {
            var position = MInputMethodQuick.cursorPosition
            var text = MInputMethodQuick.surroundingText.substring(0, position)

            if (position == 0
                    || (position == 1 && text[0] === " ")
                    || (position >= 2 && text[position - 1] === " "
                        && ".?!".indexOf(text[position - 2]) >= 0)) {
                layout.isShifted = true
            } else {
                layout.isShifted = false
            }
        }
    }

    function changeCurrentKeyboard() {
        if(availableKeyboards.length == 1) {
            lastKeyboardLayout.value = availableKeyboards[0]
        }

        var currentLayoutID = availableKeyboards.indexOf(lastKeyboardLayout.value);

        if(currentLayoutID === availableKeyboards.length-1) {
            lastKeyboardLayout.value = availableKeyboards[0];
        } else {
            lastKeyboardLayout.value = availableKeyboards[currentLayoutID+1];
        }
    }
}
