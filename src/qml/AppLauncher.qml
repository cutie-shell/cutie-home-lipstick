import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import org.nemomobile.lipstick 0.1

import "applauncher"

Drawer {
    id: root
    height: parent.height
    width: parent.width
    edge: Qt.BottomEdge
    interactive: !LipstickSettings.lockscreenVisible
    dragMargin: 5 * Screen.pixelDensity
    property Item wallpaperItem

    function close() {
        position = 0;
    }

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

    LauncherFolderModel{
        id: launcherModel

        Component.onCompleted: {
            blacklistedApplications = fileUtils.getBlacklistedApplications();
        }
    }

    GridView {
        id: launcherGrid
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        model: launcherModel
        cellWidth: 15 * Screen.pixelDensity
        cellHeight: cellWidth
        delegate: Loader {
            id:loader
            width: launcherGrid.cellWidth
            height: launcherGrid.cellHeight
            property QtObject modelData : model
            property int cellIndex: index
            sourceComponent: app
        }

        Component {
            id:app
            LauncherItemDelegate {
                id: launcherItem
                Component.onCompleted: {
                    if(modelData) {
                        launcherItem.iconText.text = modelData.object.title
                        launcherItem.iconImage.source = modelData.object.iconId == "" ? "" : (modelData.object.iconId.indexOf("/") == 0 ? "file://" : "file:///usr/share/icons/hicolor/scalable/apps/") + modelData.object.iconId + (modelData.object.iconId.indexOf("/") == 0 ? "" : ".svg")
                    }
                }
            }
        }
    }
}
