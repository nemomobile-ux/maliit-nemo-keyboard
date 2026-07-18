/*
 * Copyright (C) 2025 Chupligin Sergey <neochapay@gmail.com>
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

#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QQuickWindow>

#include "fakeinputmethod.h"
#include "maliitquick.h"
#include <glacierapp.h>

int main(int argc, char* argv[])
{
    QGuiApplication* app = GlacierApp::app(argc, argv);
    QQmlEngine* engine = GlacierApp::engine();

    qmlRegisterUncreatableType<MaliitQuick>("com.meego.maliitquick", 1, 0, "Maliit", "This is the class used to export Maliit Enums");

    QQuickView view;
    view.engine()->rootContext()->setContextProperty("MInputMethodQuick", new FakeInputMethod());
    view.setSource(QString(SOURCE_DIR) + "qml/nemo-keyboard.qml");

    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    app->exec();
}
