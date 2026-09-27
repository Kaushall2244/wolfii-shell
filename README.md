# 🐺 Wolfii Desktop Shell

### A modern, wallpaper-aware Liquid Glass desktop shell for Hyprland.

Wolfii is a custom Linux desktop shell built with **Quickshell 0.2.1**, **QML**, and **Hyprland**.

It combines the visual ideas of **Liquid Glass**, the fluidity of **Caelestia**, and the minimalism of **end-4**, while maintaining its own **Wolfii design language**.

> 🚧 **Wolfii is currently under active development.**
>
> Features, UI, architecture, and performance are continuously being improved.

---

## ✨ What is Wolfii?

Wolfii is not a desktop environment or a Linux distribution.

It is a **custom Wayland desktop shell** designed specifically for Hyprland.

The goal is to build a desktop experience that is:

- Modern
- Fluid
- Minimal
- Wallpaper-aware
- Highly customizable
- Hardware-aware
- Lightweight
- Native to Linux
- Designed around a consistent visual system

The shell is built from the ground up instead of modifying an existing desktop environment.

---

## 🖼️ Design Philosophy

Wolfii follows a simple idea:

> **Linux freedom with a polished, modern desktop experience.**

The visual direction is inspired by:

| Inspiration | What Wolfii takes from it |
|---|---|
| **Liquid Glass** | Layered surfaces, subtle translucency and depth |
| **Caelestia** | Fluid interactions and wallpaper-aware theming |
| **end-4** | Minimal layouts and clean visual hierarchy |
| **Hyprland** | Native Wayland integration and customization |
| **Wolfii** | Its own identity, architecture and design language |

Wolfii is **inspired by these projects, not a copy of them**.

---

# 🚀 Features

## 🪟 Liquid Glass UI

A dark, controlled glass design system built for performance.

- Controlled translucency
- Dark glass surfaces
- Subtle borders
- Soft highlights
- Layered elevation
- Rounded geometry
- Smooth hover states
- Minimal visual clutter
- No heavy blur shaders

The goal is to make the interface feel translucent without allowing the wallpaper to overpower the UI.

---

## 🎨 Wallpaper-Aware Theming

Wolfii can dynamically adapt its visual palette to the current wallpaper.

```text
Wallpaper
    ↓
Color Extraction
    ↓
Generated Palette
    ↓
Wolfii Theme
    ↓
TopBar + Panels + Settings + Controls
```

The theme controls:

- Background colors
- Glass surfaces
- Accent colors
- Text colors
- Borders
- Active workspace colors
- Hover states
- Warning states
- Interactive elements

A fallback dark theme is used when wallpaper palette data is unavailable.

### Optional palette generation

Wolfii can use **Matugen** for wallpaper-based color generation.

```bash
sudo pacman -S matugen
```

---

# 📊 TopBar

The Wolfii TopBar is designed as a unified system rather than a collection of unrelated widgets.

### Left

**Workspaces**

- 10-workspace layout
- Animated active indicator
- Smooth workspace transitions
- Wallpaper-derived active color
- Hover states

### Center

**Clock**

```text
08:04AM
```

Compact, readable and integrated into the overall layout.

### Right

**System + Status**

- CPU
- RAM
- Temperature
- Wi-Fi
- Audio
- Battery
- Wolfii identity

All TopBar components use the same dynamic theme system.

---

# 📡 Live Hardware Telemetry

Wolfii provides live system information directly inside the TopBar.

Currently supported:

- CPU usage
- RAM usage
- Temperature
- Network status
- Battery status
- Audio status

Telemetry is designed around configurable polling intervals to keep resource usage low.

---

# 🎛️ Control Center

Wolfii includes a dedicated floating Control Center.

### Connectivity

- Wi-Fi
- Bluetooth

### Audio

- Master volume
- Mute
- Output device

### Display

- Brightness
- Night-light integration where available

### System

- CPU
- RAM
- Battery
- Power actions

### Power actions

- Lock
- Logout
- Reboot
- Shutdown

Power actions use confirmation dialogs where appropriate.

---

# 📶 Network Panel

Wolfii uses **NetworkManager / nmcli** for real network information.

The Network Panel provides:

- Current connection
- Signal strength
- Available networks
- Security information
- Connected-network indicator
- Hover interaction

Example:

```text
Wi-Fi

DT-PLAYHOUSE-1
Signal 62%

Available Networks

DT-PLAYHOUSE-2       89%
DT-PLAYHOUSE-1       75%
Faaahhhh              69%
DT-PLAYHOUSE-3       54%
```

No network data is simulated.

---

# 🔊 Audio Panel

Audio controls are integrated with **PipeWire / WirePlumber**.

Features include:

- Master volume
- Mute
- Active output
- Volume slider
- Output information

---

# 🔋 Battery Panel

Battery information is read from the system.

Features include:

- Battery percentage
- Charging state
- Power state
- Battery information
- Visual status indicators

---

# 🔔 Notification Center

Wolfii includes a dedicated notification interface for:

- Notification history
- Notification entries
- Dismissal
- Floating notification presentation

---

# 🔎 Spotlight Launcher

A centered application launcher inspired by modern desktop search interfaces.

Features:

- Application search
- Desktop entry discovery
- Keyboard navigation
- Arrow-key navigation
- `Enter` to launch
- `Escape` to close

---

# ⚙️ Wolfii Settings

Wolfii includes a dedicated settings interface.

### Appearance

- Wallpaper Adaptive Theme
- Palette synchronization
- Glass density
- Corner radius
- Accent presets

Available accent presets include:

- Honey Amber
- Wolfii Lime
- Ocean Cyan
- Neon Violet
- Sunset Coral
- Frost White

### TopBar

Toggle individual modules such as:

- Workspaces
- Clock
- CPU
- RAM
- Temperature
- Wi-Fi
- Audio
- Battery
- Wolfii

### Animation

Choose between:

```text
Normal       180ms
Fast         120ms
Reduced      Instant
```

### Performance

Telemetry profiles:

```text
Performance  → 3s polling
Balanced     → 1.2s polling
Visual       → 800ms polling
```

---

# ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `SUPER + H` | Toggle TopBar |
| `SHIFT + ~` | Toggle Settings |
| `SUPER + SPACE` | Toggle Launcher |
| `SUPER + C` | Toggle Control Center |

---

# 🚀 Installation

## Requirements

Wolfii is currently developed and tested on:

- CachyOS
- Arch Linux
- Hyprland
- Wayland

### Required packages

```bash
sudo pacman -S quickshell hyprland wireplumber pipewire networkmanager brightnessctl ttf-inter ttf-jetbrains-mono
```

### Optional

For automatic wallpaper palette generation:

```bash
sudo pacman -S matugen
```

> **Note:** Package availability and versions may vary between Arch-based distributions.

---

# 📥 Clone Wolfii

Create the Quickshell configuration directory:

```bash
mkdir -p ~/.config/quickshell
```

Clone the repository:

```bash
git clone https://github.com/Kaushall2244/wolfii-shell.git ~/.config/quickshell/wolfii
```

---

# ▶️ Run Wolfii

Launch the shell manually:

```bash
quickshell -p ~/.config/quickshell/wolfii
```

If everything is configured correctly, the Wolfii shell will start on the current Hyprland session.

---

# 🔗 Hyprland Integration

## Autostart

### Lua-based Hyprland

For configurations using:

```text
~/.config/hypr/hyprland.lua
```

or a custom Lua file such as:

```text
~/.config/hypr/custom/execs.lua
```

use:

```lua
local home = os.getenv("HOME") or ""

hl.exec_once(
    "quickshell -p " .. home .. "/.config/quickshell/wolfii"
)
```

---

### Standard Hyprland configuration

For:

```text
~/.config/hypr/hyprland.conf
```

use:

```ini
exec-once = quickshell -p ~/.config/quickshell/wolfii
```

---

# ⌨️ Recommended Hyprland Keybinds

## Lua configuration

Example:

```lua
local home = os.getenv("HOME") or ""

local function wolfii_ipc(target, action)
    return "quickshell -p "
        .. home
        .. "/.config/quickshell/wolfii ipc call "
        .. target
        .. " "
        .. action
end

-- Toggle TopBar
hl.bind(
    "SUPER + H",
    hl.dsp.exec_cmd(wolfii_ipc("topbar", "toggle")),
    { description = "Wolfii: Toggle TopBar" }
)

-- Toggle Settings
hl.bind(
    "SHIFT + grave",
    hl.dsp.exec_cmd(wolfii_ipc("settings", "toggle")),
    { description = "Wolfii: Toggle Settings" }
)

-- Toggle Launcher
hl.bind(
    "SUPER + Space",
    hl.dsp.exec_cmd(wolfii_ipc("launcher", "toggle")),
    { description = "Wolfii: Toggle Launcher" }
)

-- Toggle Control Center
hl.bind(
    "SUPER + C",
    hl.dsp.exec_cmd(wolfii_ipc("controlcenter", "toggle")),
    { description = "Wolfii: Toggle Control Center" }
)
```

> **Note:** Keysyms can vary depending on keyboard layout. If `SHIFT + grave` does not work on your system, verify the actual keysym with `wev`.

---

## Standard Hyprland configuration

```ini
# Wolfii Desktop Shell

bind = SUPER, H, exec, quickshell -p ~/.config/quickshell/wolfii ipc call topbar toggle

bind = SHIFT, grave, exec, quickshell -p ~/.config/quickshell/wolfii ipc call settings toggle

bind = SUPER, SPACE, exec, quickshell -p ~/.config/quickshell/wolfii ipc call launcher toggle

bind = SUPER, C, exec, quickshell -p ~/.config/quickshell/wolfii ipc call controlcenter toggle
```

---

# 🕹️ IPC Remote Control

Wolfii exposes IPC commands that can be used from:

- Hyprland keybinds
- Shell scripts
- External tools
- Automation
- Other desktop workflows

### TopBar

```bash
quickshell -p ~/.config/quickshell/wolfii ipc call topbar toggle
```

```bash
quickshell -p ~/.config/quickshell/wolfii ipc call topbar show
```

```bash
quickshell -p ~/.config/quickshell/wolfii ipc call topbar hide
```

### Launcher

```bash
quickshell -p ~/.config/quickshell/wolfii ipc call launcher toggle
```

### Settings

```bash
quickshell -p ~/.config/quickshell/wolfii ipc call settings toggle
```

### Control Center

```bash
quickshell -p ~/.config/quickshell/wolfii ipc call controlcenter toggle
```

---

# 🏗️ Architecture

Wolfii is organized into reusable QML components and lightweight system services.

```text
~/.config/quickshell/wolfii/

├── shell.qml
├── Theme.js
│
├── components/
│   ├── GlassSurface.qml
│   ├── TopBar.qml
│   ├── Workspaces.qml
│   ├── Clock.qml
│   ├── SystemMetric.qml
│   ├── SystemStats.qml
│   ├── SystemStatus.qml
│   ├── ControlCenter.qml
│   ├── NetworkPopup.qml
│   ├── AudioPanel.qml
│   ├── BatteryPanel.qml
│   ├── NotificationCenter.qml
│   ├── Launcher.qml
│   ├── Settings.qml
│   ├── Slider.qml
│   └── AnimatedButton.qml
│
└── services/
    ├── ThemeConfig.qml
    ├── SystemData.qml
    ├── NetworkService.qml
    ├── AudioService.qml
    ├── BatteryService.qml
    └── BrightnessService.qml
```

---

# 🧩 Component Overview

| Component | Purpose |
|---|---|
| `shell.qml` | Root shell, overlays and IPC |
| `Theme.js` | Theme tokens and color system |
| `GlassSurface.qml` | Reusable glass container |
| `TopBar.qml` | Main desktop TopBar |
| `Workspaces.qml` | Hyprland workspace control |
| `Clock.qml` | Desktop clock |
| `SystemStats.qml` | Hardware telemetry |
| `SystemStatus.qml` | Network, audio and battery controls |
| `ControlCenter.qml` | System quick controls |
| `NetworkPopup.qml` | Wi-Fi interface |
| `AudioPanel.qml` | Audio controls |
| `BatteryPanel.qml` | Battery information |
| `NotificationCenter.qml` | Notification history |
| `Launcher.qml` | Application launcher |
| `Settings.qml` | Wolfii configuration |
| `ThemeConfig.qml` | Reactive theme service |
| `SystemData.qml` | CPU/RAM/temperature data |
| `NetworkService.qml` | NetworkManager integration |
| `AudioService.qml` | PipeWire integration |
| `BatteryService.qml` | Battery system interface |
| `BrightnessService.qml` | Display brightness control |

---

# 🖥️ System Requirements

| Component | Version / Requirement | Purpose |
|---|---|---|
| Linux | Modern Linux distribution | Operating system |
| Hyprland | `0.56.0+` | Wayland compositor |
| Quickshell | `0.2.1+` | Desktop shell framework |
| QtQuick | Included with Quickshell | UI framework |
| PipeWire | Required | Audio |
| WirePlumber | Required | Audio session management |
| NetworkManager | Required | Wi-Fi/network |
| `brightnessctl` | Required for brightness | Display control |
| Matugen | Optional | Wallpaper palette |
| Inter | Recommended | UI typography |
| JetBrains Mono | Recommended | Monospace typography |

### Primary development environment

```text
OS          → CachyOS
Compositor  → Hyprland
Shell       → Quickshell
UI          → QML / QtQuick
```

---

# ⚡ Performance Philosophy

Wolfii is designed with performance as a core requirement.

The shell avoids unnecessary:

- Heavy blur shaders
- Continuous expensive animations
- Extremely frequent polling
- Large background services
- Unnecessary dependencies
- Constant wallpaper processing

System telemetry uses configurable polling intervals, while wallpaper palette generation is only updated when required.

The goal is:

```text
Beautiful UI
      +
Smooth animations
      +
Low resource usage
```

---

# 🛠️ Development Status

Wolfii is currently **under construction**.

### Current development focus

- [x] Custom Quickshell foundation
- [x] Hyprland integration
- [x] Custom TopBar
- [x] Workspace switching
- [x] Animated workspace indicator
- [x] Clock
- [x] Wi-Fi detection
- [x] Network scanning
- [x] Dynamic system information
- [x] Liquid Glass design direction
- [x] Floating panel architecture
- [ ] Full wallpaper palette engine
- [ ] Complete Control Center
- [ ] Audio panel
- [ ] Battery panel
- [ ] Notification center
- [ ] Spotlight launcher
- [ ] Dedicated settings system
- [ ] Multi-monitor refinement
- [ ] Further performance optimization

> The feature list will continue to change as development progresses.

---

# 🗺️ Roadmap

### Phase 1 — Foundation

- [x] Quickshell foundation
- [x] Hyprland integration
- [x] TopBar
- [x] Workspaces
- [x] Clock
- [x] Basic system status

### Phase 2 — Visual System

- [x] Liquid Glass direction
- [ ] Dynamic wallpaper palette
- [ ] Unified theme engine
- [ ] Advanced glass surfaces
- [ ] UI animation system

### Phase 3 — Desktop Controls

- [ ] Control Center
- [ ] Audio controls
- [ ] Battery controls
- [ ] Brightness controls
- [ ] Network controls
- [ ] Notification center

### Phase 4 — Productivity

- [ ] Spotlight launcher
- [ ] Settings system
- [ ] Customizable TopBar
- [ ] Additional IPC commands
- [ ] Multi-monitor improvements

### Phase 5 — Polish

- [ ] Performance profiling
- [ ] Memory optimization
- [ ] Animation refinement
- [ ] Accessibility improvements
- [ ] Documentation
- [ ] Stable release

---

# 🔐 Design & Safety Principles

Wolfii is designed to remain a user-controlled shell.

The project aims to:

- Avoid unnecessary system modifications
- Minimize external dependencies
- Keep configuration transparent
- Avoid background processes where possible
- Prefer existing Linux utilities
- Keep components modular
- Avoid replacing the user's desktop environment

Wolfii is intended to be **a shell, not a system replacement**.

---

# 📄 License

Wolfii Desktop Shell is licensed under the **MIT License**.

See [`LICENSE`](LICENSE) for the full license text.

---

# 👤 Author

**Kaushall**

Building Wolfii as a personal exploration into:

- Linux desktop development
- Wayland
- Hyprland
- Quickshell
- QML
- UI/UX engineering
- System integration
- Performance-oriented desktop software

---

## ⭐ Project Status

**Wolfii is actively under construction.**

The project is evolving toward a complete, modern, wallpaper-aware Linux desktop shell while keeping the underlying system lightweight and customizable.

More features, experiments, and improvements are coming.