import QtQuick 2.11
import QtQuick.Controls 2.4

import Launcher 1.0

import "qrc:/basic_ui" as BasicUI

Item {
    width: parent.width
    height: header.height + section.height + 20

    Launcher {
        id: settingsLauncher
    }

    Timer {
        running: mainNavigationSwipeview.currentIndex ==  2 + supported_entities.length ? true : false
        repeat: true
        interval: 2000

        onTriggered: {
            uptimeValue.text = settingsLauncher.launch("/usr/bin/remote/uptime.sh");
            temperatureValue.text = parseInt(settingsLauncher.launch("cat /sys/class/thermal/thermal_zone0/temp"))/1000 + "ºC";
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // SYSTEM
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    Text {
        id: header
        color: colorText
        text: translations[language].settings.system
        anchors.left: parent.left
        font.family: "Open Sans"
        font.weight: Font.Normal
        font.pixelSize: 27
        lineHeight: 1
    }

    Rectangle {
        id: section
        width: parent.width
        height: 268
        radius: cornerRadius
        color: colorMedium

        anchors.top: header.bottom
        anchors.topMargin: 20

        Text {
            id: uptimeText
            color: colorText
            text: translations[language].settings.uptime
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            font.family: "Open Sans"
            font.weight: Font.Normal
            font.pixelSize: 27
            lineHeight: 1
        }

        Text {
            id: uptimeValue
            color: colorText
            text: "0h"
            horizontalAlignment: Text.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: uptimeText.verticalCenter
            font.family: "Open Sans"
            font.weight: Font.Normal
            font.pixelSize: 27
            lineHeight: 1
        }

        Rectangle {
            id: line7
            width: parent.width
            height: 2
            color: colorBackground
            anchors.top: uptimeText.bottom
            anchors.topMargin: 20
        }

        Text {
            id: temperatureText
            color: colorText
            text: translations[language].settings.cputemperature
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: line7.bottom
            anchors.topMargin: 20
            font.family: "Open Sans"
            font.weight: Font.Normal
            font.pixelSize: 27
            lineHeight: 1
        }

        Text {
            id: temperatureValue
            color: colorText
            text: "36ºC"
            horizontalAlignment: Text.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: temperatureText.verticalCenter
            font.family: "Open Sans"
            font.weight: Font.Normal
            font.pixelSize: 27
            lineHeight: 1
        }

        Rectangle {
            id: line8
            width: parent.width
            height: 2
            color: colorBackground
            anchors.top: temperatureText.bottom
            anchors.topMargin: 20
        }

        BasicUI.CustomButton {
            id: buttonReboot
            buttonText: translations[language].settings.reboot
            anchors.top: line8.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - (buttonReboot.width + buttonShutdown.width + 40))/2

            mouseArea.onClicked: {
                settingsLauncher.launch("fbv -d 1 /bye.png")
                console.debug("now reboot")
                settingsLauncher.launch("reboot");
            }
        }

        BasicUI.CustomButton {
            id: buttonShutdown
            buttonText: translations[language].settings.shutdown
            anchors.top: line8.bottom
            anchors.topMargin: 30
            anchors.left: buttonReboot.right
            anchors.leftMargin: 40

            mouseArea.onClicked: {
                settingsLauncher.launch("fbv -d 1 /bye.png")
                console.debug("now shutdown")
                settingsLauncher.launch("halt");
            }
        }
    }
}
