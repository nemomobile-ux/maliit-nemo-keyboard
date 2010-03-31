/* * This file is part of dui-keyboard *
 *
 * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
 * All rights reserved.
 * Contact: Nokia Corporation (directui@nokia.com)
 *
 * If you have questions regarding the use of this file, please contact
 * Nokia at directui@nokia.com.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License version 2.1 as published by the Free Software Foundation
 * and appearing in the file LICENSE.LGPL included in the packaging
 * of this file.
 */



#include "layoutmenu.h"
#include "duivirtualkeyboardstyle.h"

#include <DuiButtonGroup>

#ifndef NOCONTROLPANEL
#include <DuiControlPanelIf>
#endif

#include <DuiButton>
#include <DuiDialog>
#include <DuiGridLayoutPolicy>
#include <DuiLabel>
#include <DuiLayout>
#include <DuiLinearLayoutPolicy>
#include <DuiLocale>
#include <DuiPopupList>
#include <DuiSceneManager>
#include <DuiTheme>
#include <DuiNamespace>
#include <DuiWidget>
#include <duireactionmap.h>
#include <duiplainwindow.h>

#include <QDebug>
#include <QGraphicsItemAnimation>
#include <QGraphicsLinearLayout>
#include <QGraphicsSceneMouseEvent>
#include <QPainter>
#include <QStringListModel>

namespace
{
    //! spacing for language menue items
    const int Spacing = 10;

    //! Control panel language page name
    const QString CpLanguagePage("Language");
};

// FIXME: when menu is shown and a click is made outside it (that is, on the keyboard)
// the menu disappears and bottom button isn't shown

// FIXME: parent

LayoutMenu::LayoutMenu(DuiVirtualKeyboardStyleContainer *style,
                       QGraphicsWidget */* parent */)
    : styleContainer(style),
      active(false),
      savedActive(false),
      centralWidget(0),
      titleLabel(0),
      errorCorrectionLabel(0),
      errorCorrectionButton(0),
      layoutListLabel(0),
      layoutListHeader(0),
      layoutList(0),
      languageSettingLabel(0),
      languageSettingButton(0),
      keyboardOptionDialog(0),
      menuWidget(0),
      mainLayout(0),
      correctionAndLanguageLandscapeLayout(0)
{
    setObjectName("LayoutMenu");
    getStyleValues();

    loadLanguageMenu();
}


void LayoutMenu::loadLanguageMenu()
{
    //create dialog and widgets
    centralWidget = new DuiWidget;
    centralWidget->setGeometry(0, 0, baseSize.width(), baseSize.height() + buttonSize.height());

    //% "Keyboard options"
    keyboardOptionDialog = new DuiDialog(qtTrId("qtn_vkb_keyboard_options"), Dui::NoButton);
    keyboardOptionDialog->setCentralWidget(centralWidget);

    connect(keyboardOptionDialog, SIGNAL(visibleChanged()), SLOT(visibleChangeHandler()));

    /* Create widgets and put then into the layout policy */

    //% "Error correction"
    errorCorrectionLabel = new DuiLabel(qtTrId("qtn_vkb_error_correction"),
                                        centralWidget);
    errorCorrectionLabel->setAlignment(Qt::AlignCenter);
    errorCorrectionLabel->setWordWrap(true);

    //% "On"
    errorCorrectionButton = new DuiButton(qtTrId("qtn_comm_on"), centralWidget);
    errorCorrectionButton->setObjectName("MenuToggleButton");
    errorCorrectionButton->setCheckable(true);
    errorCorrectionButton->setChecked(true);
    errorCorrectionButton->setMaximumWidth(baseSize.width() / 2);
    connect(errorCorrectionButton, SIGNAL(clicked()), this, SLOT(synchronizeErrorCorrection()));

    //% "Input language"
    layoutListLabel = new DuiLabel(qtTrId("qtn_vkb_input_language"), centralWidget);
    layoutListLabel->setAlignment(Qt::AlignCenter);

    layoutListHeader = new DuiButton(centralWidget);
    layoutListHeader->setMaximumWidth(baseSize.width() / 2);

    layoutList = new DuiPopupList();
    layoutList->setItemModel(new QStringListModel());

    connect(layoutListHeader, SIGNAL(clicked()), this, SLOT(showLanguageList()));

    //% "To modify the input languages, go to"
    languageSettingLabel = new DuiLabel(qtTrId("qtn_vkb_language_setting_label"), centralWidget);
    languageSettingLabel->setAlignment(Qt::AlignHCenter);

    //TODO: connect languageSettingButton with language setting
    //% "Language settings"
    languageSettingButton = new DuiButton(qtTrId("qtn_vkb_language_setting"), centralWidget);
    languageSettingButton->setMaximumWidth(baseSize.width() / 2);
    connect(languageSettingButton, SIGNAL(clicked()), this, SLOT(openLanguageApplet()));

    //create layout
    QGraphicsLinearLayout *correctionLayout = new QGraphicsLinearLayout(Qt::Vertical);
    correctionLayout->setSpacing(Spacing);
    correctionLayout->addItem(errorCorrectionLabel);
    correctionLayout->addItem(errorCorrectionButton);
    correctionLayout->setAlignment(errorCorrectionLabel, Qt::AlignCenter);
    correctionLayout->setAlignment(errorCorrectionButton, Qt::AlignCenter);

    QGraphicsLinearLayout *languageLayout = new QGraphicsLinearLayout(Qt::Vertical);
    languageLayout->setSpacing(Spacing);
    languageLayout->addItem(layoutListLabel);
    languageLayout->addItem(layoutListHeader);
    languageLayout->setAlignment(layoutListLabel, Qt::AlignCenter);
    languageLayout->setAlignment(layoutListHeader, Qt::AlignCenter);

    correctionAndLanguageLandscapeLayout = new  QGraphicsLinearLayout(Qt::Horizontal);
    correctionAndLanguageLandscapeLayout->setSpacing(Spacing);
    correctionAndLanguageLandscapeLayout->addItem(correctionLayout);
    correctionAndLanguageLandscapeLayout->addItem(languageLayout);

    QGraphicsLinearLayout *languageSettingLayout = new  QGraphicsLinearLayout(Qt::Vertical);
    languageSettingLayout->setSpacing(Spacing);
    languageSettingLayout->addItem(languageSettingLabel);
    languageSettingLayout->addItem(languageSettingButton);
    languageSettingLayout->setAlignment(languageSettingLabel, Qt::AlignCenter);
    languageSettingLayout->setAlignment(languageSettingButton, Qt::AlignCenter);

    mainLayout = new DuiLayout;

    //for landscape
    DuiLinearLayoutPolicy *landscapePolicy = new DuiLinearLayoutPolicy(mainLayout, Qt::Vertical);
    landscapePolicy->setSpacing(2 * Spacing);
    landscapePolicy->addItem(correctionAndLanguageLandscapeLayout);
    landscapePolicy->addItem(languageSettingLayout);

    //for portrait
    DuiLinearLayoutPolicy *portraitPolicy = new DuiLinearLayoutPolicy(mainLayout, Qt::Vertical);
    portraitPolicy->setSpacing(2 * Spacing);
    portraitPolicy->addItem(correctionLayout);
    portraitPolicy->addItem(languageLayout);
    portraitPolicy->addItem(languageSettingLayout);

    centralWidget->setLayout(mainLayout);
    mainLayout->setLandscapePolicy(landscapePolicy);
    mainLayout->setPortraitPolicy(portraitPolicy);

    // layoutList seems to be initially visible before calling appear()
    layoutList->hide();
}


LayoutMenu::~LayoutMenu()
{
    //clear correctionAndLanguageLandscapeLayout manually
    for (int i = 0; i < correctionAndLanguageLandscapeLayout->count(); i++)
        correctionAndLanguageLandscapeLayout->removeAt(i);
    //mainlayout will delete correctionAndLanguageLandscapeLayout within removeItem
    mainLayout->removeItem(correctionAndLanguageLandscapeLayout);

    // DuiPopupList does not take ownership of its model
    if (layoutList->itemModel()) {
        QAbstractItemModel *model = layoutList->itemModel();
        layoutList->setItemModel(0);
        delete model;
    }

    delete languageSettingLabel;
    delete languageSettingButton;
    delete titleLabel;
    delete errorCorrectionLabel;
    delete errorCorrectionButton;
    delete menuWidget;
    delete layoutListLabel;
    delete layoutListHeader;
    delete layoutList;

    // DuiDialog's view will destroy centralWidget
    delete keyboardOptionDialog;
}


void LayoutMenu::setLanguageList(const QStringList &titles, int selected)
{
    QStringListModel *model = qobject_cast<QStringListModel *>(layoutList->itemModel());

    model->setStringList(titles);
    QModelIndex index = model->index(selected);
    layoutList->setCurrentIndex(index);
    layoutListHeader->setText(index.data().toString());
}


void
LayoutMenu::show()
{
    if (!active) {
        active = true;
        QSize visibleSceneSize = DuiPlainWindow::instance()->visibleSceneSize();
        centralWidget->setPos(0, visibleSceneSize.height() - baseSize.height());

        DuiPlainWindow::instance()->sceneManager()->execDialog(keyboardOptionDialog);
    }
}

void LayoutMenu::visibleChangeHandler()
{
    QGraphicsObject *dialog = qobject_cast<QGraphicsObject *>(sender());
    Q_ASSERT(dialog);
    bool visibility = dialog->isVisible();

    if (!visibility) {
        active = false;
        emit hidden();
        emit regionUpdated(QRegion());
    } else {
        const QSize visibleSceneSize = DuiPlainWindow::instance()->visibleSceneSize();
        emit regionUpdated(QRegion(0, 0, visibleSceneSize.width(), visibleSceneSize.height()));
    }
}

bool
LayoutMenu::isActive() const
{
    return active;
}


void LayoutMenu::save()
{
    savedActive = active;
}


void LayoutMenu::restore()
{
    if (savedActive) {
        savedActive = false;
        show();
    }
}


void
LayoutMenu::getStyleValues()
{
    baseSize = style()->menuSize();
    buttonSize = style()->tabButtonSize();
}


void LayoutMenu::organizeContent(Dui::Orientation /* orientation */)
{
    getStyleValues();
    keyboardOptionDialog->reject();
}


void LayoutMenu::enableErrorCorrection()
{
    if (!errorCorrectionButton->isChecked()) {
        errorCorrectionButton->click();
    }
}


void LayoutMenu::disableErrorCorrection()
{
    if (errorCorrectionButton->isChecked()) {
        errorCorrectionButton->click();
    }
}


void LayoutMenu::redrawReactionMaps()
{
    if (!keyboardOptionDialog || !keyboardOptionDialog->scene())
        return;

    foreach (QGraphicsView *view, keyboardOptionDialog->scene()->views()) {
        DuiReactionMap *reactionMap = DuiReactionMap::instance(view);
        if (!reactionMap)
            continue;

        // Clear all with inactive color.
        reactionMap->setInactiveDrawingValue();
        reactionMap->setTransform(QTransform());
        reactionMap->fillRectangle(0, 0, reactionMap->width(), reactionMap->height());

        // We have no active areas, buttons take care of feedback playing.
    }
}


DuiVirtualKeyboardStyleContainer &LayoutMenu::style()
{
    return *styleContainer;
}


void LayoutMenu::showLanguageList()
{
    if (layoutList && layoutListHeader) {
        DuiPlainWindow::instance()->sceneManager()->execDialog(layoutList);
        QModelIndex index = layoutList->currentIndex();
        layoutListHeader->setText(index.data(Qt::DisplayRole).toString());
        emit languageSelected(index.row()); // QStringListModel has only rows.
    }
}


void LayoutMenu::synchronizeErrorCorrection()
{
    if (errorCorrectionButton->isChecked()) {
        emit errorCorrectionToggled(true);
        //% "On"
        errorCorrectionButton->setText(qtTrId("qtn_comm_on"));
    } else {
        emit errorCorrectionToggled(false);
        //% "Off"
        errorCorrectionButton->setText(qtTrId("qtn_comm_off"));
    }
}

void LayoutMenu::openLanguageApplet()
{
#ifndef NOCONTROLPANEL
    DuiControlPanelIf *dcpIf = new DuiControlPanelIf();
    if (dcpIf->isValid()) {
        dcpIf->appletPage(CpLanguagePage);
    }
    delete dcpIf;
    dcpIf = NULL;
#endif
}
