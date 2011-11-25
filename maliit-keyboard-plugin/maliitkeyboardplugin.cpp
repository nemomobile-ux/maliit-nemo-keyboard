/*
 * This file is part of Maliit Plugins
 *
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

#include "maliitkeyboardplugin.h"
#include "renderer/renderer.h"
#include "models/keyarea.h"

#include <mabstractinputmethod.h>

class MaliitKeyboardIm
    : public MAbstractInputMethod
{
public:
    explicit MaliitKeyboardIm(MAbstractInputMethodHost *host,
                              QWidget *mainWindow)
        : MAbstractInputMethod(host, mainWindow)
    {
        MaliitKeyboard::KeyArea ka;
        MaliitKeyboard::Renderer renderer;
        renderer.setWindow(mainWindow);
        renderer.show(ka);
    }
};

QString MaliitKeyboardPlugin::name() const
{
    return QString("Maliit Keyboard");
}

QStringList MaliitKeyboardPlugin::languages() const
{
    QStringList list;
    list.append("en");

    return list;
}

MAbstractInputMethod * MaliitKeyboardPlugin::createInputMethod(MAbstractInputMethodHost *host,
                                                               QWidget *mainWindow)
{
    return new MaliitKeyboardIm(host, mainWindow);
}

MAbstractInputMethodSettings * MaliitKeyboardPlugin::createInputMethodSettings()
{
    return 0;
}

QSet<MInputMethod::HandlerState> MInputMethodPlugin::supportedStates() const
{
    QSet<MInputMethod::HandlerState> set;
    set.insert(MInputMethod::OnScreen);

    return set;
}

Q_EXPORT_PLUGIN2(MaliitKeyboard, MaliitKeyboardPlugin)
