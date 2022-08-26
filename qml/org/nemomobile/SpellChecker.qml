/*
 * This file is part of Glacier keyboard
 *
 * Copyright (C) 2022 Chupligin Sergey <neochapay@gmail.com>
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
import QtQuick.Controls.Styles.Nemo 1.0
import com.meego.maliitquick 1.0

import org.glacier.keyboard 1.0

Item{
    id: spellChecker
    visible: MInputMethodQuick.active && predictionList.count > 0

    property alias language: predictorModel.language
    property alias limit: predictorModel.limit

    property int candidateSpaceIndex: -1

    PredictorModel{
        id: predictorModel
    }

    Rectangle{
        id: spellCheckerBack
        anchors.fill: parent
        color: Theme.backgroundColor
    }

    ListView {
        id: predictionList
        anchors.fill: parent

        model: predictorModel
        orientation: ListView.Horizontal

        delegate: Item{
            id: predictorTextItem
            height: spellChecker.height
            width: predictionList.width/spellChecker.limit

            Text{
                id: candidateText

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                anchors.centerIn: parent

                font.family: Theme.fontFamily
                font.pixelSize: spellChecker.height*0.5
                font.bold: true
                color:Theme.textColor
                text: formatText(predictionText)
            }

            MouseArea{
                anchors.fill: parent
                onClicked: applyPrediction(model.predictionText, model.index)
            }
        }
    }

    function formatText(text) {
        if (text === undefined) {
            return ""
        }
        var preeditLength = predictorModel.checkingWord.length
        if (text.substr(0, preeditLength) === predictorModel.checkingWord) {
            return "<font color=\"" + Theme.accentColor + "\">" + predictorModel.checkingWord + "</font>"
                    + text.substr(preeditLength)
        } else {
            return text
        }
    }

    function applyPrediction(replacement, index) {
        console.log("candidate clicked: " + replacement + "\n")
        replacement = replacement + " "
        candidateSpaceIndex = MInputMethodQuick.surroundingTextValid
                ? MInputMethodQuick.cursorPosition + replacement.length : -1
        commit(replacement)
        thread.acceptPrediction(index)
    }

    function commit(text) {
        MInputMethodQuick.sendCommit(text)
        predictorModel.check("")
    }

    function check(word) {
        predictorModel.check(word)
    }
}
