import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null
    required property var networkService
    property bool isOpen: false

    signal closeRequested()

    width: 350
    height: 420
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
            spacing: 12

            // Header
            Item {
                width: parent.width
                height: 28

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: "󰤨"
                        font.pixelSize: 15
                        color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                    }

                    Text {
                        text: "Wi-Fi Networks"
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: root.themeConfig ? root.themeConfig.text : Theme.text
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    // Rescan button
                    AnimatedButton {
                        width: 28
                        height: 28
                        cornerRadius: Theme.smallRadius
                        defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                        onClicked: {
                            if (root.networkService) root.networkService.rescan();
                        }
                        Text {
                            anchors.centerIn: parent
                            text: "󰑐"
                            font.pixelSize: 13
                            color: root.themeConfig ? root.themeConfig.text : Theme.text
                        }
                    }

                    // Close button
                    AnimatedButton {
                        width: 28
                        height: 28
                        cornerRadius: Theme.smallRadius
                        defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                        onClicked: root.closeRequested()
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 11
                            color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                        }
                    }
                }
            }

            // Prominent Connected Network Card
            Rectangle {
                width: parent.width
                height: 56
                radius: Theme.cardRadius
                color: root.networkService && root.networkService.isConnected 
                    ? (root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard) 
                    : (root.themeConfig ? root.themeConfig.surface : Theme.surface)
                border.width: 1
                border.color: root.networkService && root.networkService.isConnected 
                    ? (root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow) 
                    : (root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle)

                Item {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12

                    Row {
                        anchors.left: parent.left
                        anchors.right: statusBadge.visible ? statusBadge.left : parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Rectangle {
                            width: 36
                            height: 36
                            radius: Theme.smallRadius
                            color: root.networkService && root.networkService.isConnected 
                                ? (root.themeConfig ? root.themeConfig.accentSoft : Theme.accentSoft) 
                                : Qt.rgba(255, 255, 255, 0.05)
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: root.networkService && root.networkService.isConnected ? "󰤨" : "󰤭"
                                font.pixelSize: 17
                                color: root.networkService && root.networkService.isConnected 
                                    ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                                    : (root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted)
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            width: parent.width - 46

                            Text {
                                text: root.networkService && root.networkService.activeSsid ? root.networkService.activeSsid : "Not Connected"
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: root.themeConfig ? root.themeConfig.text : Theme.text
                                elide: Text.ElideRight
                                width: parent.width
                            }

                            Text {
                                text: root.networkService && root.networkService.isConnected 
                                    ? "Signal " + root.networkService.activeSignal + "%" 
                                    : "Disconnected"
                                font.family: Theme.fontFamily
                                font.pixelSize: 11
                                color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                            }
                        }
                    }

                    // Connected Status Badge
                    Rectangle {
                        id: statusBadge
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        visible: root.networkService && root.networkService.isConnected
                        width: badgeRow.implicitWidth + 12
                        height: 22
                        radius: Theme.pillRadius
                        color: root.themeConfig ? root.themeConfig.accentSoft : Theme.accentSoft
                        border.width: 1
                        border.color: root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow

                        Row {
                            id: badgeRow
                            anchors.centerIn: parent
                            spacing: 4

                            Rectangle {
                                width: 5
                                height: 5
                                radius: 2.5
                                color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Connected"
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }

            // Section Label
            Item {
                width: parent.width
                height: 18

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Available Networks"
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: (root.networkService ? root.networkService.availableNetworks.length : 0) + " found"
                    font.family: Theme.monoFontFamily
                    font.pixelSize: 10
                    color: root.themeConfig ? root.themeConfig.textSubtle : Theme.textSubtle
                }
            }

            // Network List
            ListView {
                id: netList
                width: parent.width
                height: 240
                clip: true
                spacing: 6
                model: root.networkService ? root.networkService.availableNetworks : []

                // Empty state
                Item {
                    anchors.centerIn: parent
                    visible: netList.count === 0
                    width: parent.width
                    height: 100

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "󰤮"
                            font.pixelSize: 26
                            color: root.themeConfig ? root.themeConfig.textSubtle : Theme.textSubtle
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Scanning for networks..."
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                        }
                    }
                }

                delegate: AnimatedButton {
                    width: netList.width
                    height: 38
                    cornerRadius: Theme.smallRadius
                    defaultBg: modelData.inUse 
                        ? (root.themeConfig ? root.themeConfig.accentSoft : Theme.accentSoft) 
                        : (root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard)
                    hoverBg: modelData.inUse 
                        ? (root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow) 
                        : (root.themeConfig ? root.themeConfig.surfaceCardHover : Theme.surfaceCardHover)
                    active: modelData.inUse
                    activeBorderColor: root.themeConfig ? root.themeConfig.accentGlow : Theme.accentGlow
                    onClicked: {
                        if (root.networkService && !modelData.inUse) {
                            root.networkService.connectNetwork(modelData.ssid);
                        }
                    }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12

                        Row {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10
                            width: parent.width - 55

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "󰤨"
                                font.pixelSize: 14
                                color: modelData.inUse 
                                    ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                                    : (root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted)
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.ssid
                                font.family: Theme.fontFamily
                                font.pixelSize: 12
                                font.weight: modelData.inUse ? Font.Bold : Font.Normal
                                color: root.themeConfig ? root.themeConfig.text : Theme.text
                                elide: Text.ElideRight
                                width: parent.width - 30
                            }
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.signal + "%"
                            font.family: Theme.monoFontFamily
                            font.pixelSize: 11
                            color: modelData.inUse 
                                ? (root.themeConfig ? root.themeConfig.accent : Theme.accent) 
                                : (root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted)
                        }
                    }
                }
            }
        }
    }
}
