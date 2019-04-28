import QtQuick 2.11
import QtQuick.Controls 2.4

Flickable {
    id: itemFlickable
    width: parent.width
    height: parent.height
    maximumFlickVelocity: 4000
    flickDeceleration: 2000
    clip: true
    contentHeight: iconFlow.height < 800 - mainNavigation.height - statusBar.height - miniMediaPlayer.height + bottomGradient.height ? iconFlow.height + 40 : iconFlow.height
    boundsBehavior: Flickable.DragAndOvershootBounds
    flickableDirection: Flickable.VerticalFlick

    ScrollBar.vertical: ScrollBar {
        opacity: 0.5
    }

    property alias iconFlow: iconFlow

    Flow {
        id: iconFlow
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Component.onCompleted: {
            for (var i=0; i<loaded_entities.length; i++) {
                for (var j=0; j<loaded_components[loaded_entities[i]].entities.length; j++) {
                    if (loaded_components[loaded_entities[i]].entities[j].favorite) {
                        // load entity button
                        var comp = Qt.createComponent("qrc:/components/"+ loaded_entities[i] +"/Button.qml");
                        var obj = comp.createObject(iconFlow, {entityID: j});
                    }
                }
            }
        }
    }
}