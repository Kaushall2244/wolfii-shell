import QtQuick
import Quickshell
import Quickshell.Io
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null
    required property var systemData
    required property var networkService
    required property var audioService
    required property var batteryService
    required property var brightnessService

    property bool isOpen: false
    property string confirmAction: "" // "logout", "restart", "shutdown"

    signal closeRequested()

    width: 380
    height: (root.brightnessService && root.brightnessService.hasBrightness) ? 460 : 392
    clip: true

    visible: opacity > 0.001
    opacity: isOpen ? 1.0 : 0.0
    scale: isOpen ? 1.0 : 0.96
    y: isOpen ? 0 : -10

    Behavior on opacity { NumberAnimation { duration: Theme.animPopup * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0); easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: Theme.animPopup * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0); easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: Theme.animPopup * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0); easing.type: Easing.OutCubic } }

    GlassSurface {
        anchors.fill: parent
        level: 3
        elevation: 2
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
                        color: Qt.rgba(255, 255, 255, 0.08)
                        border.width: 1
                        border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle
                        Text {
                            anchors.centerIn: parent
                            text: "W"
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.Black
                            color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Control Center"
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: root.themeConfig ? root.themeConfig.text : Theme.text
                    }
                }

                AnimatedButton {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 26
                    height: 26
                    cornerRadius: Theme.smallRadius
                    defaultBg: Qt.rgba(255, 255, 255, 0.06)
                    hoverBg: Qt.rgba(255, 255, 255, 0.14)
                    onClicked: root.closeRequested()
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 11
                        color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
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
                    height: 60
                    cornerRadius: Theme.cardRadius
                    active: root.networkService ? root.networkService.isWifiEnabled : true
                    activeColor: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    activeBorderColor: root.networkService && root.networkService.isConnected 
                        ? (root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow) 
                        : (root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle)
                    defaultBg: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    hoverBg: root.themeConfig ? root.themeConfig.surfaceCardHover : Theme.surfaceCardHover
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
                            radius: 18
                            color: root.networkService && root.networkService.isConnected 
                                ? (root.themeConfig ? root.themeConfig.accentSoft : Theme.accentSoft) 
                                : Qt.rgba(255, 255, 255, 0.08)
                            border.width: 1
                            border.color: root.networkService && root.networkService.isConnected 
                                ? (root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow) 
                                : (root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle)
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "󰤨"
                                font.pixelSize: 16
                                color: root.networkService && root.networkService.isConnected 
                                    ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                                    : (root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted)
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
                                color: root.themeConfig ? root.themeConfig.text : Theme.text
                            }
                            Text {
                                text: root.networkService && root.networkService.isConnected ? root.networkService.activeSsid : "Disconnected"
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
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
                    height: 60
                    cornerRadius: Theme.cardRadius
                    active: btEnabled
                    activeColor: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    activeBorderColor: btEnabled 
                        ? (root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow) 
                        : (root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle)
                    defaultBg: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    hoverBg: root.themeConfig ? root.themeConfig.surfaceCardHover : Theme.surfaceCardHover
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
                            radius: 18
                            color: btCard.btEnabled 
                                ? (root.themeConfig ? root.themeConfig.accentSoft : Theme.accentSoft) 
                                : Qt.rgba(255, 255, 255, 0.08)
                            border.width: 1
                            border.color: btCard.btEnabled 
                                ? (root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow) 
                                : (root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle)
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "󰂯"
                                font.pixelSize: 16
                                color: btCard.btEnabled 
                                    ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                                    : (root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted)
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
                                color: root.themeConfig ? root.themeConfig.text : Theme.text
                            }
                            Text {
                                text: btCard.btEnabled ? "Enabled" : "Disabled"
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
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
                    color: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    border.width: 1
                    border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

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
                                    color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "Volume"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                    color: root.themeConfig ? root.themeConfig.text : Theme.text
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
                                color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                            }
                        }

                        Slider {
                            width: parent.width
                            trackColor: root.themeConfig ? root.themeConfig.surface : Theme.surface
                            progressColor: root.themeConfig ? root.themeConfig.accent : Theme.accent
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
                    color: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    border.width: 1
                    border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

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
                                    color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "Brightness"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                    color: root.themeConfig ? root.themeConfig.text : Theme.text
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
                                color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                            }
                        }

                        Slider {
                            width: parent.width
                            trackColor: root.themeConfig ? root.themeConfig.surface : Theme.surface
                            progressColor: root.themeConfig ? root.themeConfig.accent : Theme.accent
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
                color: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                border.width: 1
                border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                Row {
                    anchors.centerIn: parent
                    spacing: 18

                    Row {
                        spacing: 5
                        Text { text: "◉"; font.pixelSize: 10; color: root.themeConfig ? root.themeConfig.accent : Theme.accent; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "CPU " + (root.systemData ? root.systemData.cpuUsage : 0) + "%"; font.family: Theme.monoFontFamily; font.pixelSize: 11; font.weight: Font.Bold; color: root.themeConfig ? root.themeConfig.text : Theme.text }
                    }

                    Row {
                        spacing: 5
                        Text { text: "◉"; font.pixelSize: 10; color: root.themeConfig ? root.themeConfig.accent : Theme.accent; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "RAM " + (root.systemData ? root.systemData.ramUsage : 0) + "%"; font.family: Theme.monoFontFamily; font.pixelSize: 11; font.weight: Font.Bold; color: root.themeConfig ? root.themeConfig.text : Theme.text }
                    }

                    Row {
                        visible: root.systemData && root.systemData.hasTemp && root.systemData.tempCelsius > 0
                        spacing: 5
                        Text { text: "◉"; font.pixelSize: 10; color: root.themeConfig ? root.themeConfig.accent : Theme.accent; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: (root.systemData ? root.systemData.tempCelsius : 0) + "°C"; font.family: Theme.monoFontFamily; font.pixelSize: 11; font.weight: Font.Bold; color: root.themeConfig ? root.themeConfig.text : Theme.text }
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
                        defaultBg: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceCardHover : Theme.surfaceCardHover
                        onClicked: {
                            lockProc.command = ["hyprlock"];
                            lockProc.running = false;
                            lockProc.running = true;
                            root.closeRequested();
                        }
                        Text { anchors.centerIn: parent; text: "󰌾"; font.pixelSize: 15; color: root.themeConfig ? root.themeConfig.text : Theme.text }
                    }

                    // Logout
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceCardHover : Theme.surfaceCardHover
                        onClicked: root.confirmAction = "logout"
                        Text { anchors.centerIn: parent; text: "󰍃"; font.pixelSize: 15; color: root.themeConfig ? root.themeConfig.text : Theme.text }
                    }

                    // Restart
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceCardHover : Theme.surfaceCardHover
                        onClicked: root.confirmAction = "restart"
                        Text { anchors.centerIn: parent; text: "󰑐"; font.pixelSize: 15; color: root.themeConfig ? root.themeConfig.text : Theme.text }
                    }

                    // Shutdown
                    AnimatedButton {
                        width: (parent.width - 24) / 4
                        height: 40
                        cornerRadius: Theme.smallRadius
                        defaultBg: Qt.rgba(248/255, 113/255, 113/255, 0.16)
                        hoverBg: Qt.rgba(248/255, 113/255, 113/255, 0.28)
                        activeBorderColor: root.themeConfig ? root.themeConfig.danger : Theme.danger
                        onClicked: root.confirmAction = "shutdown"
                        Text { anchors.centerIn: parent; text: "󰐥"; font.pixelSize: 15; color: root.themeConfig ? root.themeConfig.danger : Theme.danger }
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
                        color: root.themeConfig ? root.themeConfig.text : Theme.text
                        width: 140
                    }

                    AnimatedButton {
                        width: 90
                        height: 36
                        cornerRadius: Theme.smallRadius
                        defaultBg: root.themeConfig ? root.themeConfig.danger : Theme.danger
                        hoverBg: Qt.lighter(root.themeConfig ? root.themeConfig.danger : Theme.danger, 1.15)
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
                        defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                        onClicked: root.confirmAction = ""
                        Text { anchors.centerIn: parent; text: "Cancel"; font.pixelSize: 11; color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted }
                    }
                }
            }

            Process { id: lockProc }
            Process { id: powerProc }
        }
    }
}
