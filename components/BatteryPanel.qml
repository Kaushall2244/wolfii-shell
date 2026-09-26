import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    required property var batteryService
    property bool isOpen: false

    signal closeRequested()

    width: 300
    height: 170
    clip: true

    visible: opacity > 0.001
    opacity: isOpen ? 1.0 : 0.0
    scale: isOpen ? 1.0 : 0.97
    y: isOpen ? 0 : -8

    Behavior on opacity { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }

    GlassSurface {
        anchors.fill: parent
        level: 2
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            // Header
            Item {
                width: parent.width
                height: 24

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: root.batteryService && root.batteryService.isCharging ? "󰂄" : "󰁹"
                        font.pixelSize: 15
                        color: root.batteryService && root.batteryService.isCharging ? Theme.accent : Theme.text
                    }

                    Text {
                        text: "Battery & Power"
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Theme.text
                    }
                }

                AnimatedButton {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 24
                    height: 24
                    cornerRadius: Theme.smallRadius
                    defaultBg: Theme.surface
                    hoverBg: Theme.surfaceHover
                    onClicked: root.closeRequested()
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 10
                        color: Theme.textMuted
                    }
                }
            }

            // Battery Status Card
            Rectangle {
                width: parent.width
                height: 76
                radius: Theme.cardRadius
                color: Theme.surfaceCard
                border.width: 1
                border.color: Theme.glassBorderSubtle

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Row {
                        width: parent.width

                        Text {
                            text: root.batteryService ? root.batteryService.status : "Discharging"
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Theme.text
                        }

                        Item { width: 1; height: 1 }

                        Text {
                            anchors.right: parent.right
                            text: (root.batteryService ? root.batteryService.percentage : 100) + "%"
                            font.family: Theme.monoFontFamily
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: root.batteryService && root.batteryService.isCharging ? Theme.accent : Theme.text
                        }
                    }

                    // Progress bar
                    Rectangle {
                        width: parent.width
                        height: 6
                        radius: 3
                        color: Theme.surface
                        border.width: 1
                        border.color: Theme.glassBorderSubtle

                        Rectangle {
                            height: parent.height
                            width: parent.width * Math.max(0.01, Math.min(1.0, (root.batteryService ? root.batteryService.percentage : 100) / 100.0))
                            radius: 3
                            color: {
                                var p = root.batteryService ? root.batteryService.percentage : 100;
                                if (root.batteryService && root.batteryService.isCharging) return Theme.accent;
                                if (p <= 20) return "#ff5555";
                                if (p <= 40) return "#ffb86c";
                                return Theme.accent;
                            }
                            Behavior on width { NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic } }
                        }
                    }
                }
            }
        }
    }
}
