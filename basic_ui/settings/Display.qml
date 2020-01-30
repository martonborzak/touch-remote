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

import QtQuick 2.11
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Style 1.0

import DisplayControl 1.0

import "qrc:/basic_ui" as BasicUI

Rectangle {
    id: section
    width: parent.width
    height: childrenRect.height + 40
    radius: Style.cornerRadius
    color: Style.colorDark

    Text {
        id: autobrightnessText
        color: Style.colorText
        text: qsTr("Auto brightness") + translateHandler.emptyString
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        font.family: "Open Sans Regular"
        font.weight: Font.Normal
        font.pixelSize: 27
        lineHeight: 1
    }

    BasicUI.CustomSwitch {
        id: autobrightnessButton

        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: autobrightnessText.verticalCenter

        checked: config.settings.autobrightness
        mouseArea.onClicked: {
            var tmp = config.settings;
            tmp.autobrightness = !tmp.autobrightness;
            config.settings = tmp;
        }
    }

    Slider {
        id: brightnessSlider
        from: 10
        value: DisplayControl.currentBrightness
        to: 100
        stepSize: 1
        live: false

        width: parent.width-40
        anchors.top: section.top
        anchors.topMargin: 87
        anchors.horizontalCenter: parent.horizontalCenter

        property bool setbyUser: false

        background: Rectangle {
            id: sliderBG
            x: parent.leftPadding
            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: brightnessSlider.setbyUser ? 28 : 4
            width: brightnessSlider.availableWidth
            height: implicitHeight
            radius: brightnessSlider.setbyUser ? 14 : 2
            color: Style.colorBackground

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource:
                    Rectangle {
                    id: opacityMask
                    width: sliderBG.width; height: sliderBG.height
                    radius: sliderBG.radius

                    Behavior on radius {
                        NumberAnimation { duration: 300; easing.type: Easing.OutExpo }
                    }
                }
            }

            Behavior on height {
                PropertyAnimation {
                    duration: 300
                    easing.type: Easing.OutExpo
                }
            }

            Rectangle {
                width: brightnessSlider.visualPosition * parent.width
                height: brightnessSlider.setbyUser ? 28 : 4
                radius: 2
                color: Style.colorHighlight1

                Behavior on height {
                    PropertyAnimation {
                        duration: 300
                        easing.type: Easing.OutExpo
                    }
                }
            }
        }

        handle: Rectangle {
            x: brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width/2)
            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
            implicitWidth: 28
            implicitHeight: 28
            radius: Style.cornerRadius
            color: Style.colorLine
        }

        onValueChanged: {
            if (setbyUser) {
                DisplayControl.setBrightness(brightnessSlider.value);
                DisplayControl.setUserBrightness(brightnessSlider.value);
                setbyUser = false;
            }
        }

        onMoved: {
            setbyUser = true;
        }
    }

    Rectangle {
        id: line1
        width: parent.width
        height: 2
        color: Style.colorBackground
        anchors.top: brightnessSlider.bottom
        anchors.topMargin: 20
    }

    Text {
        id: darkModeText
        color: Style.colorText
        text: qsTr("Dark mode") + translateHandler.emptyString
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: line1.bottom
        anchors.topMargin: 20
        font.family: "Open Sans Regular"
        font.weight: Font.Normal
        font.pixelSize: 27
        lineHeight: 1
    }

    BasicUI.CustomSwitch {
        id: darkModeButton

        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: darkModeText.verticalCenter

        checked: config.ui_config.darkmode
        mouseArea.onClicked: {
            var tmp = config.ui_config
            tmp.darkmode = !tmp.darkmode
            config.ui_config = tmp;
        }
    }

    Rectangle {
        id: line2
        width: parent.width
        height: 2
        color: Style.colorBackground
        anchors.top: darkModeText.bottom
        anchors.topMargin: 20
    }

    Text {
        id: cleaningText
        color: Style.colorText
        text: qsTr("Cleaning mode") + translateHandler.emptyString
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: line2.bottom
        anchors.topMargin: 20
        font.family: "Open Sans Regular"
        font.weight: Font.Normal
        font.pixelSize: 27
        lineHeight: 1
    }

    Text {
        id: cleaningsmallText
        color: Style.colorText
        opacity: 0.5
        text: qsTr("Touch the display for 10 seconds to turn cleaning mode off.") + translateHandler.emptyString
        wrapMode: Text.WordWrap
        width: parent.width - 40 - cleaningmodeButton.width
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: cleaningText.bottom
        anchors.topMargin: 10
        font.family: "Open Sans Regular"
        font.weight: Font.Normal
        font.pixelSize: 20
        lineHeight: 1
    }

    BasicUI.CustomSwitch {
        id: cleaningmodeButton

        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: cleaningText.verticalCenter

        checked: false
        mouseArea.onClicked: {
            cleaningmodeButton.checked = true
            touchEventCatcher.enabled = true
            DisplayControl.setBrightness(0);
            DisplayControl.setMode(DisplayControl.StandbyOn);
            cleaningmodeButtonTimer.start();
        }

        Timer {
            id: cleaningmodeButtonTimer
            repeat: false
            interval: 2000
            running: false

            onTriggered: {
                cleaningmodeButton.checked = false;
            }
        }
    }
}
