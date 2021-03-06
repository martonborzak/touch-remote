/******************************************************************************
 *
 * Copyright (C) 2020 Markus Zehnder <business@markuszehnder.ch>
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

// MSVC is very picky about the order of windows header files!
// windows.h MUST be first, otherwise you'll end up with "No Target Architecture" errors!
#include <windows.h>

#include "../sysinfo.h"

typedef struct _FILETIME FILETIME;

class SystemInfoWin : public SystemInfo {
    Q_OBJECT

 public:
    explicit SystemInfoWin(QObject* parent = nullptr);

    // SystemInformation interface
 public:
    void    init() override;
    QString uptime() override;
    float   usedMemory() override;
    bool    cpuTemperatureSupported() override;
    float   cpuTemperature() override;
    float   cpuLoadAverage() override;

 private:
    struct CpuSample {
     public:
        quint64 totalSystemTime;
        quint64 totalUserTime;
        quint64 totalIdleTime;
    };

    bool       getCpuSample(CpuSample* sample);
    qulonglong convertFileTime(const FILETIME& filetime) const;

 private:
    CpuSample m_lastCpuSample;
};
