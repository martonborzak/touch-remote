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
import QtQuick 2.12
import QtGraphicalEffects 1.0
import Style 1.0

import Haptic 1.0
import ButtonHandler 1.0
import Entity.Blind 1.0

import "qrc:/basic_ui" as BasicUI

Rectangle {
    id: card
    width: parent.width; height: parent.height
    color: Style.color.dark
    radius: Style.cornerRadius

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CONNECT TO BUTTONS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    Connections {
        target: ButtonHandler

        onButtonPressed: {
            switch (button) {
            case ButtonHandler.DPAD_UP:
                if (obj.isSupported(Blind.F_OPEN)) {
                    obj.open()
                }
                break;
            case ButtonHandler.DPAD_DOWN:
                if (obj.isSupported(Blind.F_CLOSE)) {
                    obj.close()
                }
                break;
            case ButtonHandler.DPAD_MIDDLE:
                if (obj.isSupported(Blind.F_STOP)) {
                    obj.stop()
                }
                break;
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // LAYER MASK FOR ROUNDED CORNERS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource:
            Rectangle {
            id: opacityMask
            width: card.width; height: card.height
            radius: card.state === "closed" ? 0 : Style.cornerRadius

            Behavior on radius {
                NumberAnimation { duration: 300; easing.type: Easing.OutExpo }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // STATES
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    state: "closed"

    states: [
        State {
            name: "closed"
            PropertyChanges { target: percentage; anchors.topMargin: 200; opacity: 0 }
            PropertyChanges { target: title; opacity: 0 }
            PropertyChanges { target: bgGraphics; opacity: 0 }
            PropertyChanges { target: buttonStop; anchors.bottomMargin: -100; opacity: 0 }
            PropertyChanges { target: buttonDown; anchors.bottomMargin: -100; opacity: 0 }
            PropertyChanges { target: buttonUp; anchors.bottomMargin: -100; opacity: 0 }
        },
        State {
            name: "open"
            PropertyChanges { target: percentage; anchors.topMargin: 100; opacity: 1 }
            PropertyChanges { target: title; opacity: 1 }
            PropertyChanges { target: bgGraphics; opacity: 1 }
            PropertyChanges { target: buttonStop; anchors.bottomMargin: 70; opacity: 1 }
            PropertyChanges { target: buttonDown; anchors.bottomMargin: 70; opacity: 1 }
            PropertyChanges { target: buttonUp; anchors.bottomMargin: 70; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            to: "closed"
            ParallelAnimation {
                PropertyAnimation { target: percentage; properties: "anchors.topMargin, opacity"; easing.type: Easing.OutExpo; duration: 300 }
                PropertyAnimation { target: title; properties: "opacity"; easing.type: Easing.OutExpo; duration: 300 }
                PropertyAnimation { target: bgGraphics; properties: "opacity"; easing.type: Easing.OutExpo; duration: 300 }
                PropertyAnimation { target: buttonStop; properties: "anchors.bottomMargin, opacity"; easing.type: Easing.OutExpo; duration: 300 }
                PropertyAnimation { target: buttonDown; properties: "anchors.bottomMargin, opacity"; easing.type: Easing.OutExpo; duration: 300 }
                PropertyAnimation { target: buttonUp; properties: "anchors.bottomMargin, opacity"; easing.type: Easing.OutExpo; duration: 300 }
            }
        },
        Transition {
            to: "open"
            ParallelAnimation {
                PropertyAnimation { target: bgGraphics; properties: "opacity"; easing.type: Easing.OutExpo; duration: 300 }
                PropertyAnimation { target: percentage; properties: "anchors.topMargin, opacity"; easing.type: Easing.OutBack; easing.overshoot: 1; duration: 400 }
                PropertyAnimation { target: buttonDown; properties: "anchors.bottomMargin, opacity"; easing.type: Easing.OutBack; easing.overshoot: 1; duration: 400 }
                SequentialAnimation {
                    PauseAnimation { duration: 50 }
                    PropertyAnimation { target: buttonStop; properties: "anchors.bottomMargin, opacity"; easing.type: Easing.OutBack; easing.overshoot: 1; duration: 400 }
                }
                SequentialAnimation {
                    PauseAnimation { duration: 100 }
                    PropertyAnimation { target: buttonUp; properties: "anchors.bottomMargin, opacity"; easing.type: Easing.OutBack; easing.overshoot: 1; duration: 400 }
                }
                SequentialAnimation {
                    PauseAnimation { duration: 100 }
                    PropertyAnimation { target: title; properties: "opacity"; easing.type: Easing.OutExpo; duration: 300 }
                }
            }
        }
    ]


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // GRAPHICS FOR DRAGGABLE ELEMENT
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    property int position: obj.position
    property var percent
    property bool userMove: false

    Component.onCompleted: {
        percent = obj.position;
        card.state = "open";
    }

    Item {
        id: bgGraphics
        width: parent.width; height: parent.height
        anchors.centerIn: parent
        visible: obj.isSupported(Blind.F_POSITION)

        Column {
            anchors.top: parent.top
            spacing: 10

            Repeater {
                id: repeater
                model: userMove ? Math.round(percent*36/100) : Math.round(obj.position*36/100)

                delegate: Rectangle {
                    width: card.width; height: 10
                    color: Style.color.highlight2
                }
            }
        }

        Rectangle {
            id: dragger_target
            width: parent.width; height: parent.height
            color: Style.color.backgroundTransparent
            y: userMove ? Math.round(height*percent/100) : Math.round(obj.position/100)
        }

        MouseArea {
            id: dragger
            anchors.fill: parent
            drag { target: dragger_target; axis: Drag.YAxis; minimumY: 0; maximumY: dragger_target.height }

            onPositionChanged: {
                Haptic.playEffect(Haptic.Bump);
                percent = Math.round(mouse.y/parent.height*100)
                if (percent < 0) percent = 0
                if (percent > 100) percent = 100
            }

            onPressed: {
                userMove = true;
            }

            onReleased: {
                obj.setPosition(percent);
            }
        }
    }

    onPositionChanged: {
        if (userMove && position === percent) {
            userMove = false;
        } else {
            percent = position;
        }
    }

    Text {
        id: icon
        color: Style.color.text
        text: Style.icon.blind
        renderType: Text.NativeRendering
        width: 85; height: 85
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        font { family: "icons"; pixelSize: 100 }
        anchors { top: parent.top; topMargin: 20; left: parent.left; leftMargin: 20 }
    }

    Text {
        id: percentage
        color: Style.color.text
        visible: obj.isSupported(Blind.F_POSITION)
        text: userMove ? percent : obj.position
        horizontalAlignment: Text.AlignLeft
        anchors { top: parent.top; topMargin: 100; left: parent.left; leftMargin: 30 }
        font { family: "Open Sans Light"; pixelSize: 180 }
    }

    Text {
        color: Style.color.text
        visible: obj.isSupported(Blind.F_POSITION)
        opacity: percentage.opacity
        text: "%"
        anchors { left: percentage.right; bottom: percentage.bottom; bottomMargin: 30 }
        font { family: "Open Sans Light"; pixelSize: 100 }
    }

    Text {
        id: title
        color: Style.color.text
        text: obj.friendly_name
        wrapMode: Text.WordWrap
        width: parent.width-60
        anchors { top: percentage.bottom; topMargin: -40; left: parent.left; leftMargin: 30 }
        font { family: "Open Sans Regular"; pixelSize: 60 }
        lineHeight: 0.9
    }

    Text {
        id: areaText
        color: Style.color.text
        opacity: 0.5
        text: obj.area
        elide: Text.ElideRight
        wrapMode: Text.NoWrap
        width: parent.width-60
        anchors { top: title.bottom; topMargin: 20; left: parent.left; leftMargin: 30 }
        font { family: "Open Sans Regular"; pixelSize: 24 }
    }

    BasicUI.CustomButton {
        id: buttonDown
        anchors { left: parent.left; leftMargin: 30; bottom: parent.bottom; bottomMargin: 70 }
        color: Style.color.text
        buttonText: "   "
        visible: obj.isSupported(Blind.F_CLOSE)

        mouseArea.onClicked: {
            Haptic.playEffect(Haptic.Click);
            obj.close()
        }

        Text {
            color: Style.color.background
            text: Style.icon.down_arrow_bold
            width: 85; height: 85
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            font {family: "icons"; pixelSize: 100 }
            anchors.centerIn: parent
        }
    }

    BasicUI.CustomButton {
        id: buttonStop
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 70 }
        color: Style.color.text
        buttonText: "   "
        visible: obj.isSupported(Blind.F_STOP)
        mouseArea.onClicked: {
            Haptic.playEffect(Haptic.Click);
            obj.stop()
        }

        Text {
            color: Style.color.background
            text: Style.icon.square
            width: 85; height: 85
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            font {family: "icons"; pixelSize: 100 }
            anchors.centerIn: parent
        }
    }

    BasicUI.CustomButton {
        id: buttonUp
        anchors { right: parent.right; rightMargin: 30; bottom: parent.bottom; bottomMargin: 70 }
        color: Style.color.text
        buttonText: "   "
        visible: obj.isSupported(Blind.F_OPEN)

        mouseArea.onClicked: {
            Haptic.playEffect(Haptic.Click);
            obj.open()
        }

        Text {
            color: Style.color.background
            text: Style.icon.up_arrow_bold
            width: 85; height: 85
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            font {family: "icons"; pixelSize: 100 }
            anchors.centerIn: parent
        }
    }
}
