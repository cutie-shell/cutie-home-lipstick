import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import org.nemomobile.lipstick 0.1

import "compositor"

Item {
    id: root
    x: 0
    y: 0
    height: parent.height
    width: parent.width
    visible: LipstickSettings.lockscreenVisible === true

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Wallpaper {
        anchors.fill: root
        shade: 1
    }

    Text { 
        id: lockscreenTime
        color: "white"
        text: Qt.formatDateTime(new Date(), "HH:mm")
        font.pixelSize: 10 * Screen.pixelDensity
        font.family: "Lato"
        font.weight: Font.Lighr
        anchors { centerIn:parent }
    }

    Text { 
        id: lockscreenDate
        color: "white"
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        font.pixelSize: 3 * Screen.pixelDensity
        font.family: "Lato"
        font.weight: Font.Black
        anchors { right: lockscreenTime.right; top: lockscreenTime.bottom }
    }

    MouseArea {
        id: gestureArea
        anchors.fill: parent

        property int threshold: 25 * Screen.pixelDensity

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

            if (gesture == "up") {
                if (origY - mouseReal.y > threshold) {
                    LipstickSettings.lockscreenVisible = false;
                } 
            }
            root.opacity = 1;
            gesture = "";
        }

        onPositionChanged: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);

            if (gesture != "") {
                if (mouseReal.y < origY) {
                    gesture = "up";
                } else if (mouseReal.y > origY) {
                    gesture = "down";
                }
            } 
            
            if (gesture == "up") {
                root.opacity = 1 - (origY - mouseReal.y)/origY;
            }
        }
    }
}
