import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null

    readonly property int totalWorkspaces: 10
    readonly property real itemWidth: 26
    readonly property real itemHeight: 26
    readonly property real spacing: 2

    // Active workspace from Hyprland (1-indexed)
    readonly property int currentWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

    implicitWidth: totalWorkspaces * itemWidth + (totalWorkspaces - 1) * spacing + 6
    implicitHeight: itemHeight + 4

    // Subtle recessed glass track
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Qt.rgba(0, 0, 0, 0.28)
        border.width: 1
        border.color: root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle
    }

    Item {
        anchors.centerIn: parent
        width: root.totalWorkspaces * root.itemWidth + (root.totalWorkspaces - 1) * root.spacing
        height: root.itemHeight

        // Active Indicator (glides smoothly across numbers)
        // Wallpaper-derived accent with high-contrast text
        Rectangle {
            id: activeIndicator
            width: root.itemWidth
            height: root.itemHeight
            radius: width / 2
            color: root.themeConfig ? root.themeConfig.activeWorkspace : Theme.activeWorkspace
            border.width: 1
            border.color: root.themeConfig ? root.themeConfig.borderStrong : Qt.rgba(255, 255, 255, 0.7)
            z: 0

            // Target X position based on active workspace (1-10)
            readonly property int targetIndex: Math.max(0, Math.min(root.totalWorkspaces - 1, root.currentWorkspace - 1))
            x: targetIndex * (root.itemWidth + root.spacing)
            y: 0

            // Butter smooth glide animation (180ms, Easing.OutCubic)
            Behavior on x {
                NumberAnimation {
                    duration: root.themeConfig ? Math.max(20, Math.round(180 * root.themeConfig.animSpeedFactor)) : Theme.animNormal
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animFast
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Fixed numbers row (numbers DO NOT shift)
        Row {
            id: numbersRow
            anchors.fill: parent
            spacing: root.spacing
            z: 1

            Repeater {
                model: root.totalWorkspaces

                Item {
                    id: workspaceItem
                    readonly property int wsId: index + 1
                    readonly property bool isActive: root.currentWorkspace === wsId
                    width: root.itemWidth
                    height: root.itemHeight

                    // Subtle hover glass highlight
                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: Qt.rgba(255, 255, 255, 0.10)
                        visible: mouseArea.containsMouse && !workspaceItem.isActive
                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: Theme.animMicro } }
                    }

                    Text {
                        id: wsText
                        anchors.centerIn: parent
                        text: workspaceItem.wsId.toString()
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.weight: workspaceItem.isActive ? Font.Bold : Font.DemiBold
                        color: {
                            if (workspaceItem.isActive) {
                                return root.themeConfig ? root.themeConfig.activeWorkspaceText : Theme.activeWorkspaceText;
                            }
                            if (mouseArea.containsMouse) {
                                return root.themeConfig ? root.themeConfig.text : Theme.text;
                            }
                            return root.themeConfig ? root.themeConfig.textMuted : Theme.inactiveWorkspaceText;
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.animMicro
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Hyprland.dispatch("workspace " + workspaceItem.wsId);
                        }
                    }
                }
            }
        }
    }

    // Workspace scroll wheel switching
    MouseArea {
        anchors.fill: parent
        z: -1
        acceptedButtons: Qt.NoButton
        onWheel: function(wheel) {
            if (wheel.angleDelta.y < 0) {
                Hyprland.dispatch("workspace +1");
            } else if (wheel.angleDelta.y > 0) {
                Hyprland.dispatch("workspace -1");
            }
        }
    }
}
