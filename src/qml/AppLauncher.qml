import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import org.nemomobile.lipstick 0.1

Drawer {
    id: root
    height: parent.height
    width: parent.width
    edge: Qt.BottomEdge
    dragMargin: 5 * Screen.pixelDensity
    property Item wallpaperItem
    background: Item {
        anchors.fill: parent
        clip: true

        FastBlur {
            id: blurItem
            source: wallpaperItem
            x: 0
            y: (root.position - 1.0) * Screen.height
            width: parent.width
            height: parent.height
            radius: 64
        }

        Rectangle {
            id: dimItem
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }
    }
}
