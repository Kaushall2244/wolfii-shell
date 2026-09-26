import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    // Level 1 = TopBar, chip containers (Soft glass ~88% opacity)
    // Level 2 = Popups, audio, wifi, battery (Medium glass ~91% opacity)
    // Level 3 = Control center, launcher, notification center, settings (Strong glass ~95% opacity)
    property int level: 1

    // Core Liquid Glass API
    property real radius: customRadius >= 0 ? customRadius : (level === 1 ? Theme.radius : (level === 2 ? Theme.radius : Theme.largeRadius))
    property color surfaceColor: "transparent"
    property color borderColor: "transparent"
    property real glassOpacity: customOpacity !== 1.0 ? customOpacity : 1.0
    property bool hover: false
    property bool active: false
    property bool pressed: false
    property int elevation: level === 3 ? 3 : (level === 2 ? 2 : 1) // 0 = flat, 1 = subtle, 2 = popup, 3 = modal
    property bool highlight: true // Specular top edge highlight

    // Backward compatibility aliases
    property color customColor: "transparent"
    property real customOpacity: 1.0
    property color customBorderColor: "transparent"
    property real customRadius: -1

    // Elevation Drop Shadow Layer
    Rectangle {
        id: shadowLayer
        visible: root.elevation > 0
        anchors.fill: parent
        anchors.topMargin: root.elevation === 3 ? 6 : (root.elevation === 2 ? 3 : 1)
        anchors.bottomMargin: root.elevation === 3 ? -6 : (root.elevation === 2 ? -3 : -1)
        anchors.leftMargin: root.elevation === 3 ? -2 : (root.elevation === 2 ? -1 : 0)
        anchors.rightMargin: root.elevation === 3 ? -2 : (root.elevation === 2 ? -1 : 0)
        radius: root.radius + (root.elevation === 3 ? 2 : 0)
        color: "#000000"
        opacity: root.elevation === 3 ? 0.38 : (root.elevation === 2 ? 0.26 : 0.14)
        z: 0
    }

    // Main Liquid Glass Solid/Translucent Surface
    Rectangle {
        id: surfaceRect
        anchors.fill: parent
        z: 1
        radius: root.radius
        opacity: root.glassOpacity

        // Deep dark surface with controlled translucency (88% - 95% opacity)
        // Never lets desktop text or windows bleed through rawly
        color: {
            if (root.customColor !== "transparent") return root.customColor;
            if (root.surfaceColor !== "transparent") {
                if (root.pressed) return Qt.darker(root.surfaceColor, 1.15);
                if (root.hover) return Qt.lighter(root.surfaceColor, 1.12);
                return root.surfaceColor;
            }
            if (root.active) return Theme.surfaceActive;
            if (root.pressed) return Theme.surfacePressed;
            if (root.hover) return Theme.surfaceHover;
            return root.level === 1 ? Theme.glassSoft : (root.level === 2 ? Theme.glassMedium : Theme.glassStrong);
        }

        border.width: 1
        border.color: {
            if (root.customBorderColor !== "transparent") return root.customBorderColor;
            if (root.borderColor !== "transparent") return root.borderColor;
            if (root.active) return Theme.borderStrong;
            if (root.hover) return Theme.glassBorderStrong;
            return root.level === 3 ? Theme.glassBorderStrong : Theme.glassBorder;
        }

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

        // Top specular highlight line for physical liquid glass depth
        Rectangle {
            id: specularHighlight
            visible: root.highlight && root.radius > 0
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 1
            anchors.leftMargin: Math.min(root.radius, 14)
            anchors.rightMargin: Math.min(root.radius, 14)
            height: 1
            radius: 0.5
            color: Theme.glassHighlight
            opacity: root.active ? 0.85 : (root.hover ? 0.65 : 0.40)
            z: 2
        }
    }
}
