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
        width: clusterRow.implicitWidth + 8
        radius: Theme.smallRadius
        color: Qt.rgba(0, 0, 0, 0.25)
        border.width: 1
        border.color: Theme.glassBorder

        Row {
            id: clusterRow
            anchors.centerIn: parent
            spacing: 2

            // Wi-Fi Button
            Item {
                visible: !root.themeConfig || root.themeConfig.showWifi
                width: 28
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: wifiMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : (root.networkService && root.networkService.isConnected ? Qt.rgba(255, 255, 255, 0.04) : "transparent")
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Text {
                    anchors.centerIn: parent
                    text: root.networkService && root.networkService.isConnected ? "󰤨" : "󰤭"
                    font.pixelSize: 13
                    color: root.networkService && root.networkService.isConnected ? "#ffffff" : Theme.textMuted
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
                width: 28
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: audioMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent"
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
                    color: root.audioService && !root.audioService.muted ? "#ffffff" : Theme.textMuted
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
                width: batRow.implicitWidth + 10
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: batMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Row {
                    id: batRow
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.batteryService && root.batteryService.isCharging ? "󰂄" : "󰁹"
                        font.pixelSize: 12
                        color: {
                            if (!root.batteryService) return Theme.textMuted;
                            if (root.batteryService.isCharging) return root.themeConfig ? root.themeConfig.accentColor : Theme.accent;
                            if (root.batteryService.percentage <= 20) return "#ff5555";
                            return "#ffffff";
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: (root.batteryService ? root.batteryService.percentage : 100).toString()
                        font.family: Theme.monoFontFamily
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: "#ffffff"
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
                width: 28
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: notifMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animMicro } }
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    font.pixelSize: 13
                    color: "#ffffff"
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
        width: 36
        height: 28
        cornerRadius: Theme.smallRadius
        defaultBg: Qt.rgba(255, 255, 255, 0.08)
        hoverBg: Qt.rgba(255, 255, 255, 0.16)
        activeColor: Qt.rgba(204/255, 255/255, 0/255, 0.22)
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
                color: wolfiiBtn.hovered ? (root.themeConfig ? root.themeConfig.accentColor : Theme.accent) : "#ffffff"
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
