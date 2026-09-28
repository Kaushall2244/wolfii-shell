# 🐺 Wolfii Desktop Shell

> A modern, wallpaper-aware Liquid Glass desktop shell for Hyprland.

> 🚧 **Status: Under Construction**

---

## 🚀 Installation

### Requirements

- Linux
- Hyprland
- Quickshell 0.2.1+
- NetworkManager
- PipeWire / WirePlumber
- `brightnessctl`

Optional:

```bash
sudo pacman -S matugen
```

### Clone

```bash
mkdir -p ~/.config/quickshell

git clone https://github.com/Kaushall2244/wolfii-shell.git \
~/.config/quickshell/wolfii
```

### Run

```bash
quickshell -p ~/.config/quickshell/wolfii
```

---

## ✨ Features

- Liquid Glass-inspired dark UI
- Wallpaper-aware dynamic theming
- Smooth workspace animations
- Custom Hyprland TopBar
- Live CPU, RAM and temperature stats
- Wi-Fi, audio and battery controls
- Floating Control Center
- Spotlight-style application launcher
- Custom Settings interface
- Modular QML components
- Hyprland IPC integration
- Performance-focused design

---

## 🛠️ Built With

```text
Quickshell 0.2.1
QML / QtQuick
Hyprland
CachyOS / Arch Linux
PipeWire / WirePlumber
NetworkManager
Matugen
```

---

## 🎨 Theming

Wolfii uses a **wallpaper-aware theme system**.

```text
Wallpaper
   ↓
Color Palette
   ↓
Wolfii Theme
   ↓
TopBar + Panels + Controls
```

The generated palette influences the shell while keeping the interface dark, readable and glass-like.

A fallback theme is used when dynamic palette data is unavailable.

---

## ⌨️ Keybinds

| Shortcut | Action |
|---|---|
| `SUPER + H` | Toggle TopBar |
| `SHIFT + ~` | Toggle Settings |
| `SUPER + SPACE` | Launcher |
| `SUPER + C` | Control Center |

---

## 📂 Structure

```text
wolfii/
├── shell.qml
├── Theme.js
├── components/
└── services/
```

Built with reusable QML components to keep the shell modular and easy to extend.

---

## 🧪 Development

Wolfii is currently **under active development**.

The project is built as a personal exploration of:

**Linux • Wayland • Hyprland • Quickshell • QML • UI/UX**

New components, animations, theming improvements and system integrations are continuously being developed.

---

## 📜 License

MIT License

---

### 🐺 Wolfii

**Built from scratch. Designed for Linux.**
