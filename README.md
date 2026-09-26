# 🐺 Wolfii Desktop Shell

A modern, high-performance **Liquid Glass desktop shell for Hyprland**, built natively with [Quickshell](https://quickshell.outfoxxed.me/).

Inspired by modern cinematic dark interfaces and Apple-grade Liquid Glass aesthetics, Wolfii provides a unified, fluid desktop experience with zero overlapping panels, real-time hardware telemetry, and deep Hyprland integration.

---

## ✨ Features

- **Liquid Glass Aesthetics**: Multi-layered frosted glass effect with wallpaper-aware backdrops, crisp inner specular highlights, and smooth spring animations.
- **Unified Multi-Monitor TopBar**:
  - **Left**: Wolfii launcher pill & dynamic Hyprland workspaces integration (with active workspace indicators and urgent status).
  - **Center**: Liquid Glass clock & calendar badge.
  - **Right**: Real-time hardware telemetry (CPU, RAM, thermals), status indicators (Wi-Fi, Audio, Battery), and quick Control Center trigger.
- **Zero-Overlap Overlay Architecture**: Only one floating panel or overlay can be open at a time. Switching panels transitions smoothly without geometry conflicts or visual clutter.
- **Spotlight-Style App Launcher**:
  - Centered modal launcher with keyboard navigation (`Arrow keys`, `Enter`, `Escape`).
  - Real-time search across all installed `.desktop` applications.
  - Quick category filters (All, Development, System, Utilities, Media, Games).
- **Wolfii Settings Suite**:
  - In-shell customization center accessible via `SHIFT + ~`.
  - Live accent color picker (Emerald, Electric Violet, Ocean Cyan, Crimson, Amber).
  - Glass opacity, corner radius, and animation speed adjustments.
  - Granular topbar module visibility toggles.
  - Performance modes (Balanced, Performance, Visual).
- **Control Center**:
  - Quick toggles for Wi-Fi, Bluetooth, Do Not Disturb, Night Light, Dark Mode, and Mute.
  - Smooth interactive sliders for master volume and display brightness.
  - Hardware monitors and quick-action shortcuts (Terminal, Settings, Lock, Power).
- **Dedicated Floating Panels**:
  - **Network Panel**: Real-time Wi-Fi scanning, signal strength bars, and password-authenticated network connection via `nmcli`.
  - **Audio Panel**: Master volume slider, mute toggle, and active audio sink selector via PipeWire.
  - **Battery Panel**: Battery percentage, charging status, health metrics, and power profile selection.
  - **Notification Center**: Notification history and quick dismissal.
- **Zero-Bloat System Monitoring**:
  - Native Linux sysfs and procfs reading (`/proc/stat`, `/proc/meminfo`, `/sys/class/hwmon`, `/sys/class/power_supply`).
  - No heavy background daemon required.

---

## 📋 Requirements

| Component | Minimum Version | Description |
|---|---|---|
| **Linux OS** | Any modern distro | Tested on CachyOS / Arch Linux |
| **Compositor** | Hyprland `0.56.0+` | Wayland compositor |
| **Shell Engine** | Quickshell `0.2.1+` | QtQuick-based Wayland desktop shell framework |
| **Audio** | PipeWire & WirePlumber | `wpctl` command-line audio control |
| **Network** | NetworkManager | `nmcli` for Wi-Fi scanning and connection |
| **Backlight** | `brightnessctl` | Display brightness adjustment |
| **Fonts** | Inter / JetBrains Mono | Recommended modern typography |

---

## 🚀 Installation

### 1. Install Dependencies

#### Arch Linux / CachyOS:
```bash
sudo pacman -S quickshell hyprland wireplumber pipewire networkmanager brightnessctl ttf-inter ttf-jetbrains-mono
```

### 2. Clone the Repository

Clone Wolfii Shell directly into your Quickshell configuration directory:

```bash
mkdir -p ~/.config/quickshell
git clone https://github.com/Kaushall2244/wolfii-shell.git ~/.config/quickshell/wolfii
```

*(Optional: If your directory is named `Wolfii-Shell`, you can symlink it to `wolfii`):*
```bash
ln -s ~/.config/quickshell/Wolfii-Shell ~/.config/quickshell/wolfii
```

### 3. Test Run the Shell

Test Wolfii directly from the command line:

```bash
quickshell -p ~/.config/quickshell/wolfii
```

---

## ⚙️ Hyprland Integration

### 1. Autostart on Login

Add Wolfii Shell to your Hyprland startup configuration:

**For Lua-based Hyprland (`~/.config/hypr/hyprland.lua` or `~/.config/hypr/custom/execs.lua`):**
```lua
local home = os.getenv("HOME") or ""
hl.exec_once("quickshell -p " .. home .. "/.config/quickshell/wolfii")
```

**For standard Hyprland (`~/.config/hypr/hyprland.conf`):**
```ini
exec-once = quickshell -p ~/.config/quickshell/wolfii
```

### 2. Recommended Keybinds

Configure keyboard shortcuts to toggle Wolfii panels:

**For Lua-based Hyprland (`~/.config/hypr/custom/keybinds.lua`):**
```lua
local home = os.getenv("HOME") or ""

-- Toggle Wolfii TopBar
hl.bind("SUPER + H", hl.dsp.exec_cmd("quickshell -p " .. home .. "/.config/quickshell/wolfii ipc call topbar toggle"), { description = "Wolfii: Toggle TopBar" })

-- Toggle Wolfii Settings (Shift + ~)
hl.bind("SHIFT + grave", hl.dsp.exec_cmd("quickshell -p " .. home .. "/.config/quickshell/wolfii ipc call settings toggle"), { description = "Wolfii: Toggle Settings" })

-- Toggle App Launcher (Super + Space)
hl.bind("SUPER + Space", hl.dsp.exec_cmd("quickshell -p " .. home .. "/.config/quickshell/wolfii ipc call launcher toggle"), { description = "Wolfii: Toggle Launcher" })

-- Toggle Control Center
hl.bind("SUPER + C", hl.dsp.exec_cmd("quickshell -p " .. home .. "/.config/quickshell/wolfii ipc call controlcenter toggle"), { description = "Wolfii: Toggle Control Center" })
```

**For standard Hyprland (`~/.config/hypr/hyprland.conf`):**
```ini
bind = SUPER, H, exec, quickshell -p ~/.config/quickshell/wolfii ipc call topbar toggle
bind = SHIFT, grave, exec, quickshell -p ~/.config/quickshell/wolfii ipc call settings toggle
bind = SUPER, SPACE, exec, quickshell -p ~/.config/quickshell/wolfii ipc call launcher toggle
bind = SUPER, C, exec, quickshell -p ~/.config/quickshell/wolfii ipc call controlcenter toggle
```

---

## 🕹️ IPC Remote Control

Wolfii provides built-in IPC endpoints for scripts, keybindings, and external tools:

```bash
# TopBar Controls
quickshell -p ~/.config/quickshell/wolfii ipc call topbar toggle
quickshell -p ~/.config/quickshell/wolfii ipc call topbar show
quickshell -p ~/.config/quickshell/wolfii ipc call topbar hide

# Overlay & Panel Controls
quickshell -p ~/.config/quickshell/wolfii ipc call launcher toggle
quickshell -p ~/.config/quickshell/wolfii ipc call settings toggle
quickshell -p ~/.config/quickshell/wolfii ipc call controlcenter toggle
```

---

## 📂 Project Structure

```
~/.config/quickshell/wolfii/
├── shell.qml               # Root entry point, layer window, and IPC handlers
├── Theme.js                # Core design tokens, color palette, radius, and curves
├── components/
│   ├── GlassSurface.qml    # Liquid Glass shader & background container
│   ├── TopBar.qml          # Main top panel with modular slots
│   ├── Workspaces.qml      # Dynamic Hyprland workspace switcher
│   ├── Clock.qml           # Clock and date display
│   ├── SystemMetric.qml    # Metric indicator chip
│   ├── SystemStats.qml     # CPU / RAM / Temp telemetry row
│   ├── SystemStatus.qml    # Network / Audio / Battery icon cluster
│   ├── Launcher.qml        # Spotlight-style fuzzy application launcher
│   ├── Settings.qml        # In-shell visual customizer and settings modal
│   ├── ControlCenter.qml   # Master quick toggles and slider hub
│   ├── NetworkPopup.qml    # Wi-Fi network manager popup
│   ├── AudioPanel.qml      # Audio output and volume panel
│   ├── BatteryPanel.qml    # Battery health and power profiles panel
│   ├── NotificationCenter.qml # Notification manager
│   ├── Slider.qml          # Smooth touch/drag slider component
│   └── AnimatedButton.qml  # Tactile micro-animated button component
└── services/
    ├── ThemeConfig.qml     # Live configurable appearance properties
    ├── SystemData.qml      # /proc and /sys telemetry collector
    ├── NetworkService.qml  # nmcli Wi-Fi wrapper
    ├── AudioService.qml    # PipeWire and wpctl audio wrapper
    ├── BatteryService.qml  # /sys/class/power_supply reader
    └── BrightnessService.qml # brightnessctl wrapper
```

---

## 🎨 Customization

Wolfii is designed to be personalized either visually or in code:

1. **Visually**: Press `SHIFT + ~` to open **Wolfii Settings**. Changes to accent color, glass opacity, corner radius, and module visibility apply immediately in real time.
2. **In Code**: Edit [`Theme.js`](./Theme.js) to configure the base color tokens, font sizes, glass blur values, and animation durations.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
