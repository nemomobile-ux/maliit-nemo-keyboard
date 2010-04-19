/* * This file is part of m-keyboard *
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


#ifndef HORIZONTALSWITCHER_H
#define HORIZONTALSWITCHER_H

#include <QObject>
#include <QGraphicsWidget>
#include <QGraphicsItemAnimation>
#include <QTimeLine>

class HorizontalSwitcher : public QGraphicsWidget
{
    Q_OBJECT

public:
    /*! SwitchDirection tells which direction we want to
     *  move the "camera", that is, the contents will
     *  slide in opposite direction.
     */
    enum Direction {
        Left, Right
    };

    HorizontalSwitcher(QGraphicsItem *parent = 0);
    virtual ~HorizontalSwitcher();

    //! \brief Slide to the next widget of current with given direction.
    //!
    //! Does nothing if less than two widgets added.
    //! Does not loop by default if end reached. You can use setLooping()
    //! method to change this behaviour.
    void switchTo(Direction direction);

    //! \brief Slide from current widget to one with given index.
    void switchTo(int index);

    //! \brief Slide from current widget to the given widget.
    //!        Widget must exist in the switcher.
    void switchTo(QGraphicsWidget *widget);

    /*!
     * \brief Returns true if it is not possible to switch to the next
     * widget of current with given direction without looping.
     * \param direction Direction of switching
     */
    bool isAtBoundary(Direction direction) const;

    //! \brief Show given widget without animation.
    //!        The widget must be already added.
    void setCurrent(QGraphicsWidget *widget);

    //! \brief Show widget with given index without animation
    void setCurrent(int index);

    //! \return Currently shown widget's index or -1 if no widget is shown
    int current() const;

    //! \return Currently shown widget or NULL if no widget is shown
    QGraphicsWidget *currentWidget() const;

    //! \return Widget in a given \a index or NULL if index is invalid
    QGraphicsWidget *widget(int index);

    //! \return Number of widgets in the switcher.
    int count() const;

    //! \return true if animation running, false otherwise
    bool isRunning() const;

    //! \brief Tell switcher should it loop when trying to move to
    //!        index after the last one.
    void setLooping(bool enable);

    //! \brief Set duration for sliding animation.
    void setDuration(int ms);

    //! \brief Add widget to switcher. Takes ownership.
    //!
    //! Indices for widgets are added in the order they were added.
    void addWidget(QGraphicsWidget *widget);

    //! \brief Remove widget from switcher. Ownership changed to caller.
    void removeWidget(QGraphicsWidget *widget);

    //! \brief Remove all widgets. Ownership changed to caller.
    void removeAll();

    /// \brief Deletes all widgets
    void deleteAll();

signals:
    /*! \brief Signals the beginning of a switch.
     *         This is emitted even if there is no animation.
     *  \param current Index of current widget that is about to be hidden,
     *                  or -1 if there is no current.
     *  \param next Index of the next widget that is shown.
     */
    void switchStarting(int current, int next);

    void switchStarting(QGraphicsWidget *current, QGraphicsWidget *next);

    /*! \brief Signals the ending of a switch.
     *  \param previous Index of widget that is now hidden,
     *                  or -1 if there was no previous.
     *  \param current Index of the current visible widget.
     */
    void switchDone(int previous, int current);

    void switchDone(QGraphicsWidget *previous, QGraphicsWidget *current);

protected:
    //! \reimp
    virtual void resizeEvent(QGraphicsSceneResizeEvent *event);
    virtual QSizeF sizeHint(Qt::SizeHint which, const QSizeF &constraint = QSizeF()) const;
    //! \reimp_end

private slots:
    void finishAnimation();

private:
    int currentIndex;
    QList<QGraphicsWidget *> slides;
    QGraphicsItemAnimation enterAnim;
    QGraphicsItemAnimation leaveAnim;
    QTimeLine animTimeLine;
    bool loopingEnabled;
};

#endif
