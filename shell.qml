//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "Theme.js" as Theme
import "components"
import "services"

ShellRoot {
    id: shellRoot

    // Active floating panel: "" (none), "controlCenter", "network", "audio", "battery", "notifications", "launcher", "settings"
    property string activePanel: ""
    property bool topbarHidden: false

    function togglePanel(name) {
        if (activePanel === name) {
            activePanel = "";
        } else {
            activePanel = name;
        }
    }

    function closeAllPopups() {
        activePanel = "";
    }

    // Shared Service Providers
    ThemeConfig { id: themeConfig }
    SystemData { id: systemData }
    NetworkService { id: networkService }
    AudioService { id: audioService }
    BatteryService { id: batteryService }
    BrightnessService { id: brightnessService }

    // IPC handlers for external hyprland / cli dispatch
    IpcHandler {
        target: "topbar"
        function toggle() {
            shellRoot.topbarHidden = !shellRoot.topbarHidden;
        }
        function show() {
            shellRoot.topbarHidden = false;
        }
        function hide() {
            shellRoot.topbarHidden = true;
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            shellRoot.togglePanel("launcher");
        }
    }

    IpcHandler {
        target: "settings"
        function toggle() {
            shellRoot.togglePanel("settings");
        }
    }

    IpcHandler {
        target: "controlcenter"
        function toggle() {
            shellRoot.togglePanel("controlCenter");
        }
    }

    // Hyprland Global Shortcuts
    GlobalShortcut {
        name: "topbarToggle"
        description: "Wolfii: Toggle TopBar"
        onPressed: {
            shellRoot.topbarHidden = !shellRoot.topbarHidden;
        }
    }

    GlobalShortcut {
        name: "launcherToggle"
        description: "Wolfii: Toggle Launcher"
        onPressed: {
            shellRoot.togglePanel("launcher");
        }
    }

    GlobalShortcut {
        name: "settingsToggle"
        description: "Wolfii: Toggle Settings"
        onPressed: {
            shellRoot.togglePanel("settings");
        }
    }

    // TopBar for every connected monitor
    Variants {
        model: Quickshell.screens

        TopBar {
            screen: modelData
            themeConfig: themeConfig
            systemData: systemData
            networkService: networkService
            audioService: audioService
            batteryService: batteryService
            isHidden: shellRoot.topbarHidden

            onToggleWifiPopup: shellRoot.togglePanel("network")
            onToggleAudioPopup: shellRoot.togglePanel("audio")
            onToggleBatteryPopup: shellRoot.togglePanel("battery")
            onToggleControlCenter: shellRoot.togglePanel("controlCenter")
            onToggleLauncher: shellRoot.togglePanel("launcher")
            onToggleNotifications: shellRoot.togglePanel("notifications")
        }
    }

    // Overlays & Floating Panels Layer Window
    PanelWindow {
        id: overlayWindow

        visible: shellRoot.activePanel !== ""
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "wolfii:overlays"
        WlrLayershell.keyboardFocus: (shellRoot.activePanel === "launcher" || shellRoot.activePanel === "settings") 
            ? WlrKeyboardFocus.Exclusive 
            : WlrKeyboardFocus.OnDemand

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // Ambient depth scrim behind modal overlays (Settings, Launcher, Control Center)
        Rectangle {
            id: scrimBg
            anchors.fill: parent
            color: "#000000"
            opacity: (shellRoot.activePanel === "settings" || shellRoot.activePanel === "launcher") 
                ? 0.40 
                : (shellRoot.activePanel === "controlCenter" ? 0.22 : 0.0)
            Behavior on opacity { 
                NumberAnimation { 
                    duration: Theme.animPopup * themeConfig.animSpeedFactor 
                    easing.type: Easing.OutCubic 
                } 
            }
        }

        // Click outside scrim dismisses active panel
        MouseArea {
            id: dismissScrim
            anchors.fill: parent
            onClicked: shellRoot.closeAllPopups()
        }

        // ==================== CENTER OVERLAYS ====================

        // 1. App Launcher (Centered)
        Launcher {
            anchors.centerIn: parent
            isOpen: shellRoot.activePanel === "launcher"
            visible: shellRoot.activePanel === "launcher" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }

        // 2. Wolfii Settings (Centered Dedicated Window)
        Settings {
            anchors.centerIn: parent
            themeConfig: themeConfig
            systemData: systemData
            networkService: networkService
            audioService: audioService
            batteryService: batteryService
            brightnessService: brightnessService
            isOpen: shellRoot.activePanel === "settings"
            visible: shellRoot.activePanel === "settings" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }

        // ==================== TOP-RIGHT FLOATING PANELS ====================
        // Exactly one panel active at a time - zero overlapping!

        // 3. Control Center (Top-Right)
        ControlCenter {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 52
            anchors.rightMargin: 16
            systemData: systemData
            networkService: networkService
            audioService: audioService
            batteryService: batteryService
            brightnessService: brightnessService
            isOpen: shellRoot.activePanel === "controlCenter"
            visible: shellRoot.activePanel === "controlCenter" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }

        // 4. Network Popup (Top-Right)
        NetworkPopup {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 52
            anchors.rightMargin: 16
            networkService: networkService
            isOpen: shellRoot.activePanel === "network"
            visible: shellRoot.activePanel === "network" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }

        // 5. Audio Panel (Top-Right)
        AudioPanel {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 52
            anchors.rightMargin: 16
            audioService: audioService
            isOpen: shellRoot.activePanel === "audio"
            visible: shellRoot.activePanel === "audio" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }

        // 6. Battery Panel (Top-Right)
        BatteryPanel {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 52
            anchors.rightMargin: 16
            batteryService: batteryService
            isOpen: shellRoot.activePanel === "battery"
            visible: shellRoot.activePanel === "battery" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }

        // 7. Notification Center (Top-Right)
        NotificationCenter {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 52
            anchors.rightMargin: 16
            isOpen: shellRoot.activePanel === "notifications"
            visible: shellRoot.activePanel === "notifications" || opacity > 0.001
            onCloseRequested: shellRoot.closeAllPopups()
        }
    }
}
