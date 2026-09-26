import QtQuick
import Quickshell
import Quickshell.Io
import "../Theme.js" as Theme

Item {
    id: root

    required property var systemData
    required property var networkService
    required property var audioService
    required property var batteryService
    required property var brightnessService

    property bool isOpen: false
    property string confirmAction: "" // "logout", "restart", "shutdown"

    signal closeRequested()

    width: 380
    height: (root.brightnessService && root.brightnessService.hasBrightness) ? 460 : 390
    clip: true

    visible: opacity > 0.001
    opacity: isOpen ? 1.0 : 0.0
    scale: isOpen ? 1.0 : 0.96
    y: isOpen ? 0 : -10

    Behavior on opacity { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }

    GlassSurface {
        anchors.fill: parent
        level: 3
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // Header: Title + Close
            Item {
                width: parent.width
                height: 28

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Rectangle {
                        width: 24
                        height: 24
                        radius: Theme.smallRadius
                        color: Theme.surface
                        border.width: 1
                        border.color: Theme.accentGlow
                        Text {
                            anchors.centerIn: parent
                            text: "W"
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.Black
                            color: Theme.accent
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Wolfii Control Center"
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Theme.text
                    }
                }

                AnimatedButton {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 26
                    height: 26
                    cornerRadius: Theme.smallRadius
                    defaultBg: Theme.surface
                    hoverBg: Theme.surfaceHover
                    onClicked: root.closeRequested()
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 11
                        color: Theme.textMuted
                    }
                }
            }

            // Quick Toggles: Wi-Fi & Bluetooth Grid
            Grid {
                width: parent.width
                columns: 2
                spacing: 10

                // Wi-Fi Toggle Card
                AnimatedButton {
                    width: (parent.width - 10) / 2
                    height: 58
                    cornerRadius: Theme.cardRadius
                    active: root.networkService ? root.networkService.isWifiEnabled : true
                    activeColor: Theme.surfaceCard
                    activeBorderColor: root.networkService && root.networkService.isConnected ? Theme.accentGlow : Theme.glassBorderSubtle
                    defaultBg: Theme.surfaceCard
                    hoverBg: Theme.surfaceCardHover
                    onClicked: {
                        if (root.networkService) root.networkService.toggleWifi();
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Rectangle {
                            width: 36
                            height: 36
                            radius: Theme.smallRadius
                            color: root.networkService && root.networkService.isConnected ? Theme.accent : Theme.surface
                            border.width: 1
                            border.color: root.networkService && root.networkService.isConnected ? "transparent" : Theme.glassBorderSubtle
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "󰤨"
                                font.pixelSize: 16
                                color: root.networkService && root.networkService.isConnected ? "#111114" : Theme.textMuted
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            width: parent.width - 56

                            Text {
                                text: "Wi-Fi"
                                font.family: Theme.fontFamily
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                color: Theme.text
                            }
                            Text {
                                text: root.networkService && root.networkService.isConnected ? root.networkService.activeSsid : "Disconnected"
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                color: Theme.textMuted
                                elide: Text.ElideRight
                                width: parent.width
                            }
                        }
                    }
                }

                // Bluetooth Toggle Card
                AnimatedButton {
                    id: btCard
                    property bool btEnabled: true
                    width: (parent.width - 10) / 2
                    height: 58
                    cornerRadius: Theme.cardRadius
                    active: btEnabled
                    activeColor: Theme.surfaceCard
                    activeBorderColor: btEnabled ? Theme.accentGlow : Theme.glassBorderSubtle
                    defaultBg: Theme.surfaceCard
                    hoverBg: Theme.surfaceCardHover
                    onClicked: {
                        btEnabled = !btEnabled;
                        btProc.command = ["bluetoothctl", "power", btEnabled ? "on" : "off"];
                        btProc.running = false;
                        btProc.running = true;
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Rectangle {
                            width: 36
                            height: 36
                            radius: Theme.smallRadius
                            color: btCard.btEnabled ? Theme.accent : Theme.surface
                            border.width: 1
                            border.color: btCard.btEnabled ? "transparent" : Theme.glassBorderSubtle
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "󰂯"
                                font.pixelSize: 16
                                color: btCard.btEnabled ? "#111114" : Theme.textMuted
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            width: parent.width - 56

                            Text {
                                text: "Bluetooth"
                                font.family: Theme.fontFamily
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                color: Theme.text
                            }
                            Text {
                                text: btCard.btEnabled ? "Enabled" : "Disabled"
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                color: Theme.textMuted
                            }
                        }
                    }

                    Process { id: btProc }
                }
            }

            // Sliders Section
            Column {
                width: parent.width
                spacing: 8

                // Volume Card
                Rectangle {
                    width: parent.width
                    height: 60
                    radius: Theme.cardRadius
                    color: Theme.surfaceCard
                    border.width: 1
                    border.color: Theme.glassBorderSubtle

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4

                        Item {
                            width: parent.width
                            height: 16

                            Row {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 6
                                Text {
                                    text: root.audioService && root.audioService.muted ? "󰝟" : "󰕾"
                                    font.pixelSize: 12
                                    color: Theme.textMuted
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "Volume"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                    color: Theme.textMuted
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: (root.audioService ? root.audioService.volumePercent : 0) + "%"
                                font.family: Theme.monoFontFamily
                                font.pixelSize: 11
                                font.weight: Font.Bold
                                color: Theme.accent
                            }
                        }

                        Slider {
                            width: parent.width
                            value: root.audioService ? root.audioService.volume : 0.5
                            onMoved: function(val) {
                                if (root.audioService) root.audioService.setVolume(val);
                            }
                        }
                    }
                }

                // Display Brightness Card (only if supported)
                Rectangle {
                    visible: root.brightnessService && root.brightnessService.hasBrightness
                    width: parent.width
                    height: 60
                    radius: Theme.cardRadius
                    color: Theme.surfaceCard
                    border.width: 1
                    border.color: Theme.glassBorderSubtle

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4

                        Item {
                            width: parent.width
                            height: 16

                            Row {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 6
                                Text {
                                    text: "󰃠"
                                    font.pixelSize: 12
                                    color: Theme.textMuted
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "Brightness"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                    color: Theme.textMuted
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: (root.brightnessService ? root.brightnessService.percentage : 100) + "%"
                                font.family: Theme.monoFontFamily
                                font.pixelSize: 11
                                font.weight: Font.Bold
                                color: Theme.accent
                            }
                        }

                        Slider {
                            width: parent.width
                            value: root.brightnessService ? (root.brightnessService.percentage / 100.0) : 1.0
                            onMoved: function(val) {
                                if (root.brightnessService) root.brightnessService.setBrightness(Math.round(val * 100));
                            }
                        }
                    }
                }
            }

            // Live Performance Glance
            Rectangle {
                width: parent.width
                height: 44
                radius: Theme.cardRadius
                color: Theme.surfaceCard
                border.width: 1
                border.color: Theme.glassBorderSubtle

                Row {
                    anchors.centerIn: parent
                    spacing: 18

                    Row {
                        spacing: 5
                        Text { text: "◉"; font.pixelSize: 10; color: Theme.accent; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "CPU " + (root.systemData ? root.systemData.cpuUsage : 0) + "%"; font.family: Theme.monoFontFamily; font.pixelSize: 11; color: Theme.text }
                    }

                    Row {
                        spacing: 5
                        Text { text: "▣"; font.pixelSize: 10; color: Theme.accent; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "RAM " + (root.systemData ? root.systemData.ramUsage : 0) + "%"; font.family: Theme.monoFontFamily; font.pixelSize: 11; color: Theme.text }
                    }

                    Row {
                        visible: root.systemData && root.systemData.hasTemp
                        spacing: 5
                        Text { text: "⌁"; font.pixelSize: 10; color: Theme.accent; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: (root.systemData ? root.systemData.tempCelsius : 0) + "°C"; font.family: Theme.monoFontFamily; font.pixelSize: 11; color: Theme.text }
                    }
                }
            }

            // Power Actions Row / Inline Confirmation
            Item {
                width: parent.width
                height: 42

                // Normal Power Buttons
                Row {
                    anchors.fill: parent
                    spacing: 8
                    visible: root.confirmAction === ""

                    // Lock (immediate)
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: Theme.surfaceCard
                        hoverBg: Theme.surfaceCardHover
                        onClicked: {
                            lockProc.command = ["hyprlock"];
                            lockProc.running = false;
                            lockProc.running = true;
                            root.closeRequested();
                        }
                        Text { anchors.centerIn: parent; text: "󰌾"; font.pixelSize: 15; color: Theme.text }
                    }

                    // Logout
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: Theme.surfaceCard
                        hoverBg: Theme.surfaceCardHover
                        onClicked: root.confirmAction = "logout"
                        Text { anchors.centerIn: parent; text: "󰍃"; font.pixelSize: 15; color: Theme.text }
                    }

                    // Restart
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: Theme.surfaceCard
                        hoverBg: Theme.surfaceCardHover
                        onClicked: root.confirmAction = "restart"
                        Text { anchors.centerIn: parent; text: "󰑐"; font.pixelSize: 15; color: Theme.text }
                    }

                    // Shutdown
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: Qt.rgba(255/255, 85/255, 85/255, 0.16)
                        hoverBg: Qt.rgba(255/255, 85/255, 85/255, 0.28)
                        activeBorderColor: "#ff5555"
                        onClicked: root.confirmAction = "shutdown"
                        Text { anchors.centerIn: parent; text: "󰐥"; font.pixelSize: 15; color: "#ff5555" }
                    }
                }

                // Confirmation UI
                Row {
                    anchors.fill: parent
                    spacing: 8
                    visible: root.confirmAction !== ""

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Confirm " + root.confirmAction + "?"
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: Theme.text
                        width: 140
                    }

                    AnimatedButton {
                        width: 90
                        height: 36
                        cornerRadius: Theme.smallRadius
                        defaultBg: "#ff5555"
                        hoverBg: "#ff7777"
                        onClicked: {
                            if (root.confirmAction === "logout") {
                                powerProc.command = ["hyprctl", "dispatch", "exit"];
                            } else if (root.confirmAction === "restart") {
                                powerProc.command = ["systemctl", "reboot"];
                            } else if (root.confirmAction === "shutdown") {
                                powerProc.command = ["systemctl", "poweroff"];
                            }
                            powerProc.running = false;
                            powerProc.running = true;
                            root.confirmAction = "";
                        }
                        Text { anchors.centerIn: parent; text: "Confirm"; font.pixelSize: 11; font.weight: Font.Bold; color: "#ffffff" }
                    }

                    AnimatedButton {
                        width: 70
                        height: 36
                        cornerRadius: Theme.smallRadius
                        defaultBg: Theme.surface
                        hoverBg: Theme.surfaceHover
                        onClicked: root.confirmAction = ""
                        Text { anchors.centerIn: parent; text: "Cancel"; font.pixelSize: 11; color: Theme.textMuted }
                    }
                }
            }

            Process { id: lockProc }
            Process { id: powerProc }
        }
    }
}
