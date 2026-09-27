# 🧬 Hyper's Ped Menu

A simple admin ped menu for FiveM (ESX Legacy).

## Features

- **Switch ped** — Set any ped model by name
- **Reset** — Completely restores your original character (skin, clothing, face, hair, etc.)
- **Godmode** — Invulnerability on/off
- **Invisible** — Invisibility on/off
- **Heal** — Full HP + Armor
- **Berechtigungen** — For configurable groups only (default: `admin`, `superadmin`)
- **Command + Keybind** — Open via `/pedmenu` or `F7`

## Config

You can find all settings in `Config.lua`:

```lua
Config.Command       = 'pedmenu'
Config.Key           = 'F7'
Config.AllowedGroups = { 'admin', 'superadmin' }

Config.Features = {
    Godmode   = true,
    Invisible = true,
    Heal      = true,
}

Config.HealHealth = 200
Config.HealArmour = 100
```

## Controls

| Button | Action |
|---|---|
| `F7` / `/pedmenu` | Open/close menu |
| `ESC` | Close menu |
| `Enter` | Confirm Ped name |