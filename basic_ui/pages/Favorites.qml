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
import Style 1.0

Flickable {
    id: itemFlickable

    //: Name of the settings page
    property string title: qsTr("Favorites") + translateHandler.emptyString

    property alias _contentY: itemFlickable.contentY
    property alias _contentHeight: itemFlickable.contentHeight
    property alias _height: itemFlickable.height

    // property to know if this is the current page, so we know it's visible
    property bool _isCurrentItem: parent._isCurrentItem

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
    contentHeight: listView.height + titleContainer.height + mainNavigation.height + 20
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

    // ENTITIES
    ListView {
        id: listView
        width: parent.width; height: contentHeight
        anchors.top: titleContainer.bottom
        interactive: false
        spacing: 10

        model: config.profileFavorites
        delegate: entityDelegate
    }

    // LISTVIEW DELEGATE
    Component {
        id: entityDelegate

        Loader {
            id: entityLoader
            width: 460; height: 125
            anchors.horizontalCenter: parent.horizontalCenter

            property bool __isCurrentItem: _isCurrentItem

            Component.onCompleted: {
                var e = entities.get(config.profileFavorites[index]);
                if (e)
                    this.setSource("qrc:/components/"+ e.type +"/ui/Button.qml", { "obj": e });
            }
        }
    }

}
