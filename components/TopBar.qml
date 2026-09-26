import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Theme.js" as Theme

PanelWindow {
    id: root

    property var themeConfig: null
    required property var systemData
    required property var networkService
    required property var audioService
    required property var batteryService

    property bool isHidden: false

    signal toggleWifiPopup()
    signal toggleAudioPopup()
    signal toggleBatteryPopup()
    signal toggleControlCenter()
    signal toggleLauncher()
    signal toggleNotifications()

    readonly property bool barActuallyVisible: (!isHidden) && (!themeConfig || themeConfig.showTopBar)

    // Layer-shell setup
    WlrLayershell.namespace: "wolfii:topbar"
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: barActuallyVisible ? 44 : 0
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 44

    // Inner content animated container (SUPER + H toggle)
    Item {
        id: barContainer
        anchors.fill: parent
        anchors.margins: 4
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        // Section 28:
        // visible: opacity 1, y 0
        // hidden: opacity 0, y slightly above screen
        y: root.barActuallyVisible ? 0 : -50
        opacity: root.barActuallyVisible ? 1.0 : 0.0

        Behavior on y {
            NumberAnimation {
                duration: Theme.animNormal * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0)
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.animNormal * (root.themeConfig ? root.themeConfig.animSpeedFactor : 1.0)
                easing.type: Easing.OutCubic
            }
        }

        // LEVEL 1: Light Glass Topbar
        GlassSurface {
            anchors.fill: parent
            level: 1
            customRadius: root.themeConfig ? root.themeConfig.cornerRadius : Theme.radius

            // Left Section: Workspaces (10 numbers, circular gliding indicator)
            Workspaces {
                id: workspacesWidget
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
            }

            // Center Section: Clock (08:04AM format)
            Clock {
                id: clockWidget
                anchors.centerIn: parent
            }

            // Right Section: Live System Stats & Quick Indicators
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                // Outer Topbar System Stats: ◉ 33   ▣ 47   ⌁ 59°
                SystemStats {
                    id: statsWidget
                    anchors.verticalCenter: parent.verticalCenter
                    systemData: root.systemData
                    visible: !root.themeConfig || root.themeConfig.showStats
                }

                // Subtle separator
                Rectangle {
                    visible: statsWidget.visible
                    width: 1
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.glassBorderSubtle
                }

                // Wi-Fi, Audio, Battery, Wolfii identity pill
                SystemStatus {
                    id: statusWidget
                    anchors.verticalCenter: parent.verticalCenter
                    themeConfig: root.themeConfig
                    networkService: root.networkService
                    audioService: root.audioService
                    batteryService: root.batteryService

                    onToggleWifiPopup: root.toggleWifiPopup()
                    onToggleAudioPopup: root.toggleAudioPopup()
                    onToggleBatteryPopup: root.toggleBatteryPopup()
                    onToggleControlCenter: root.toggleControlCenter()
                    onToggleLauncher: root.toggleLauncher()
                    onToggleNotifications: root.toggleNotifications()
                }
            }
        }
    }
}
