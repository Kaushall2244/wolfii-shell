import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    // Live Configurable Properties
    property color accentColor: Theme.accent
    property real glassOpacity: 0.96
    property real cornerRadius: Theme.radius
    property real animSpeedFactor: 1.0 // 1.0 = normal, 0.6 = fast, 0.0 = reduced/instant

    // Topbar visibility toggles
    property bool showTopBar: true
    property bool showStats: true
    property bool showWifi: true
    property bool showAudio: true
    property bool showBattery: true
    property bool showWolfii: true

    // Performance settings
    property string perfMode: "Balanced" // "Performance", "Balanced", "Visual"
    property int statsInterval: 1200     // ms

    function setAccent(colorHex) {
        root.accentColor = colorHex;
    }

    function setSpeedMode(mode) {
        if (mode === "Fast") {
            root.animSpeedFactor = 0.65;
        } else if (mode === "Reduced") {
            root.animSpeedFactor = 0.05;
        } else {
            root.animSpeedFactor = 1.0;
        }
    }

    function setPerfMode(mode) {
        root.perfMode = mode;
        if (mode === "Performance") {
            root.statsInterval = 3000;
        } else if (mode === "Visual") {
            root.statsInterval = 800;
        } else {
            root.statsInterval = 1200;
        }
    }
}
