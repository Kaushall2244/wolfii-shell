import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null
    property bool isOpen: false
    signal closeRequested()

    width: 380
    height: 520
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
                        text: "󰂚"
                        font.pixelSize: 16
                        color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                    }

                    Text {
                        text: "Notifications"
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: root.themeConfig ? root.themeConfig.text : Theme.text
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    // Clear all button
                    AnimatedButton {
                        visible: NotificationServer.trackedNotifications.values.length > 0
                        width: 70
                        height: 26
                        cornerRadius: Theme.smallRadius
                        defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                        hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                        onClicked: {
                            var notifs = NotificationServer.trackedNotifications.values;
                            for (var i = 0; i < notifs.length; i++) {
                                notifs[i].dismiss();
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Clear All"
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                        }
                    }

                    // Close button
                    AnimatedButton {
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
            }

            // Notification List
            ListView {
                id: notifList
                width: parent.width
                height: 430
                clip: true
                spacing: 8
                model: NotificationServer.trackedNotifications.values

                // Empty state
                Item {
                    anchors.centerIn: parent
                    visible: notifList.count === 0
                    width: parent.width
                    height: 140

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "󰂛"
                            font.pixelSize: 36
                            color: root.themeConfig ? root.themeConfig.textSubtle : Theme.textSubtle
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "No new notifications"
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                        }
                    }
                }

                delegate: Rectangle {
                    id: card
                    width: notifList.width
                    height: contentCol.implicitHeight + 20
                    radius: Theme.cardRadius
                    color: root.themeConfig ? root.themeConfig.surfaceCard : Theme.surfaceCard
                    border.width: 1
                    border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle

                    Column {
                        id: contentCol
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 6

                        Item {
                            width: parent.width
                            height: 20

                            Text {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.appName || "System"
                                font.family: Theme.fontFamily
                                font.pixelSize: 11
                                font.weight: Font.Bold
                                color: root.themeConfig ? root.themeConfig.accent : Theme.accent
                            }

                            // Dismiss single button
                            AnimatedButton {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                height: 20
                                cornerRadius: 10
                                defaultBg: root.themeConfig ? root.themeConfig.surface : Theme.surface
                                hoverBg: root.themeConfig ? root.themeConfig.surfaceHover : Theme.surfaceHover
                                onClicked: modelData.dismiss()
                                Text {
                                    anchors.centerIn: parent
                                    text: "✕"
                                    font.pixelSize: 9
                                    color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                                }
                            }
                        }

                        Text {
                            text: modelData.summary || ""
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: root.themeConfig ? root.themeConfig.text : Theme.text
                            wrapMode: Text.Wrap
                            width: parent.width
                        }

                        Text {
                            visible: modelData.body && modelData.body.length > 0
                            text: modelData.body || ""
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            color: root.themeConfig ? root.themeConfig.textMuted : Theme.textMuted
                            wrapMode: Text.Wrap
                            width: parent.width
                        }
                    }
                }
            }
        }
    }
}
