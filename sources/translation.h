/******************************************************************************
 *
 * Copyright (C) 2018-2020 Marton Borzak <hello@martonborzak.com>
 *
 * This file is part of the YIO-Remote software project.
 *
 * YIO-Remote software is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * YIO-Remote software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with YIO-Remote software. If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *****************************************************************************/

#pragma once

#include <QGuiApplication>
#include <QObject>
#include <QQmlEngine>
#include <QTranslator>

#include "integrations/integrations.h"
#include "yio-interface/plugininterface.h"

class TranslationHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)

 public:
    explicit TranslationHandler(QQmlEngine *engine);
    virtual ~TranslationHandler();

    QString          getEmptyString() { return ""; }
    Q_INVOKABLE void selectLanguage(QString language);

    static TranslationHandler *getInstance() { return s_instance; }

 signals:
    void languageChanged();

 private:
    static TranslationHandler *s_instance;

    QTranslator *m_translator;
    QQmlEngine * m_engine;
};
