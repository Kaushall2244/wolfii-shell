import QtQuick
import "../Theme.js" as Theme

Row {
    id: root

    property var themeConfig: null
    required property var networkService
    required property var audioService
    required property var batteryService

    signal toggleWifiPopup()
    signal toggleAudioPopup()
    signal toggleBatteryPopup()
    signal toggleControlCenter()
    signal toggleLauncher()
    signal toggleNotifications()

    spacing: 6

    // Integrated Status Cluster
    Rectangle {
        height: 28
        width: clusterRow.implicitWidth + 12
        radius: Theme.smallRadius
        color: Qt.rgba(255, 255, 255, 0.03)
        border.width: 1
        border.color: Theme.glassBorderSubtle

        Row {
            id: clusterRow
            anchors.centerIn: parent
            spacing: 2

            // Wi-Fi Button
            Item {
                visible: !root.themeConfig || root.themeConfig.showWifi
                width: 26
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: wifiMouse.containsMouse ? Theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Text {
                    anchors.centerIn: parent
                    text: root.networkService && root.networkService.isConnected ? "󰤨" : "󰤭"
                    font.pixelSize: 13
                    color: root.networkService && root.networkService.isConnected ? Theme.text : Theme.textMuted
                }

                MouseArea {
                    id: wifiMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggleWifiPopup()
                }
            }

            // Audio Button
            Item {
                visible: !root.themeConfig || root.themeConfig.showAudio
                width: 26
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: audioMouse.containsMouse ? Theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Text {
                    anchors.centerIn: parent
                    text: {
                        if (!root.audioService || root.audioService.muted) return "󰝟";
                        var vol = root.audioService.volumePercent;
                        if (vol > 60) return "󰕾";
                        if (vol > 20) return "󰖀";
                        return "󰕿";
                    }
                    font.pixelSize: 13
                    color: root.audioService && !root.audioService.muted ? Theme.text : Theme.textMuted
                }

                MouseArea {
                    id: audioMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggleAudioPopup()
                }
            }

            // Battery Button (dynamically hidden if no battery)
            Item {
                visible: (!root.themeConfig || root.themeConfig.showBattery) && (root.batteryService && root.batteryService.hasBattery)
                width: batRow.implicitWidth + 8
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: batMouse.containsMouse ? Theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Row {
                    id: batRow
                    anchors.centerIn: parent
                    spacing: 3

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.batteryService && root.batteryService.isCharging ? "󰂄" : "󰁹"
                        font.pixelSize: 12
                        color: {
                            if (!root.batteryService) return Theme.textMuted;
                            if (root.batteryService.isCharging) return root.themeConfig ? root.themeConfig.accentColor : Theme.accent;
                            if (root.batteryService.percentage <= 20) return "#ff5555";
                            return Theme.text;
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: (root.batteryService ? root.batteryService.percentage : 100).toString()
                        font.family: Theme.monoFontFamily
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        color: Theme.text
                    }
                }

                MouseArea {
                    id: batMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggleBatteryPopup()
                }
            }

            // Notifications Trigger
            Item {
                width: 26
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: notifMouse.containsMouse ? Theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    font.pixelSize: 13
                    color: Theme.text
                }

                MouseArea {
                    id: notifMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggleNotifications()
                }
            }
        }
    }

    // Refined WOLFII Brand Monogram (Toggles Control Center)
    AnimatedButton {
        id: wolfiiBtn
        visible: !root.themeConfig || root.themeConfig.showWolfii
        width: 32
        height: 28
        cornerRadius: Theme.smallRadius
        defaultBg: Theme.surface
        hoverBg: Theme.surfaceHover
        activeColor: Qt.rgba(204/255, 255/255, 0/255, 0.18)
        activeBorderColor: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
        onClicked: root.toggleControlCenter()

        Row {
            anchors.centerIn: parent
            spacing: 2

            Text {
                text: "W"
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Font.Black
                color: wolfiiBtn.hovered ? (root.themeConfig ? root.themeConfig.accentColor : Theme.accent) : Theme.text
                Behavior on color { ColorAnimation { duration: Theme.animMicro } }
            }

            Rectangle {
                width: 4
                height: 4
                radius: 2
                color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 3
            }
        }
    }
}
