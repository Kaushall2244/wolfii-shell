import QtQuick
import Quickshell
import "../Theme.js" as Theme

Item {
    id: root

    required property var themeConfig
    required property var systemData
    required property var networkService
    required property var audioService
    required property var batteryService
    required property var brightnessService

    property bool isOpen: false
    property string activeCategory: "Appearance" // "Appearance", "Topbar", "Animations", "Performance", "Network", "Audio", "Battery", "About"

    signal closeRequested()

    width: 860
    height: 560
    clip: true

    visible: opacity > 0.001
    opacity: isOpen ? 1.0 : 0.0
    scale: isOpen ? 1.0 : 0.96
    y: isOpen ? 0 : -16

    Behavior on opacity { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }

    GlassSurface {
        anchors.fill: parent
        level: 3
        clip: true

        // Main Layout: Left Sidebar + Right Content Area
        Row {
            anchors.fill: parent

            // Left Sidebar
            Rectangle {
                width: 230
                height: parent.height
                color: Qt.rgba(0, 0, 0, 0.25)
                border.width: 1
                border.color: Theme.glassBorderSubtle

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 8

                    // Settings Title & Brand
                    Row {
                        spacing: 10
                        height: 36
                        anchors.left: parent.left
                        anchors.leftMargin: 6

                        Rectangle {
                            width: 28
                            height: 28
                            radius: Theme.smallRadius
                            color: Theme.surface
                            border.width: 1
                            border.color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                anchors.centerIn: parent
                                text: "W"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Black
                                color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                            }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Wolfii Settings"
                            font.family: Theme.fontFamily
                            font.pixelSize: 15
                            font.weight: Font.Bold
                            color: Theme.text
                        }
                    }

                    // Divider
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.glassBorderSubtle
                    }

                    // Category Navigation Items
                    Column {
                        width: parent.width
                        spacing: 4

                        Repeater {
                            model: [
                                { name: "Appearance", icon: "󰏘" },
                                { name: "Shell & Topbar", icon: "󱂬" },
                                { name: "Animations", icon: "󰑮" },
                                { name: "Performance", icon: "󰓅" },
                                { name: "Network", icon: "󰤨" },
                                { name: "Audio & Sound", icon: "󰕾" },
                                { name: "Battery & Power", icon: "󰁹" },
                                { name: "About Wolfii", icon: "󰋽" }
                            ]

                            AnimatedButton {
                                id: navBtn
                                width: parent.width
                                height: 38
                                cornerRadius: Theme.smallRadius
                                readonly property bool isSelected: root.activeCategory === modelData.name
                                defaultBg: isSelected ? Qt.rgba(204/255, 255/255, 0/255, 0.14) : "transparent"
                                hoverBg: isSelected ? Qt.rgba(204/255, 255/255, 0/255, 0.22) : Theme.surfaceHover
                                active: isSelected
                                activeBorderColor: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                onClicked: root.activeCategory = modelData.name

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    spacing: 10

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.icon
                                        font.pixelSize: 15
                                        color: navBtn.isSelected ? (root.themeConfig ? root.themeConfig.accentColor : Theme.accent) : Theme.textMuted
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.name
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 12
                                        font.weight: navBtn.isSelected ? Font.Bold : Font.Medium
                                        color: navBtn.isSelected ? Theme.text : Theme.textMuted
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Right Content Area
            Item {
                width: parent.width - 230
                height: parent.height

                // Top Header bar with Close Button
                Item {
                    id: contentHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 54

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 28
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.activeCategory
                        font.family: Theme.fontFamily
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: Theme.text
                    }

                    AnimatedButton {
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        width: 28
                        height: 28
                        cornerRadius: Theme.smallRadius
                        defaultBg: Theme.surface
                        hoverBg: Theme.surfaceHover
                        onClicked: root.closeRequested()
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 12
                            color: Theme.textMuted
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1
                        color: Theme.glassBorderSubtle
                    }
                }

                // Scrollable Content
                Flickable {
                    anchors.top: contentHeader.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    contentWidth: width
                    contentHeight: contentCol.implicitHeight + 40
                    clip: true

                    Column {
                        id: contentCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 28
                        anchors.topMargin: 20
                        spacing: 16

                        // ==================== APPEARANCE ====================
                        Column {
                            visible: root.activeCategory === "Appearance"
                            width: parent.width
                            spacing: 14

                            Text {
                                text: "Theme & Accent Color"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            // Accent Color Swatches
                            Rectangle {
                                width: parent.width
                                height: 70
                                radius: Theme.cardRadius
                                color: Theme.surfaceCard
                                border.width: 1
                                border.color: Theme.glassBorderSubtle

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 16

                                    Repeater {
                                        model: [
                                            { name: "Wolfii Lime", hex: "#ccff00" },
                                            { name: "Cyan", hex: "#00e5ff" },
                                            { name: "Neon Violet", hex: "#b388ff" },
                                            { name: "Sunset Coral", hex: "#ff5252" },
                                            { name: "Pure White", hex: "#f8f8fc" }
                                        ]

                                        AnimatedButton {
                                            width: 40
                                            height: 40
                                            cornerRadius: 20
                                            defaultBg: modelData.hex
                                            hoverBg: modelData.hex
                                            active: root.themeConfig && root.themeConfig.accentColor === modelData.hex
                                            activeBorderColor: "#ffffff"
                                            onClicked: {
                                                if (root.themeConfig) root.themeConfig.setAccent(modelData.hex);
                                            }

                                            Rectangle {
                                                anchors.centerIn: parent
                                                width: 10
                                                height: 10
                                                radius: 5
                                                color: "#111116"
                                                visible: root.themeConfig && root.themeConfig.accentColor === modelData.hex
                                            }
                                        }
                                    }
                                }
                            }

                            Text {
                                text: "Liquid Glass Geometry"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            // Corner Radius Adjuster
                            Rectangle {
                                width: parent.width
                                height: 68
                                radius: Theme.cardRadius
                                color: Theme.surfaceCard
                                border.width: 1
                                border.color: Theme.glassBorderSubtle

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 6

                                    Item {
                                        width: parent.width
                                        height: 16
                                        Text {
                                            anchors.left: parent.left
                                            text: "Corner Radius"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 12
                                            color: Theme.text
                                        }
                                        Text {
                                            anchors.right: parent.right
                                            text: (root.themeConfig ? Math.round(root.themeConfig.cornerRadius) : 16) + "px"
                                            font.family: Theme.monoFontFamily
                                            font.pixelSize: 11
                                            color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                        }
                                    }

                                    Slider {
                                        width: parent.width
                                        minimumValue: 8
                                        maximumValue: 24
                                        value: root.themeConfig ? root.themeConfig.cornerRadius : 16
                                        onMoved: function(val) {
                                            if (root.themeConfig) root.themeConfig.cornerRadius = Math.round(val);
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== SHELL & TOPBAR ====================
                        Column {
                            visible: root.activeCategory === "Shell & Topbar"
                            width: parent.width
                            spacing: 12

                            Text {
                                text: "Topbar Elements Visibility"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            // Toggles list
                            Repeater {
                                model: [
                                    { title: "TopBar Visible", prop: "showTopBar", desc: "Show or hide the main desktop edge topbar" },
                                    { title: "Live System Statistics", prop: "showStats", desc: "Show outer topbar CPU, RAM, and Temperature metrics" },
                                    { title: "Wi-Fi Indicator", prop: "showWifi", desc: "Display network status and connection icon in topbar" },
                                    { title: "Audio Control Indicator", prop: "showAudio", desc: "Display speaker volume and mute status in topbar" },
                                    { title: "Battery Indicator", prop: "showBattery", desc: "Display battery percentage and charging status" },
                                    { title: "Wolfii Brand Monogram", prop: "showWolfii", desc: "Display Wolfii identity mark in topbar" }
                                ]

                                Rectangle {
                                    width: contentCol.width
                                    height: 52
                                    radius: Theme.cardRadius
                                    color: Theme.surfaceCard
                                    border.width: 1
                                    border.color: Theme.glassBorderSubtle

                                    Item {
                                        anchors.fill: parent
                                        anchors.leftMargin: 16
                                        anchors.rightMargin: 16

                                        Column {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 2
                                            Text {
                                                text: modelData.title
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 12
                                                font.weight: Font.Bold
                                                color: Theme.text
                                            }
                                            Text {
                                                text: modelData.desc
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 10
                                                color: Theme.textMuted
                                            }
                                        }

                                        // Toggle Switch
                                        AnimatedButton {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 44
                                            height: 24
                                            cornerRadius: 12
                                            readonly property bool isChecked: root.themeConfig ? root.themeConfig[modelData.prop] : true
                                            defaultBg: isChecked ? (root.themeConfig ? root.themeConfig.accentColor : Theme.accent) : Theme.surface
                                            hoverBg: isChecked ? (root.themeConfig ? root.themeConfig.accentColor : Theme.accent) : Theme.surfaceHover
                                            onClicked: {
                                                if (root.themeConfig) {
                                                    root.themeConfig[modelData.prop] = !root.themeConfig[modelData.prop];
                                                }
                                            }

                                            Rectangle {
                                                width: 18
                                                height: 18
                                                radius: 9
                                                color: parent.isChecked ? "#111116" : Theme.textMuted
                                                anchors.verticalCenter: parent.verticalCenter
                                                x: parent.isChecked ? parent.width - width - 3 : 3
                                                Behavior on x { NumberAnimation { duration: Theme.animMicro; easing.type: Easing.OutCubic } }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== ANIMATIONS ====================
                        Column {
                            visible: root.activeCategory === "Animations"
                            width: parent.width
                            spacing: 14

                            Text {
                                text: "Animation Profile & Speed"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            Row {
                                spacing: 12
                                width: parent.width

                                Repeater {
                                    model: ["Normal", "Fast", "Reduced"]

                                    AnimatedButton {
                                        width: (contentCol.width - 24) / 3
                                        height: 52
                                        cornerRadius: Theme.cardRadius
                                        readonly property bool isSelected: (modelData === "Normal" && root.themeConfig && root.themeConfig.animSpeedFactor === 1.0) ||
                                                                           (modelData === "Fast" && root.themeConfig && root.themeConfig.animSpeedFactor < 0.9 && root.themeConfig.animSpeedFactor > 0.1) ||
                                                                           (modelData === "Reduced" && root.themeConfig && root.themeConfig.animSpeedFactor < 0.1)
                                        defaultBg: isSelected ? Qt.rgba(204/255, 255/255, 0/255, 0.14) : Theme.surfaceCard
                                        hoverBg: isSelected ? Qt.rgba(204/255, 255/255, 0/255, 0.22) : Theme.surfaceCardHover
                                        active: isSelected
                                        activeBorderColor: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                        onClicked: {
                                            if (root.themeConfig) root.themeConfig.setSpeedMode(modelData);
                                        }

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 2
                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: modelData
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 13
                                                font.weight: Font.Bold
                                                color: Theme.text
                                            }
                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: modelData === "Normal" ? "180ms" : (modelData === "Fast" ? "120ms" : "Instant")
                                                font.family: Theme.monoFontFamily
                                                font.pixelSize: 10
                                                color: Theme.textMuted
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== PERFORMANCE ====================
                        Column {
                            visible: root.activeCategory === "Performance"
                            width: parent.width
                            spacing: 14

                            Text {
                                text: "Shell Performance Profile"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            Row {
                                spacing: 12
                                width: parent.width

                                Repeater {
                                    model: [
                                        { mode: "Performance", desc: "Low CPU, 3s poll" },
                                        { mode: "Balanced", desc: "Default, 1.2s poll" },
                                        { mode: "Visual", desc: "High refresh, 800ms" }
                                    ]

                                    AnimatedButton {
                                        width: (contentCol.width - 24) / 3
                                        height: 60
                                        cornerRadius: Theme.cardRadius
                                        readonly property bool isSelected: root.themeConfig && root.themeConfig.perfMode === modelData.mode
                                        defaultBg: isSelected ? Qt.rgba(204/255, 255/255, 0/255, 0.14) : Theme.surfaceCard
                                        hoverBg: isSelected ? Qt.rgba(204/255, 255/255, 0/255, 0.22) : Theme.surfaceCardHover
                                        active: isSelected
                                        activeBorderColor: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                        onClicked: {
                                            if (root.themeConfig) root.themeConfig.setPerfMode(modelData.mode);
                                        }

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 2
                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: modelData.mode
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 13
                                                font.weight: Font.Bold
                                                color: Theme.text
                                            }
                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: modelData.desc
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 10
                                                color: Theme.textMuted
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== NETWORK ====================
                        Column {
                            visible: root.activeCategory === "Network"
                            width: parent.width
                            spacing: 12

                            Text {
                                text: "Network Adapter State"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            Rectangle {
                                width: parent.width
                                height: 70
                                radius: Theme.cardRadius
                                color: Theme.surfaceCard
                                border.width: 1
                                border.color: Theme.glassBorderSubtle

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 12

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.networkService && root.networkService.isConnected ? "󰤨" : "󰤭"
                                        font.pixelSize: 22
                                        color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2
                                        Text {
                                            text: root.networkService && root.networkService.activeSsid ? root.networkService.activeSsid : "Disconnected"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 14
                                            font.weight: Font.Bold
                                            color: Theme.text
                                        }
                                        Text {
                                            text: root.networkService && root.networkService.isConnected ? "Signal strength: " + root.networkService.activeSignal + "%" : "Wi-Fi is disconnected"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 11
                                            color: Theme.textMuted
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== AUDIO & SOUND ====================
                        Column {
                            visible: root.activeCategory === "Audio & Sound"
                            width: parent.width
                            spacing: 12

                            Text {
                                text: "Audio Output State"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            Rectangle {
                                width: parent.width
                                height: 60
                                radius: Theme.cardRadius
                                color: Theme.surfaceCard
                                border.width: 1
                                border.color: Theme.glassBorderSubtle

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 12

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰓃"
                                        font.pixelSize: 18
                                        color: Theme.text
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2
                                        Text {
                                            text: root.audioService ? root.audioService.deviceName : "Default Output"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            font.weight: Font.Bold
                                            color: Theme.text
                                        }
                                        Text {
                                            text: "Volume: " + (root.audioService ? root.audioService.volumePercent : 0) + "%"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 11
                                            color: Theme.textMuted
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== BATTERY ====================
                        Column {
                            visible: root.activeCategory === "Battery & Power"
                            width: parent.width
                            spacing: 12

                            Text {
                                text: "Power Source Information"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            Rectangle {
                                width: parent.width
                                height: 60
                                radius: Theme.cardRadius
                                color: Theme.surfaceCard
                                border.width: 1
                                border.color: Theme.glassBorderSubtle

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 12

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.batteryService && root.batteryService.isCharging ? "󰂄" : "󰁹"
                                        font.pixelSize: 20
                                        color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2
                                        Text {
                                            text: root.batteryService && root.batteryService.hasBattery 
                                                ? root.batteryService.percentage + "% (" + root.batteryService.status + ")"
                                                : "AC Connected (No Battery Detected)"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            font.weight: Font.Bold
                                            color: Theme.text
                                        }
                                        Text {
                                            text: root.batteryService && root.batteryService.hasBattery ? "Healthy battery detected" : "Desktop power profile active"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 11
                                            color: Theme.textMuted
                                        }
                                    }
                                }
                            }
                        }

                        // ==================== ABOUT WOLFII ====================
                        Column {
                            visible: root.activeCategory === "About Wolfii"
                            width: parent.width
                            spacing: 12

                            Rectangle {
                                width: parent.width
                                height: 160
                                radius: Theme.cardRadius
                                color: Theme.surfaceCard
                                border.width: 1
                                border.color: Theme.glassBorderSubtle

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 8

                                    Rectangle {
                                        width: 48
                                        height: 48
                                        radius: Theme.radius
                                        color: Theme.surface
                                        border.width: 1
                                        border.color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                        anchors.horizontalCenter: parent.horizontalCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: "W"
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 22
                                            font.weight: Font.Black
                                            color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                        }
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Wolfii Desktop Shell"
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: Theme.text
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Liquid Glass Edition • Version 1.0"
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 12
                                        color: root.themeConfig ? root.themeConfig.accentColor : Theme.accent
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Hyprland 0.56.2 • Quickshell 0.2.1 • CachyOS Linux"
                                        font.family: Theme.monoFontFamily
                                        font.pixelSize: 11
                                        color: Theme.textMuted
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
