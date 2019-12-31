/******************************************************************************
 *
 * Copyright (C) 2018-2019 Marton Borzak <hello@martonborzak.com>
 *
 * Third party work used:
 *
 * This is a library for the Adafruit DRV2605L Haptic Driver ----> http://www.adafruit.com/products/2305
 * Check out the links above for our tutorials and wiring diagrams.
 * This motor/haptic driver uses I2C to communicate.
 * Adafruit invests time and resources providing this open source code,
 * please support Adafruit and open-source hardware by purchasing
 * products from Adafruit!
 * Written by Limor Fried/Ladyada for Adafruit Industries.
 * MIT license, all text above must be included in any redistribution.
 *
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

#include "drv2605.h"
#include "../../notifications.h"

// FIXME use strategy pattern for architecture specific device driver instead of multiple
Drv2605::Drv2605(QObject* parent) : HapticMotor(parent) {
    if (init()) {
        selectLibrary(1);
        setMode(DRV2605_MODE_INTTRIG);
    } else {
        Notifications::getInstance()->add(true, tr("Cannot initialize the haptic motor. Please restart the remote."));
    }
}

void Drv2605::playEffect(const QString& effect) {
    if (effect == "click") {
        setWaveform(0, 1);
        go();
    }
    if (effect == "bump") {
        setWaveform(0, 24);
        go();
    }
    if (effect == "press") {
        setWaveform(0, 86);
        go();
    }
    if (effect == "buzz") {
        setWaveform(0, 47);
        go();
    }
}

bool Drv2605::init() {
    wiringPiSetup();
    // TODO(zehnm) make i2c device configurable
    bus = wiringPiI2CSetupInterface("/dev/i2c-3", DRV2605_ADDR);

    //    int id = readRegister8(DRV2605_REG_STATUS);

    writeRegister8(DRV2605_REG_MODE, 0x00);  // out of standby

    //    writeRegister8(DRV2605_REG_RTPIN, 0x00); // no real-time-playback

    //    writeRegister8(DRV2605_REG_WAVESEQ1, 1); // strong click
    //    writeRegister8(DRV2605_REG_WAVESEQ2, 0); // end sequence

    //    writeRegister8(DRV2605_REG_OVERDRIVE, 0); // no overdrive

    //    writeRegister8(DRV2605_REG_SUSTAINPOS, 0);
    //    writeRegister8(DRV2605_REG_SUSTAINNEG, 0);
    //    writeRegister8(DRV2605_REG_BREAK, 0);
    //    writeRegister8(DRV2605_REG_AUDIOMAX, 0x64);

    // turn off N_ERM_LRA
    writeRegister8(DRV2605_REG_FEEDBACK, readRegister8(DRV2605_REG_FEEDBACK) & 0x7F);
    // turn on ERM_OPEN_LOOP
    writeRegister8(DRV2605_REG_CONTROL3, readRegister8(DRV2605_REG_CONTROL3) | 0x20);

    return true;
}

void Drv2605::setWaveform(uint8_t slot, uint8_t w) { writeRegister8(DRV2605_REG_WAVESEQ1 + slot, w); }

void Drv2605::selectLibrary(uint8_t lib) { writeRegister8(DRV2605_REG_LIBRARY, lib); }

void Drv2605::go() { writeRegister8(DRV2605_REG_GO, 1); }

void Drv2605::stop() { writeRegister8(DRV2605_REG_GO, 0); }

void Drv2605::setMode(uint8_t mode) { writeRegister8(DRV2605_REG_MODE, mode); }

void Drv2605::setRealtimeValue(uint8_t rtp) { writeRegister8(DRV2605_REG_RTPIN, rtp); }

int Drv2605::readRegister8(uint8_t reg) { return wiringPiI2CReadReg8(bus, reg); }

void Drv2605::writeRegister8(uint8_t reg, uint8_t val) { wiringPiI2CWriteReg8(bus, reg, val); }