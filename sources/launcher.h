/******************************************************************************
 *
 * Copyright (C) 2018-2019 Marton Borzak <hello@martonborzak.com>
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

#include <QObject>
#include <QProcess>

class Launcher : public QObject {
    Q_OBJECT
 public:
    explicit Launcher(QObject *parent = nullptr);
    Q_INVOKABLE QString launch(const QString &program);

    QObject *loadPlugin(const QString &path, const QString &pluginName);
    QString  getPluginPath(const QString &path, const QString &pluginName);

    /**
     * @brief Returns true if the given integrations.library version of a plugin is compatible with the application.
     */
    bool isCompatibleIntgLibVersion(const QString &pluginIntgLibVersion);

    /**
     * @brief Returns true if the required minium app version is fulfilled
     */
    bool isCompatibleAppVersion(const QString &requiredMinAppVersion);

 private:
    QString cleanVersionString(const QString &version);

    QProcess *m_process;
};
