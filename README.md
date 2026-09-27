# 🐺 Wolfii Desktop Shell

A premium, modern **Liquid Glass desktop shell for Hyprland**, built natively with [Quickshell 0.2.1](https://quickshell.outfoxxed.me/).

Combining **Liquid Glass aesthetics**, **Caelestia fluidity**, and **end-4 minimalism**, Wolfii provides a unified, fluid desktop experience featuring zero-overlap panels, live hardware telemetry, dynamic wallpaper-aware color extraction, and deep Hyprland integration.

---

## 📑 Table of Contents (Quick Navigation)

- [🚀 Quick Installation](#-quick-installation)
  - [1. Install Dependencies](#1-install-dependencies)
  - [2. Clone the Repository](#2-clone-the-repository)
  - [3. Test Run the Shell](#3-test-run-the-shell)
- [⚙️ Hyprland Integration & Keybinds](#️-hyprland-integration--keybinds)
  - [Autostart on Login](#autostart-on-login)
  - [Recommended Keybinds](#recommended-keybinds)
- [✨ Core Features](#-core-features)
- [🎨 Dynamic Wallpaper Theming & Settings](#-dynamic-wallpaper-theming--settings)
- [🕹️ IPC Remote Control](#️-ipc-remote-control)
- [📋 System Requirements](#-system-requirements)
- [📂 Project Architecture](#-project-architecture)
- [📄 License](#-license)

---

## 🚀 Quick Installation

### 1. Install Dependencies

Wolfii Shell requires Quickshell, Hyprland, and standard Linux desktop utilities.

#### Arch Linux / CachyOS:
```bash
sudo pacman -S quickshell hyprland wireplumber pipewire networkmanager brightnessctl ttf-inter ttf-jetbrains-mono
```

*(Optional: Install `matugen` if you want automatic wallpaper palette extraction)*:
```bash
sudo pacman -S matugen
```

---

### 2. Clone the Repository

Clone Wolfii directly into your Quickshell configuration path:

```bash
mkdir -p ~/.config/quickshell
git clone https://github.com/Kaushall2244/wolfii-shell.git ~/.config/quickshell/wolfii
```

> **Note**: If you clone into `~/.config/quickshell/Wolfii-Shell`, you can create a symlink to `wolfii`:
> ```bash
> ln -s ~/.config/quickshell/Wolfii-Shell ~/.config/quickshell/wolfii
> ```

---

### 3. Test Run the Shell

Launch Wolfii directly from the command line to verify everything works:

```bash
quickshell -p ~/.config/quickshell/wolfii
```

---

## ⚙️ Hyprland Integration & Keybinds

### Autostart on Login

Add Wolfii Shell to your Hyprland startup configuration so it boots automatically:

#### For Lua-based Hyprland (`~/.config/hypr/hyprland.lua` or `~/.config/hypr/custom/execs.lua`):
```lua
local home = os.getenv("HOME") or ""
hl.exec_once("quickshell -p " .. home .. "/.config/quickshell/wolfii")
```

#### For standard Hyprland (`~/.config/hypr/hyprland.conf`):
```ini
exec-once = quickshell -p ~/.config/quickshell/wolfii
```

---

### Recommended Keybinds

Configure keyboard shortcuts to toggle the TopBar, Settings suite, Launcher, and Control Center:

#### For Lua-based Hyprland (`~/.config/hypr/custom/keybinds.lua`):
```lua
local home = os.getenv("HOME") or ""
local function wolfii_ipc(target, action)
    return "quickshell -p " .. home .. "/.config/quickshell/wolfii ipc call " .. target .. " " .. action
end

-- Toggle TopBar (Super + H)
hl.bind("SUPER + H", hl.dsp.exec_cmd(wolfii_ipc("topbar", "toggle")), { description = "Wolfii: Toggle TopBar" })

-- Toggle Settings Suite (Shift + ~)
hl.bind("SHIFT + grave", hl.dsp.exec_cmd(wolfii_ipc("settings", "toggle")), { description = "Wolfii: Toggle Settings" })

-- Toggle Spotlight App Launcher (Super + Space)
hl.bind("SUPER + Space", hl.dsp.exec_cmd(wolfii_ipc("launcher", "toggle")), { description = "Wolfii: Toggle Launcher" })

-- Toggle Control Center (Super + C)
hl.bind("SUPER + C", hl.dsp.exec_cmd(wolfii_ipc("controlcenter", "toggle")), { description = "Wolfii: Toggle Control Center" })
```

#### For standard Hyprland (`~/.config/hypr/hyprland.conf`):
```ini
# Wolfii Desktop Shell Shortcuts
bind = SUPER, H, exec, quickshell -p ~/.config/quickshell/wolfii ipc call topbar toggle
bind = SHIFT, grave, exec, quickshell -p ~/.config/quickshell/wolfii ipc call settings toggle
bind = SUPER, SPACE, exec, quickshell -p ~/.config/quickshell/wolfii ipc call launcher toggle
bind = SUPER, C, exec, quickshell -p ~/.config/quickshell/wolfii ipc call controlcenter toggle
```

---

## ✨ Core Features

- **Liquid Glass Aesthetic**:
  - Controlled dark translucency (80%–95% opacity), eliminating desktop window bleed-through while remaining deeply aware of the active wallpaper.
  - Multi-tier elevation drop shadows and 1px specular highlight sheens on all glass surfaces.
  - Zero heavy blur shaders — ultra-fast, hardware-accelerated rendering.

- **Unified Multi-Monitor TopBar**:
  - **Workspaces**: 10-workspace selector with a butter-smooth sliding active indicator (180ms cubic easing), wallpaper-derived accent fill, and high-contrast numerals.
  - **Clock**: Compact, readable `08:04AM` integrated glass pill.
  - **Live Hardware Telemetry**: Live CPU, RAM, and Temperature chips reading directly from `/proc` and `/sys` with dynamic warning/danger color thresholds.
  - **Status Cluster**: Wi-Fi status, PipeWire volume/mute, battery percentage, notifications trigger, and the interactive Wolfii monogram badge.

- **Zero-Overlap Overlay Architecture**:
  - All floating panels (Control Center, Network, Audio, Battery, Notifications) render in a dedicated layer window with independent geometry.
  - Exactly one panel is active at a time, eliminating window collision and visual clutter.
  - Ambient depth scrim with click-outside dismissal.

- **Dedicated Control Center**:
  - Quick toggles for Wi-Fi and Bluetooth with soft active backdrops (no blinding neon bricks).
  - Smooth interactive sliders for Master Volume and Display Brightness.
  - Live hardware performance glance.
  - Quick power actions (Lock, Logout, Reboot, Shutdown) with inline confirmation dialogs.

- **Spotlight-Style App Launcher**:
  - Centered modal launcher with instant search across all desktop entries.
  - Full keyboard navigation (`Arrow keys`, `Enter`, `Escape`).

- **Interactive Floating Panels**:
  - **Network Panel**: Real-time Wi-Fi scanning with signal strength bars and active connection badges via `nmcli`.
  - **Audio Panel**: Master volume slider, active audio sink detection, and mute switch via PipeWire.
  - **Battery Panel**: Charging status, accurate percentage, and power curve indicators.
  - **Notification Center**: Notification history viewer with one-click dismissal.

---

## 🎨 Dynamic Wallpaper Theming & Settings

Wolfii features a **wallpaper-aware theme engine** with live settings:

1. **Wallpaper Dynamic Palette Engine**:
   - Reactively reads Matugen color schemes from `~/.local/state/quickshell/user/generated/colors.json`, `wallpaper/path.txt`, and `color.txt`.
   - Derives cohesive dark glass surfaces, high-contrast readable text, and tasteful accent highlights automatically.
   - Built-in graceful dark fallback palette if color extraction files are unavailable.

2. **Dedicated Settings Suite (`SHIFT + ~`)**:
   - **Appearance**: Toggle Wallpaper Adaptive Theme on/off, trigger instant palette resync, customize glass density (80% to 98% opacity), adjust corner radius (8px to 24px), or select curated accent presets (Honey Amber, Wolfii Lime, Ocean Cyan, Neon Violet, Sunset Coral, Frost White).
   - **Topbar Customizer**: Granular toggles to show or hide individual topbar modules.
   - **Animation Speed**: Switch between Normal (180ms), Fast (120ms), and Reduced/Instant modes.
   - **Performance Profiles**: Select between Performance (3s poll), Balanced (1.2s poll), and Visual (800ms poll) system telemetry rates.

---

## 🕹️ IPC Remote Control

Wolfii includes built-in IPC endpoints for scripts, keybindings, and external tools:

```bash
# TopBar Controls
quickshell -p ~/.config/quickshell/wolfii ipc call topbar toggle
quickshell -p ~/.config/quickshell/wolfii ipc call topbar show
quickshell -p ~/.config/quickshell/wolfii ipc call topbar hide

# Floating Panel & Overlay Controls
quickshell -p ~/.config/quickshell/wolfii ipc call launcher toggle
quickshell -p ~/.config/quickshell/wolfii ipc call settings toggle
quickshell -p ~/.config/quickshell/wolfii ipc call controlcenter toggle
```

---

## 📋 System Requirements

| Component | Minimum Version | Purpose |
|---|---|---|
| **Linux OS** | Any modern distro | Tested on CachyOS / Arch Linux |
| **Compositor** | Hyprland `0.56.0+` | Wayland compositor |
| **Shell Engine** | Quickshell `0.2.1+` | QtQuick/QML Wayland shell framework |
| **Audio** | PipeWire & WirePlumber | `wpctl` command-line audio control |
| **Network** | NetworkManager | `nmcli` for Wi-Fi scanning and state |
| **Backlight** | `brightnessctl` | Display brightness slider control |
| **Palette (Optional)** | `matugen` | Wallpaper color scheme generation |
| **Fonts** | Inter / JetBrains Mono | Crisp UI & monospace numerals |

---

## 📂 Project Architecture

```
~/.config/quickshell/wolfii/
├── shell.qml               # Root entry point, overlay layer window, and IPC handlers
├── Theme.js                # Core tokens, color math, and palette derivation functions
├── components/
│   ├── GlassSurface.qml    # Universal Liquid Glass container with elevation & highlights
│   ├── TopBar.qml          # Main top panel with modular widget slots
│   ├── Workspaces.qml      # 10-workspace selector with gliding active indicator
│   ├── Clock.qml           # Compact clock with integrated glass chip
│   ├── SystemMetric.qml    # Metric indicator chip with glass tooltip
│   ├── SystemStats.qml     # CPU / RAM / Temp telemetry row
│   ├── SystemStatus.qml    # Wi-Fi / Audio / Battery / Wolfii icon cluster
│   ├── ControlCenter.qml   # Master quick toggles and slider hub
│   ├── NetworkPopup.qml    # Wi-Fi network manager popup
│   ├── AudioPanel.qml      # Audio output and volume panel
│   ├── BatteryPanel.qml    # Battery health and charging panel
│   ├── NotificationCenter.qml # Notification history panel
│   ├── Launcher.qml        # Spotlight-style fuzzy application launcher
│   ├── Settings.qml        # Dedicated settings and visual customization modal
│   ├── Slider.qml          # Smooth drag slider component
│   └── AnimatedButton.qml  # Tactile micro-animated button component
└── services/
    ├── ThemeConfig.qml     # Reactive wallpaper-aware theme service
    ├── SystemData.qml      # /proc and /sys telemetry collector
    ├── NetworkService.qml  # nmcli Wi-Fi wrapper
    ├── AudioService.qml    # PipeWire and wpctl audio wrapper
    ├── BatteryService.qml  # /sys/class/power_supply reader
    └── BrightnessService.qml # brightnessctl wrapper
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
