import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

import org.cutieshell 1.0

import "scripts/desktop.js" as Desktop
import "statusbar"

Item {
    id: root
    width: Screen.width
    height: 5 * Screen.pixelDensity
    visible: true
    anchors {
        left: parent.left
        top: parent.top
        right: parent.right
    }

    Text { 
        id: timeIndicator
        color: themeVariantConfig.value == "dark" ? "white" : "black"
        text: Qt.formatDateTime(new Date(), "HH:mm:ss")
        font.pixelSize: 2.5 * Screen.pixelDensity
        font.family: "Lato"
        anchors {
            left: root.left
            leftMargin: 2 * Screen.pixelDensity
            verticalCenter: root.verticalCenter    
        }

        function timeChanged() {
            text = Qt.formatDateTime(new Date(), "HH:mm:ss");
        }

        Timer {
            interval: 100; running: true; repeat: true;
            onTriggered: parent.timeChanged()
        }
    }

    BatteryIndicator {
        anchors {
            right: root.right
            rightMargin: 2 * Screen.pixelDensity
            verticalCenter: root.verticalCenter    
        }
    }
}
