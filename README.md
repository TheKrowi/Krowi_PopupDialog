![Retail](https://img.shields.io/badge/Retail-11.2.7-008833?style=for-the-badge) ![Mists](https://img.shields.io/badge/Mists-5.5.3-28ae7e?style=for-the-badge) ![Classic](https://img.shields.io/badge/Classic-1.15.8-c39361?style=for-the-badge)<br>
[![CurseForge](https://img.shields.io/badge/curseforge-download-F16436?style=for-the-badge&logo=curseforge&logoColor=white)](https://www.curseforge.com/wow/addons/krowi-popup-dialog) [![Wago](https://img.shields.io/badge/Wago-Download-c1272d?style=for-the-badge)](https://addons.wago.io/addons/krowi-popup-dialog)<br>
[![Discord](https://img.shields.io/badge/discord-join-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mdBFQJYeQZ) [![PayPal](https://img.shields.io/badge/paypal-donate-002991.svg?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=9QEDV37APQ6YJ)

A reusable popup dialog library for World of Warcraft addon development that provides an easy way to display copyable external links to players.

## Features

### Popup Dialog Library (`Krowi_PopupDialog-1.0`)
- **Copyable Link Display**: Present URLs and other text in a popup dialog with an auto-selected, easy-to-copy text field
- **Simple Integration**: Single function call to display links
- **User-Friendly**: Automatically selects text for instant copying
- **Lightweight**: Focused functionality without bloat
- **LibStub Support**: Standard LibStub library structure for dependency management

## Usage Examples

### Basic Link Display
```lua
local PopupDialog = LibStub("Krowi_PopupDialog-1.0")
PopupDialog.ShowExternalLink("https://example.com")
```

### Common Use Cases
```lua
-- Discord invite link
PopupDialog.ShowExternalLink("https://discord.gg/your-server")

-- CurseForge addon page
PopupDialog.ShowExternalLink("https://www.curseforge.com/wow/addons/your-addon")

-- Wago.io page
PopupDialog.ShowExternalLink("https://addons.wago.io/addons/your-addon")

-- WoWInterface page
PopupDialog.ShowExternalLink("https://www.wowinterface.com/downloads/info12345")

-- Documentation or support page
PopupDialog.ShowExternalLink("https://github.com/username/addon/wiki")
```

## API Reference

### Krowi_PopupDialog-1.0

#### Main Function

| Function | Parameters | Description |
|----------|------------|-------------|
| `ShowExternalLink(url)` | `url` (string) | Displays a popup dialog with the given URL in a copyable text field |

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `url` | string | Yes | The URL or text to display in the copyable popup dialog |

**Behavior:**
- Opens a popup dialog window
- Displays the provided URL in an editable text field
- Automatically selects all text for easy copying (Ctrl+C / Cmd+C)
- Modal dialog prevents other UI interactions until closed
- Close button or ESC key dismisses the dialog

## Use Cases
- Sharing Discord server invites
- Directing users to addon download pages (CurseForge, Wago, WoWInterface)
- Providing GitHub repository or documentation links
- Displaying support or bug report URLs
- Sharing patch notes or changelog locations
- Any scenario requiring players to copy external links

## Requirements
- LibStub