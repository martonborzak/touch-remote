/******************************************************************************
 *
 * Copyright (C) 2019 Markus Zehnder <business@markuszehnder.ch>
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

#include "displaycontrol.h"
#include "hardwarefactory.h"
#include "webserver_control.h"

/**
 * @brief Concrete hardware factory implementation for the Raspberry Pi Zero in the YIO Remote.
 */
class HardwareFactoryRPi0 : public HardwareFactory {
    Q_OBJECT

 public:
    explicit HardwareFactoryRPi0(const QVariantMap &config, QObject *parent = nullptr);

    // HardwareFactory interface
 public:
    WifiControl *getWifiControl() override;

    SystemService *getSystemService() override;

    WebServerControl *getWebServerControl() override;

    DisplayControl *getDisplayControl() override;

    BatteryFuelGauge *getBatteryFuelGauge() override;

    InterruptHandler *getInterruptHandler() override;

    HapticMotor *getHapticMotor() override;

 protected:
    virtual WifiControl *     buildWifiControl(const QVariantMap &config);
    virtual SystemService *   buildSystemService(const QVariantMap &config);
    virtual WebServerControl *buildWebServerControl(const QVariantMap &config);
    virtual DisplayControl *  buildDisplayControl(const QVariantMap &config);
    virtual BatteryFuelGauge *buildBatteryFuelGauge(const QVariantMap &config);
    virtual InterruptHandler *buildInterruptHandler(const QVariantMap &config);
    virtual HapticMotor *     buildHapticMotor(const QVariantMap &config);

 private:
    WifiControl *     p_wifiControl;
    SystemService *   p_systemService;
    WebServerControl *p_webServerControl;
    DisplayControl *  p_displayControl;
    BatteryFuelGauge *p_batteryFuelGauge;
    InterruptHandler *p_interruptHandler;
};
