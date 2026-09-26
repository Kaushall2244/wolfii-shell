import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../Theme.js" as Theme

Item {
    id: root

    property bool isOpen: false
    signal closeRequested()

    width: 380
    height: 520
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
                        color: Theme.accent
                    }

                    Text {
                        text: "Notifications"
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: Theme.text
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
                        defaultBg: Theme.surface
                        hoverBg: Theme.surfaceHover
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
                            color: Theme.textMuted
                        }
                    }

                    // Close button
                    AnimatedButton {
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
                            color: Theme.textDim
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "No new notifications"
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            color: Theme.textMuted
                        }
                    }
                }

                delegate: Rectangle {
                    id: card
                    width: notifList.width
                    height: contentCol.implicitHeight + 20
                    radius: Theme.cardRadius
                    color: Theme.surfaceCard
                    border.width: 1
                    border.color: Theme.glassBorderSubtle

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
                                color: Theme.accent
                            }

                            // Dismiss single button
                            AnimatedButton {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                height: 20
                                cornerRadius: 10
                                defaultBg: Theme.surface
                                hoverBg: Theme.surfaceHover
                                onClicked: modelData.dismiss()
                                Text {
                                    anchors.centerIn: parent
                                    text: "✕"
                                    font.pixelSize: 9
                                    color: Theme.textMuted
                                }
                            }
                        }

                        Text {
                            text: modelData.summary || ""
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: Theme.text
                            wrapMode: Text.Wrap
                            width: parent.width
                        }

                        Text {
                            visible: modelData.body && modelData.body.length > 0
                            text: modelData.body || ""
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            color: Theme.textMuted
                            wrapMode: Text.Wrap
                            width: parent.width
                        }
                    }
                }
            }
        }
    }
}
