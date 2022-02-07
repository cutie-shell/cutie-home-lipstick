import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

Item {
    id: wallpaper

    property double shade: 0.0

    ConfigurationValue {
        id: wallpaperSource
        key: "/home/cutie/homeScreen/wallpaper"
        defaultValue: "/usr/share/lipstick-cutie-home-qt5/qml/images/wallpaper.jpg"
    }

    Image {
        id: wallpaperImage
        anchors.fill: parent
        source: wallpaperSource.value
        fillMode: Image.PreserveAspectCrop
    }

    FastBlur {
        id: blurItem
        source: wallpaperImage
        anchors.fill: parent
        radius: 64
        opacity: shade
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Rectangle {
        id: dimItem
        anchors.fill: parent
        color: themeVariantConfig.value == "dark" ? "black" : "white"
        opacity: shade * 0.6
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}