import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    property alias hovered: mouseArea.containsMouse
    property alias pressed: mouseArea.pressed
    property bool active: false
    property color activeColor: Theme.accentSoft
    property color defaultBg: Theme.surface
    property color hoverBg: Theme.surfaceHover
    property color activeBorderColor: Theme.accentGlow
    property real cornerRadius: Theme.smallRadius
    property bool enableScaleEffect: true

    signal clicked(var mouse)

    implicitWidth: 36
    implicitHeight: 36

    scale: pressed && enableScaleEffect ? 0.97 : (hovered && enableScaleEffect ? 1.015 : 1.0)
    Behavior on scale {
        NumberAnimation {
            duration: Theme.animMicro
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.active 
            ? root.activeColor 
            : (root.pressed ? Theme.surfaceActive : (root.hovered ? root.hoverBg : root.defaultBg))
        border.width: 1
        border.color: root.active 
            ? root.activeBorderColor 
            : (root.hovered ? Theme.glassBorderStrong : Theme.glassBorderSubtle)

        Behavior on color {
            ColorAnimation {
                duration: Theme.animMicro
                easing.type: Easing.OutCubic
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: Theme.animMicro
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) { root.clicked(mouse) }
    }
}
