import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import org.nemomobile.lipstick 0.1

import "applauncher"

Drawer {
    id: root
    edge: (comp.screenOrientation == Qt.PortraitOrientation ? Qt.BottomEdge  : 
        (comp.screenOrientation == Qt.InvertedLandscapeOrientation ? Qt.RightEdge : 
        (comp.screenOrientation == Qt.InvertedPortraitOrientation ? Qt.TopEdge : Qt.LeftEdge)))
    interactive: !LipstickSettings.lockscreenVisible
    dragMargin: 2 * Screen.pixelDensity
    width: parent.width
    height: parent.height

    property Item wallpaperItem

    background: Item {
        anchors.fill: parent
        clip: true

        FastBlur {
            id: blurItem
            source: wallpaperItem
            x: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? 0 : (comp.screenOrientation == Qt.LandscapeOrientation ? 1.0 - root.position: root.position - 1.0) * Screen.width)
            y: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? (comp.screenOrientation == Qt.PortraitOrientation ? root.position - 1.0: 1.0 - root.position) * Screen.height : 0)
            width: parent.width
            height: parent.height
            radius: 64
        }

        Rectangle {
            id: dimItem
            anchors.fill: parent
            color: themeVariantConfig.value == "dark" ? "black" : "white"
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
        rotation: Screen.angleBetween(comp.screenOrientation, Screen.primaryOrientation)
        width: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? parent.width : parent.height) - 2 * Screen.pixelDensity
        height: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? parent.height : parent.width)
        transformOrigin: Item.Center
        anchors.centerIn: parent
        model: launcherModel
        cellWidth: 15 * Screen.pixelDensity
        cellHeight: 18 * Screen.pixelDensity
        delegate: Loader {
            id:loader
            width: launcherGrid.cellWidth
            height: launcherGrid.cellHeight
            property QtObject modelData : model
            property int cellIndex: index
            sourceComponent: app
        }

        Behavior on rotation {
            RotationAnimator { 
                duration: 200
                direction: RotationAnimator.Shortest
            }
        }

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        Behavior on width {
            NumberAnimation { duration: 200 }
        }

        Component {
            id:app
            LauncherItemDelegate {
                id: launcherItem
                Component.onCompleted: {
                    if(modelData) {
                        launcherItem.iconText.text = modelData.object.title;
                        if (!modelData.object.iconId.includes('/')) launcherItem.iconImage.icon.name = modelData.object.iconId;
                        if (modelData.object.iconId.includes('/')) launcherItem.iconImage.icon.source = "file://" + modelData.object.iconId;
                    }
                }
            }
        }
    }
}
