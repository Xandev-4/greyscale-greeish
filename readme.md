# 🍙 Niri Wayland Rice

An automated, scrollable-tiling desktop setup powered by **Niri**, **Waybar**, **Kitty**, and **Fish**, managed cleanly using a bare Git repository.

---

## ⚡ Quickstart / One-Line Deployment

Deploy the entire desktop, checkout configurations, sync the Neovim submodule, and optionally install system and AUR packages:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/dotfiles/main/.config/install.sh | bash
```

> **Note:** The script will prompt you for your AUR helper of choice (`yay` or `paru`), back up existing conflicting files to `~/.dotfiles-backup-<timestamp>`, and preview all package installations before proceeding.

---

## 🖥️ System Overview

| Component             | Software                                                                                |
| :-------------------- | :-------------------------------------------------------------------------------------- |
| **Compositor**        | [Niri](https://github.com/YaLTeR/niri) (Scrollable Tiling Wayland Compositor)           |
| **Bar / Shell**       | [Waybar](https://github.com/Alexays/Waybar)                                             |
| **Launcher**          | [Fuzzel](https://codeberg.org/dnkl/fuzzel) & [Rofi](https://github.com/davatorium/rofi) |
| **Terminal**          | [Kitty](https://sw.kovidgoyal.net/kitty/)                                               |
| **Shell & Prompt**    | [Fish](https://fishshell.com/) + [Starship](https://starship.rs/)                       |
| **Editor**            | [Neovim](https://neovim.io/) (tracked via Git Submodule)                                |
| **File Managers**     | [Yazi](https://github.com/sxyazi/yazi) (TUI) & Dolphin (GUI)                            |
| **Audio & Music**     | PipeWire / WirePlumber + `mpd` & `rmpc`                                                 |
| **Notifications**     | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)                          |
| **On-Screen Display** | [SwayOSD](https://github.com/ErikReider/SwayOSD)                                        |
| **Theming**           | [Matugen](https://github.com/InioX/matugen) (Material You Colors) + Qt6ct               |

---

## ⌨️ Key Keybindings

Modifier key: `Mod` = `Super` (Windows Key)

### Desktop & Navigation

- `Mod + Return` / `Mod + T` — Launch Terminal (`kitty`)
- `Alt + Space` — Application Launcher (`fuzzel`)
- `Mod + Q` — Close Window
- `Mod + O` — Toggle Overview
- `Mod + H / J / K / L` — Focus Column/Window (Vim directions)
- `Mod + Shift + H / J / K / L` — Move Column/Window
- `Mod + 1-9` — Switch to Workspace 1-9
- `Mod + Shift + 1-9` — Move Column to Workspace 1-9

### Applications & Utilities

- `Mod + B` — Web Browser (`zen-browser`)
- `Mod + E` — GUI File Manager (`dolphin`)
- `Mod + Y` — Terminal File Manager (`kitty yazi`)
- `Mod + R` — TUI Music Player (`kitty rmpc`)
- `Ctrl + Shift + Escape` — System Monitor (`kitty btop`)
- `Mod + V` — Clipboard History (`rofi + cliphist`)
- `Alt + C` — Color Picker (`hyprpicker`)
- `Mod + Period` — Emoji Picker (`fuzzel`)

### Audio & Brightness

- `XF86AudioRaiseVolume` / `LowerVolume` — Adjust Volume via SwayOSD
- `XF86AudioMute` / `MicMute` — Toggle Mute
- `XF86AudioPlay` / `Next` / `Prev` — Media Playback (`playerctl`)
- `XF86MonBrightnessUp` / `Down` — Display Backlight

---

## 🛠️ Dotfiles Management (`dots`)

Configs are tracked using a bare Git repository targeting `$HOME`. Untracked files are hidden by default to keep `dots status` clean.

```bash

# Check modified files

dots status

# Stage and commit changes

dots add ~/.config/waybar/
dots commit -m "style: tweak waybar padding"
dots push

# Update Neovim submodule pointer

dots add .config/nvim
dots commit -m "chore: update nvim submodule"
dots push
```
