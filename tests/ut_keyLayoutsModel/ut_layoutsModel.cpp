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

#include "ut_layoutsModel.h"
#include <src/keyboardslayoutmodel.h>
#include <QtTest/QtTest>
#include <MDConfItem>

void ut_layoutsModel::init()
{
    MDConfItem enabledLayoutConfigItem("/tests/glacier/keyboard/enabledLayouts");
    MDConfItem lastKeyboardLayout("/tests/glacier/keyboard/lastKeyboard");
    enabledLayoutConfigItem.unset();
    lastKeyboardLayout.unset();
}

void ut_layoutsModel::enableKeyboardLayout()
{
    KeyboardsLayoutModel* keyboardModel = new KeyboardsLayoutModel(this);
    QCOMPARE(false, keyboardModel->isKeyboardLayoutEnabled("FF"));
    keyboardModel->setKeyboardLayoutEnabled("FF", true);
    QCOMPARE(true, keyboardModel->isKeyboardLayoutEnabled("FF"));
    keyboardModel->setKeyboardLayoutEnabled("XX", false);
    QCOMPARE(true, keyboardModel->isKeyboardLayoutEnabled("FF"));
    keyboardModel->setKeyboardLayoutEnabled("FF", false);
    QCOMPARE(false, keyboardModel->isKeyboardLayoutEnabled("FF"));
    delete keyboardModel;
}

void ut_layoutsModel::enabledKeyboards()
{
    KeyboardsLayoutModel* keyboardModel = new KeyboardsLayoutModel(this);
    QCOMPARE(1, keyboardModel->enabledKeyboards().count());
    delete keyboardModel;
}

void ut_layoutsModel::lastLeyboardLayout()
{
    KeyboardsLayoutModel* keyboardModel = new KeyboardsLayoutModel(this);
    QCOMPARE("en", keyboardModel->lastKeyboardLayout());
    keyboardModel->setLastKeyboardLayout("FF");
    QCOMPARE("en", keyboardModel->lastKeyboardLayout());
    keyboardModel->setKeyboardLayoutEnabled("FF", true);
    keyboardModel->setLastKeyboardLayout("FF");
    QCOMPARE("FF", keyboardModel->lastKeyboardLayout());
    keyboardModel->setKeyboardLayoutEnabled("FF", false);
    QCOMPARE("en", keyboardModel->lastKeyboardLayout());
    delete keyboardModel;
}

void ut_layoutsModel::cleanup()
{
    MDConfItem enabledLayoutConfigItem("/tests/glacier/keyboard/enabledLayouts");
    MDConfItem lastKeyboardLayout("/tests/glacier/keyboard/lastKeyboard");
    enabledLayoutConfigItem.unset();
    lastKeyboardLayout.unset();
}

QTEST_MAIN(ut_layoutsModel)
