import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    property real value: 0.5 // 0.0 to 1.0
    property real minimumValue: 0.0
    property real maximumValue: 1.0
    property color trackColor: Theme.surface
    property color progressColor: Theme.accent
    property color handleColor: "#ffffff"
    property real trackHeight: 6
    property real handleSize: 14
    property bool interactive: true

    signal moved(real val)

    implicitWidth: 160
    implicitHeight: Math.max(trackHeight, handleSize) + 8

    // Background track
    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: root.trackHeight
        radius: height / 2
        color: root.trackColor
        border.width: 1
        border.color: Theme.glassBorderSubtle

        // Active fill
        Rectangle {
            id: progress
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.max(root.trackHeight, (sliderHandle.x + sliderHandle.width / 2))
            radius: root.trackHeight / 2
            color: root.progressColor

            Behavior on width {
                enabled: !mouseArea.drag.active && !mouseArea.pressed
                NumberAnimation {
                    duration: Theme.animMicro
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Draggable Liquid Glass Handle
    Rectangle {
        id: sliderHandle
        y: (root.height - height) / 2
        x: {
            var range = Math.max(0.001, root.maximumValue - root.minimumValue);
            var normalized = Math.min(1.0, Math.max(0.0, (root.value - root.minimumValue) / range));
            return normalized * (root.width - width);
        }
        width: root.handleSize
        height: root.handleSize
        radius: width / 2
        color: root.handleColor
        border.width: 1
        border.color: Qt.rgba(0, 0, 0, 0.25)

        scale: mouseArea.pressed ? 1.15 : (mouseArea.containsMouse ? 1.06 : 1.0)
        Behavior on scale {
            NumberAnimation { duration: Theme.animMicro; easing.type: Easing.OutCubic }
        }

        Behavior on x {
            enabled: !mouseArea.drag.active && !mouseArea.pressed
            NumberAnimation {
                duration: Theme.animMicro
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        function updateFromMouse(mouseX) {
            var clampedX = Math.max(0, Math.min(root.width, mouseX));
            var ratio = clampedX / (root.width || 1);
            var val = root.minimumValue + ratio * (root.maximumValue - root.minimumValue);
            val = Math.max(root.minimumValue, Math.min(root.maximumValue, val));
            root.value = val;
            root.moved(val);
        }

        onPressed: function(mouse) {
            updateFromMouse(mouse.x);
        }

        onPositionChanged: function(mouse) {
            if (pressed) {
                updateFromMouse(mouse.x);
            }
        }
    }
}
