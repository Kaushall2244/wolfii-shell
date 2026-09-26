import QtQuick
import Quickshell
import Quickshell.Io
import "../Theme.js" as Theme

Item {
    id: root

    // ========================================================================
    // 1. LIVE SEMANTIC THEME TOKENS
    // ========================================================================

    // Surfaces
    property color background: Theme.background
    property color backgroundSoft: Theme.backgroundSoft
    property color surface: Theme.surface
    property color surfaceStrong: Theme.surfaceStrong
    property color surfaceHover: Theme.surfaceHover
    property color surfacePressed: Theme.surfacePressed
    property color surfaceElevated: Theme.surfaceElevated
    property color surfaceCard: Theme.surfaceCard
    property color surfaceCardHover: Theme.surfaceCardHover

    // Glass Overlays & Opacity
    property color glassSoft: Theme.glassSoft
    property color glassMedium: Theme.glassMedium
    property color glassStrong: Theme.glassStrong
    property real glassOpacity: 0.92

    // Typography
    property color text: Theme.text
    property color textMuted: Theme.textMuted
    property color textSubtle: Theme.textSubtle

    // Dynamic Wallpaper-Aware Accent & Highlights
    property color accent: Theme.accent
    property alias accentColor: root.accent // Backwards-compatibility alias
    property color accentSoft: Theme.accentSoft
    property color accentStrong: Theme.accentStrong
    property color accentGlow: Theme.accentGlow
    property color accentHover: Theme.accentHover

    // Workspaces
    property color activeWorkspace: Theme.activeWorkspace
    property color activeWorkspaceText: Theme.activeWorkspaceText

    // Borders & Physical Specular Edge
    property color border: Theme.border
    property color borderStrong: Theme.borderStrong
    property color borderSubtle: Theme.borderSubtle
    property alias glassBorder: root.border
    property alias glassBorderStrong: root.borderStrong
    property color glassHighlight: Theme.glassHighlight

    // Semantic States
    property color success: Theme.success
    property color warning: Theme.warning
    property color danger: Theme.danger

    // Geometry & Animation
    property real cornerRadius: Theme.radius
    property real animSpeedFactor: 1.0

    // Wallpaper Information & Mode
    property bool wallpaperAware: true
    property string wallpaperPath: ""
    property string activePreset: "Wallpaper"

    // Topbar visibility toggles
    property bool showTopBar: true
    property bool showStats: true
    property bool showWifi: true
    property bool showAudio: true
    property bool showBattery: true
    property bool showWolfii: true

    // Performance Mode
    property string perfMode: "Balanced"
    property int statsInterval: 1200 // ms

    // ========================================================================
    // 2. FILE VIEWERS & LIVE WALLPAPER COLOR WATCHER
    // ========================================================================

    readonly property string _homeDir: Quickshell.env("HOME") || "/home/wolfii"
    readonly property string _colorsJsonPath: _homeDir + "/.local/state/quickshell/user/generated/colors.json"
    readonly property string _wallpaperPathFile: _homeDir + "/.local/state/quickshell/user/generated/wallpaper/path.txt"
    readonly property string _accentColorFile: _homeDir + "/.local/state/quickshell/user/generated/color.txt"

    // Watch generated Matugen colors.json
    FileView {
        id: colorsJsonFile
        path: root._colorsJsonPath
        watchChanges: true
        printErrors: false

        onLoaded: root.reloadFromColorsJson()
        onFileChanged: {
            colorsJsonFile.reload();
            root.reloadFromColorsJson();
        }
    }

    // Watch active wallpaper path
    FileView {
        id: wallpaperPathWatcher
        path: root._wallpaperPathFile
        watchChanges: true
        printErrors: false

        onLoaded: {
            var p = wallpaperPathWatcher.text().trim();
            if (p.length > 0 && p !== root.wallpaperPath) {
                root.wallpaperPath = p;
                if (root.wallpaperAware) {
                    colorsJsonFile.reload();
                    root.reloadFromColorsJson();
                }
            }
        }
        onFileChanged: {
            wallpaperPathWatcher.reload();
            var p = wallpaperPathWatcher.text().trim();
            if (p.length > 0 && p !== root.wallpaperPath) {
                root.wallpaperPath = p;
                if (root.wallpaperAware) {
                    colorsJsonFile.reload();
                    root.reloadFromColorsJson();
                }
            }
        }
    }

    // Watch single accent file fallback
    FileView {
        id: colorTxtWatcher
        path: root._accentColorFile
        watchChanges: true
        printErrors: false

        onLoaded: {
            if (!colorsJsonFile.loaded && root.wallpaperAware) {
                var hex = colorTxtWatcher.text().trim();
                if (hex.length >= 4 && hex.indexOf("#") === 0) {
                    root.applyPalette(Theme.generatePaletteFromAccent(hex));
                }
            }
        }
    }

    // Fallback extraction process in case colors.json doesn't exist for the current wallpaper
    Process {
        id: matugenFallbackProc
        command: [
            "matugen", "image",
            "--source-color-index", "0",
            "--dry-run",
            "-m", "dark",
            "--json", "hex",
            root.wallpaperPath
        ]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var parsed = JSON.parse(text);
                    if (parsed && parsed.colors) {
                        root.applyPalette(Theme.generatePaletteFromMatugen(parsed.colors));
                    }
                } catch (e) {
                    // Fail silently and retain fallback
                }
            }
        }
    }

    // ========================================================================
    // 3. COLOR APPLICATION & STATE UPDATE
    // ========================================================================

    function reloadFromColorsJson() {
        if (!root.wallpaperAware) return;

        try {
            var raw = colorsJsonFile.text();
            if (raw && raw.trim().length > 0) {
                var parsed = JSON.parse(raw);
                if (parsed && (parsed.primary || (parsed.colors && parsed.colors.primary))) {
                    var c = parsed.colors ? parsed.colors : parsed;
                    var pal = Theme.generatePaletteFromMatugen(c);
                    if (pal) {
                        root.applyPalette(pal);
                        root.activePreset = "Wallpaper";
                        return;
                    }
                }
            }
        } catch (err) {
            // Error parsing JSON, fallback to matugen process or fallback palette
        }

        // If colors.json is empty but wallpaper path is known, try fallback matugen
        if (root.wallpaperPath.length > 0 && !matugenFallbackProc.running) {
            matugenFallbackProc.running = true;
        }
    }

    function applyPalette(pal) {
        if (!pal) return;

        if (pal.background) root.background = pal.background;
        if (pal.backgroundSoft) root.backgroundSoft = pal.backgroundSoft;
        if (pal.surface) root.surface = pal.surface;
        if (pal.surfaceStrong) root.surfaceStrong = pal.surfaceStrong;
        if (pal.surfaceHover) root.surfaceHover = pal.surfaceHover;
        if (pal.surfacePressed) root.surfacePressed = pal.surfacePressed;
        if (pal.surfaceElevated) root.surfaceElevated = pal.surfaceElevated;
        if (pal.surfaceCard) root.surfaceCard = pal.surfaceCard;
        if (pal.surfaceCardHover) root.surfaceCardHover = pal.surfaceCardHover;

        if (pal.glassSoft) root.glassSoft = pal.glassSoft;
        if (pal.glassMedium) root.glassMedium = pal.glassMedium;
        if (pal.glassStrong) root.glassStrong = pal.glassStrong;

        if (pal.text) root.text = pal.text;
        if (pal.textMuted) root.textMuted = pal.textMuted;
        if (pal.textSubtle) root.textSubtle = pal.textSubtle;

        if (pal.accent) root.accent = pal.accent;
        if (pal.accentSoft) root.accentSoft = pal.accentSoft;
        if (pal.accentStrong) root.accentStrong = pal.accentStrong;
        if (pal.accentGlow) root.accentGlow = pal.accentGlow;
        if (pal.accentHover) root.accentHover = pal.accentHover;

        if (pal.activeWorkspace) root.activeWorkspace = pal.activeWorkspace;
        if (pal.activeWorkspaceText) root.activeWorkspaceText = pal.activeWorkspaceText;

        if (pal.border) root.border = pal.border;
        if (pal.borderStrong) root.borderStrong = pal.borderStrong;
        if (pal.borderSubtle) root.borderSubtle = pal.borderSubtle;

        if (pal.success) root.success = pal.success;
        if (pal.warning) root.warning = pal.warning;
        if (pal.danger) root.danger = pal.danger;
    }

    function setAccent(colorHex) {
        root.wallpaperAware = false;
        var pal = Theme.generatePaletteFromAccent(colorHex);
        if (pal) {
            root.applyPalette(pal);
        } else {
            root.accent = colorHex;
        }
    }

    function setWallpaperAware(enabled) {
        root.wallpaperAware = enabled;
        if (enabled) {
            colorsJsonFile.reload();
            root.reloadFromColorsJson();
        }
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

    // Periodic safety sync (checks every 6 seconds in case external scripts modify wallpaper files)
    Timer {
        interval: 6000
        running: true
        repeat: true
        onTriggered: {
            if (root.wallpaperAware) {
                wallpaperPathWatcher.reload();
                colorsJsonFile.reload();
                root.reloadFromColorsJson();
            }
        }
    }

    Component.onCompleted: {
        root.reloadFromColorsJson();
    }
}
