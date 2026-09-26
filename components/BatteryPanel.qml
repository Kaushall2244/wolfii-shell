import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null
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

    Behavior on opacity { NumberAnimation { duration: Theme.animPopup * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0); easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: Theme.animPopup * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0); easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: Theme.animPopup * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0); easing.type: Easing.OutCubic } }

    GlassSurface {
        anchors.fill: parent
        level: 2
        elevation: 2
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
                        color: root.batteryService && root.batteryService.isCharging 
                            ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                            : (root.themeConfig ? root.themeConfig.text : Theme.text)
                    }

                    Text {
                        text: "Battery & Power"
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: root.themeConfig ? root.themeConfig.text : Theme.text
                    }
                }

                AnimatedButton {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 24
                    height: 24
                    cornerRadius: Theme.smallRadius
                    defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                    hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                    onClicked: root.closeRequested()
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 10
                        color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                    }
                }
            }

            // Battery Status Card
            Rectangle {
                width: parent.width
                height: 76
                radius: Theme.cardRadius
                color: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                border.width: 1
                border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Item {
                        width: parent.width
                        height: 20

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.batteryService ? root.batteryService.status : "Discharging"
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: root.themeConfig ? root.themeConfig.text : Theme.text
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: (root.batteryService ? root.batteryService.percentage : 100) + "%"
                            font.family: Theme.monoFontFamily
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: root.batteryService && root.batteryService.isCharging 
                                ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                                : (root.themeConfig ? root.themeConfig.text : Theme.text)
                        }
                    }

                    // Progress bar
                    Rectangle {
                        width: parent.width
                        height: 6
                        radius: 3
                        color: root.themeConfig ? root.themeConfig.surface : Theme.surface
                        border.width: 1
                        border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                        Rectangle {
                            height: parent.height
                            width: parent.width * Math.max(0.01, Math.min(1.0, (root.batteryService ? root.batteryService.percentage : 100) / 100.0))
                            radius: 3
                            color: {
                                var p = root.batteryService ? root.batteryService.percentage : 100;
                                if (root.batteryService && root.batteryService.isCharging) return root.themeConfig ? root.themeConfig.accent : Theme.accent;
                                if (p <= 20) return root.themeConfig ? root.themeConfig.danger : Theme.danger;
                                if (p <= 40) return root.themeConfig ? root.themeConfig.warning : Theme.warning;
                                return root.themeConfig ? root.themeConfig.accent : Theme.accent;
                            }
                            Behavior on width { NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic } }
                        }
                    }
                }
            }
        }
    }
}
