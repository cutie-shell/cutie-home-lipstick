/****************************************************************************************
**
** Copyright (C) 2019-2021 Chupligin Sergey <neochapay@gmail.com>
** Copyright (C) 2022-2022 Erik Inkinen <erik.inkinen@gmail.com>
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
import QtQuick.Controls 2.15
import Nemo.Mce 1.0

import Nemo.Configuration 1.0

Item {
    id: root
    height: 5 * Screen.pixelDensity
    width: batteryIndicator.width + percentageIndicator.width
    Button {
        id: batteryIndicator
        background: Item {}
        height: root.height
        width: root.height

        anchors {
            right: root.right
            verticalCenter: root.verticalCenter    
        }

        icon.height: height
        icon.width: height
        icon.name: "battery-"+chargeValue
        icon.color: "transparent"
        property string chargeValue: "000"

        Component.onCompleted: {
            chargeIcon();
        }

        function chargeIcon()
        {
            if(batteryChargePercentage.percent == 100) {
                batteryIndicator.chargeValue = "100"
            } else if (batteryChargePercentage.percent <= 5) {
                batteryIndicator.chargeValue = "000"
            } else if (batteryChargePercentage.percent <= 15) {
                batteryIndicator.chargeValue = "010"
            } else if (batteryChargePercentage.percent <= 25) {
                batteryIndicator.chargeValue = "020"
            } else if (batteryChargePercentage.percent <= 35) {
                batteryIndicator.chargeValue = "030"
            } else if (batteryChargePercentage.percent <= 45) {
                batteryIndicator.chargeValue = "040"
            } else if (batteryChargePercentage.percent <= 55) {
                batteryIndicator.chargeValue = "050"
            } else if (batteryChargePercentage.percent <= 65) {
                batteryIndicator.chargeValue = "060"
            } else if (batteryChargePercentage.percent <= 75) {
                batteryIndicator.chargeValue = "070"
            } else if (batteryChargePercentage.percent <= 85) {
                batteryIndicator.chargeValue = "080"
            } else {
                batteryIndicator.chargeValue = "090"
            }
            
            if (batteryChargeState.value == MceBatteryState.Charging) {
                batteryIndicator.chargeValue += "-charging";
            }
        }
    }

    Text { 
        id: percentageIndicator
        color: themeVariantConfig.value == "dark" ? "white" : "black"
        text: batteryChargePercentage.percent + " %"
        font.pixelSize: 2.5 * Screen.pixelDensity
        font.family: "Lato"
        anchors {
            right: batteryIndicator.left
            verticalCenter: root.verticalCenter    
        }
    }

    MceBatteryLevel {
        id: batteryChargePercentage

        onPercentChanged: {
            batteryIndicator.chargeIcon();
        }
    }

    MceBatteryState {
        id:  batteryChargeState

        onStateChanged: {
            batteryIndicator.chargeIcon();
        }
    }

    MceCableState{
        id: cableState
    }

    MceBatteryStatus{
        id: batteryStatus
    }

}
