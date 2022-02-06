import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

import org.cutieshell 1.0

import "scripts/desktop.js" as Desktop
import "mainscreen"

Page {
    id: root
    focus: true
    width: Screen.width
    height: Screen.height
    visible: true
    background: Rectangle {
        color: "transparent"
    }

    CutieWindowModel {
        id: switcherModel
    }

    states: [
        State {
            name: "switcher"
            PropertyChanges { target: feedPage; opacity: 0.0 }
            PropertyChanges { target: appgrid; opacity: 1.0 }
        },
        State {
            name: "feed"
            PropertyChanges { target: feedPage; opacity: 1.0 }
            PropertyChanges { target: appgrid; opacity: 0.0 }
        }
    ]

    state: "switcher"

    Item {
        id: feedPage
        anchors.fill: parent
        z: 1

        Rectangle {
            id: backgroundShader
            anchors.fill: parent
            color: "black"
            opacity: 0.7
        }

        Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 5 * Screen.pixelDensity
            text: "Notifications"
            font.pixelSize: 5 * Screen.pixelDensity
            font.weight: Font.Light
            color: "white"
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    GridView {
        id: appgrid
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        cellWidth: switcherModel.itemCount > 4 ? width / Math.ceil(Math.sqrt(switcherModel.itemCount)) : width / 2
        cellHeight: switcherModel.itemCount > 4 ? height / Math.ceil(Math.sqrt(switcherModel.itemCount)) : height / 2
        z: 1
        model: switcherModel
        delegate: Item {
            width: appgrid.cellWidth
            height: appgrid.cellHeight

            Rectangle {
                id: dimItem
                anchors.fill: parent
                anchors.margins: Screen.pixelDensity
                color: "black"
                opacity: 0.6
            }

            WindowPixmapItem {
                id: windowPixmap
                anchors.fill: parent
                anchors.margins: Screen.pixelDensity
                windowId: model.window
                smooth: true
                opacity: 1
            }

            MouseArea {
                anchors.fill: parent
                property int threshold: 5 * Screen.pixelDensity
                property Item _mapTo: root
                onClicked: {
                    var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);
                    if (Math.abs(gestureArea.origX - mouseReal.x) < threshold && Math.abs(gestureArea.origY - mouseReal.y) < threshold) {
                        Lipstick.compositor.animateInById(model.window);
                    }
                }
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }


    MouseArea {
        id: gestureArea
        anchors.fill: parent
        propagateComposedEvents: true
        z: 2

        property int threshold: 15 * Screen.pixelDensity

        property int origX
        property int origY

        property bool active: gesture != ""
        property string gesture

        property Item _mapTo: root

        onPressed: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);
            gesture = "start";
            origX = mouseReal.x;
            origY = mouseReal.y;
        }

        onReleased: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);

            if (gesture == "left" || gesture == "right") {
                if ((gesture == "left" && mouseReal.x - origX > threshold) || (gesture == "right" && origX - mouseReal.x > threshold)) {
                    root.state = (root.state == "switcher") ? "feed" : "switcher";
                } else {
                    appgrid.opacity = (root.state == "switcher") ? 1 : 0;
                    feedPage.opacity = (root.state == "switcher") ? 0 : 1;
                }
            }
            gesture = "";
        }

        onPositionChanged: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);

            if (gesture != "") {
                if (mouseReal.x < origX) {
                    gesture = "right";
                } else if (mouseReal.x > origX) {
                    gesture = "left";
                }
            } 
            
            if (gesture == "left") {
                if (root.state == "switcher") {
                    appgrid.opacity = 1 - (mouseReal.x - origX)/origX;
                    feedPage.opacity = (mouseReal.x - origX)/origX;
                } else if (root.state == "feed") {
                    appgrid.opacity = (mouseReal.x - origX)/origX;
                    feedPage.opacity = 1 - (mouseReal.x - origX)/origX;
                }
            } else if (gesture == "right") {
                if (root.state == "switcher") {
                    appgrid.opacity = 1 - (origX - mouseReal.x)/(_mapTo.width - origX);
                    feedPage.opacity = (origX - mouseReal.x)/(_mapTo.width - origX);
                } else if (root.state == "feed") {
                    appgrid.opacity = (origX - mouseReal.x)/(_mapTo.width - origX);
                    feedPage.opacity = 1 - (origX - mouseReal.x)/(_mapTo.width - origX);
                }
            }
        }
    }
}
