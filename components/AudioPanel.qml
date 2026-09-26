import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null
    required property var audioService
    property bool isOpen: false

    signal closeRequested()

    width: 340
    height: 200
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
                height: 28

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: "󰕾"
                        font.pixelSize: 15
                        color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                    }

                    Text {
                        text: "Sound & Volume"
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
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

            // Output Device Card
            Rectangle {
                width: parent.width
                height: 52
                radius: Theme.cardRadius
                color: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                border.width: 1
                border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Rectangle {
                        width: 34
                        height: 34
                        radius: Theme.smallRadius
                        color: Qt.rgba(255, 255, 255, 0.05)
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "󰓃"
                            font.pixelSize: 16
                            color: root.themeConfig ? root.themeConfig.text : Theme.text
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 92

                        Text {
                            text: "Output Device"
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                            color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                        }

                        Text {
                            text: root.audioService ? root.audioService.deviceName : "Default Output"
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                            color: root.themeConfig ? root.themeConfig.text : Theme.text
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

                    // Mute Button
                    AnimatedButton {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 34
                        height: 34
                        cornerRadius: Theme.smallRadius
                        active: root.audioService ? root.audioService.muted : false
                        activeColor: Qt.rgba(248/255, 113/255, 113/255, 0.2)
                        activeBorderColor: root.themeConfig ? root.themeConfig.danger : Theme.danger
                        defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                        onClicked: {
                            if (root.audioService) root.audioService.toggleMute();
                        }

                        Text {
                            anchors.centerIn: parent
                            text: root.audioService && root.audioService.muted ? "󰝟" : "󰕾"
                            font.pixelSize: 14
                            color: root.audioService && root.audioService.muted 
                                ? (root.themeConfig ? root.themeConfig.danger : Theme.danger) 
                                : (root.themeConfig ? root.themeConfig.text : Theme.text)
                        }
                    }
                }
            }

            // Volume Control Section
            Column {
                width: parent.width
                spacing: 8

                Item {
                    width: parent.width
                    height: 18

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Master Volume"
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: (root.audioService ? root.audioService.volumePercent : 0) + "%"
                        font.family: Theme.monoFontFamily
                        font.pixelSize: 12
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
    }
}
