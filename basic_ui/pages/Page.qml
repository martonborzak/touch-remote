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

Flickable {
    id: itemFlickable

    // UUID of page
    property string page

    //: Name of the settings page
    property string title: qsTr(config.pages[page].name) + translateHandler.emptyString

    property alias _contentY: itemFlickable.contentY
    property alias _contentHeight: itemFlickable.contentHeight
    property alias _height: itemFlickable.height

    // property to know if this is the current page, so we know it's visible
    property bool _isCurrentItem: parent._isCurrentItem

    // image background handling
    property string img_url

    // get the URL from config JSON
    Component.onCompleted: {
        img_url = Qt.binding(function () {
            if (config.pages[page].image) {
                topImage.visible = true;
                return "file://" + config.pages[page].image;
            } else {
                topImage.visible = false;
                return "";
            }
        });
    }

    signal scrolledUp()
    signal scrolledDown()
    signal scrollupBegin()
    signal scrolldownBegin()

    onContentYChanged: {
        if (contentY > 10) {
            scrollupBegin();
        } else {
            scrolldownBegin()
        }

        if (contentY > 130) {
            scrolledUp();
        } else {
            scrolledDown();
        }
    }

    width: parent.width; height: parent.height
    maximumFlickVelocity: 6000
    flickDeceleration: 1000
    contentHeight: groupContainer.height + titleContainer.height + mainNavigation.height + 20
    boundsBehavior: Flickable.DragAndOvershootBounds
    flickableDirection: Flickable.VerticalFlick

    Behavior on contentY {
        PropertyAnimation {
            duration: 300
            easing.type: Easing.OutExpo
        }
    }

    ScrollBar.vertical: ScrollBar {
        opacity: 0.5
    }

    Item {
        id: topImage
        width: parent.width; height: 320
        anchors.top: parent.top
        opacity: bgImage.status == Image.Error ? 0 : 1

        Rectangle {
            id: comp
            anchors.fill: parent
            color: Style.color.background

            Image {
                id: bgImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                source: img_url
            }

            Rectangle {
                id: gradient
                width: parent.width; height: 80
                anchors.bottom: parent.bottom

                LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, 80)
                        gradient: Gradient {
                            GradientStop { position: 0.2; color: Style.color.backgroundTransparent }
                            GradientStop { position: 1.0; color: Style.color.background }
                        }
                    }
            }

            Blend {
                anchors.fill: bgImage
                source: bgImage
                foregroundSource: gradient
                mode: "multiply"
            }
        }

        Image {
            id: noise
            anchors.fill: parent
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
            source: "qrc:/images/mini-music-player/noise.png"
        }

        Blend {
            anchors.fill: comp
            source: comp
            foregroundSource: noise
            mode: "multiply"
        }

        Rectangle {
            id: overlay
            anchors.fill: noise
            color: Style.color.background
            opacity: 0.5
        }
    }

    Item {
        id: titleContainer
        width: parent.width; height: 240

        Text {
            id: titleText
            color: Style.color.text
            text: title
            anchors.centerIn: parent
            font { family: "Open Sans Regular"; weight: Font.Normal; pixelSize: 60 }
            lineHeight: 1
        }
    }

    Column {
        id: groupContainer
        width: parent.width
        anchors { horizontalCenter: parent.horizontalCenter; top: titleContainer.bottom }
        spacing: 60

        Repeater {
            id: groupRepeater
            model: config.pages[page].groups

            Group {
                groupID: config.pages[page].groups[index]
                _isCurrentItem: itemFlickable._isCurrentItem
            }
        }
    }
}
