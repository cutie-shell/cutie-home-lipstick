/****************************************************************************************
**
** Copyright (C) 2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
** Copyright (C) 2018 Chupligin Sergey <neochapay@gmail.com>
** Copyright (C) 2022 Erik Inkinen <erik.inkinen@gmail.com>
** All rights reserved.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the author nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.15
import QtQuick.Window 2.15
import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

import "../scripts/desktop.js" as Desktop

Rectangle{
    id: volumeControlWindow

    width: Screen.width
    height: 15 * Screen.pixelDensity

    property int pressedKey
    property bool upPress
    property bool downPress

    visible: volumeControl.windowVisible

    color: themeVariantConfig.value == "dark" ? "#80000000" : "#8fffff"

    property ConfigurationValue themeVariantConfig: themeVariant
    ConfigurationValue {
        id: themeVariant
        key: "/home/cutie/theme/variant"
        defaultValue: "dark"
    }

    Rectangle{
        id: mainVolumeRow
        width: parent.width - 4 * Screen.pixelDensity
        height: 3 * Screen.pixelDensity
        color: themeVariantConfig.value == "dark" ? "black" : "white"

        anchors{
            top: volumeControlWindow.top
            topMargin: 6 * Screen.pixelDensity
            left: volumeControlWindow.left
            leftMargin: 2 * Screen.pixelDensity
        }

        Rectangle {
            id: volumeSlider
            anchors{
                top: parent.top
                left: parent.left
            }
            color: themeVariantConfig.value == "dark" ? "white" : "black"
            height: parent.height
            width: parent.width * volumeControl.volume / volumeControl.maximumVolume
        }
    }

    Text {
        id: iconText
        height: Screen.pixelDensity * 2
        width: parent.width - 4 * Screen.pixelDensity
        font.pixelSize: Screen.pixelDensity * 2
        color: themeVariantConfig.value == "dark" ? "white" : "black"
        wrapMode: Text.WordWrap
        text: volumeControl.volume == 0 ? "Muted" : "Volume: " + volumeControl.volume

        anchors {
            top: mainVolumeRow.bottom
            topMargin: Screen.pixelDensity
            left: volumeControlWindow.left
            leftMargin: 2 * Screen.pixelDensity
        }
    }

    Timer {
        id: voltimer
        interval: 2000
        onTriggered: volumeControl.windowVisible = false
    }

    Connections {
        target: volumeControl
        function onVolumeKeyPressed(key) {
            volumeControlWindow.pressedKey = key;

            volumeControl.windowVisible = true

            volumeChange()
            keyPressTimer.start()
            maxMinTimer.start()
            screenShotTimer.start()

            if (volumeControl.windowVisible) {
                voltimer.restart()
            }

            if(key == Qt.Key_VolumeUp) {
                upPress = true;
            }

            if(key == Qt.Key_VolumeDown) {
                downPress = true;
            }
        }

        function onVolumeKeyReleased(key) {
            keyPressTimer.stop()
            maxMinTimer.stop()
            screenShotTimer.stop()
            volumeControlWindow.pressedKey = ""

            if(key == Qt.Key_VolumeUp) {
                upPress = false;
            }

            if(key == Qt.Key_VolumeDown) {
                downPress = false;
            }
        }

        function onWindowVisibleChanged(windowVisible) {
            volumeControlWindow.visible = volumeControl.windowVisible;
            if (volumeControl.windowVisible) {
                voltimer.restart()
            }
        }
    }

    Timer{
        id: screenShotTimer
        interval: 2000
        onTriggered: {
            if(upPress && downPress) {
                volumeControlWindow.visible = false
                Desktop.instance.makeScreenshot();
            }
        }
    }

    Timer{
        id: keyPressTimer
        interval: 500
        onTriggered: {
            if(!upPress || !downPress) {
                volumeChange()
                voltimer.restart()
            }
        }
        repeat: true
    }

    Timer{
        id: maxMinTimer
        interval: 1900
        onTriggered: {
            if(!upPress || !downPress) {
                if(volumeControlWindow.pressedKey == Qt.Key_VolumeUp) {
                    volumeControl.volume = volumeControl.maximumVolume
                } else if(volumeControlWindow.pressedKey == Qt.Key_VolumeDown) {
                    volumeControl.volume = 0
                }
            }
        }
    }

    function volumeChange()
    {
        if(volumeControlWindow.pressedKey == Qt.Key_VolumeUp) {
            //up volume
            volumeControl.volume = volumeControl.volume+1

        } else if(volumeControlWindow.pressedKey == Qt.Key_VolumeDown) {
            volumeControl.volume = volumeControl.volume-1
        }
    }
}
