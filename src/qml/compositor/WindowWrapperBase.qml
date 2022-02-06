import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: wrapper

    property Item window
    property Item oMaskItem: oMask
    width: window !== null ? window.width : 0
    height: window !== null ? window.height : 0
    NumberAnimation on opacity { id: fadeInAnimation; running: false; from: 0; to: 1; duration: 200 }
    NumberAnimation on opacity { id: fadeOutAnimation; running: false; from: oMask.opacity; to: 0; duration: 200 }
    function animateIn() { fadeInAnimation.start(); }
    function animateOut() { fadeOutAnimation.start(); }

    Component.onCompleted: window.parent = wrapper

    OpacityMask {
        id: oMask
        anchors.fill: wrapper
        source: wrapper.window
        visible: false

        property int clipX: 0
        property int clipY: 0
        property int clipW: wrapper.width
        property int clipH: wrapper.height

        maskSource: Item {
            x: 0
            y: 0
            width: wrapper.width
            height: wrapper.height
            Rectangle {
                color: "black"
                x: oMask.clipX
                y: oMask.clipY
                width: oMask.clipW
                height: oMask.clipH
            }
        }
    }
}