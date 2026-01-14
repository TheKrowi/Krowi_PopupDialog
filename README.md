![Midnight](https://img.shields.io/badge/Midnight-12.0.0-a335ee?style=for-the-badge) ![Retail](https://img.shields.io/badge/Retail-11.2.7-008833?style=for-the-badge) ![Mists](https://img.shields.io/badge/Mists-5.5.3-28ae7e?style=for-the-badge) ![TBC](https://img.shields.io/badge/TBC-2.5.5-62c907?style=for-the-badge) ![Classic](https://img.shields.io/badge/Classic-1.15.8-c39361?style=for-the-badge)<br>
[![CurseForge](https://img.shields.io/badge/curseforge-download-F16436?style=for-the-badge&logo=curseforge&logoColor=white)](https://www.curseforge.com/wow/addons/krowi-popup-dialog) [![Wago](https://img.shields.io/badge/Wago-Download-c1272d?style=for-the-badge)](https://addons.wago.io/addons/krowi-popup-dialog)<br>
[![Discord](https://img.shields.io/badge/discord-join-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mdBFQJYeQZ) [![PayPal](https://img.shields.io/badge/paypal-donate-002991.svg?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=9QEDV37APQ6YJ)

A reusable popup dialog library for World of Warcraft addon development that provides an easy way to display copyable external links and numeric input dialogs to players. Now with full localization support for 11 languages!

## Features

### Popup Dialog Library (`Krowi_PopupDialog_2`)
- **Copyable Link Display**: Present URLs and other text in a popup dialog with an auto-selected, easy-to-copy text field
- **Numeric Input Dialog**: Collect numeric input from users with customizable min/max ranges and validation
- **Full Localization Support**: Native translations for 11 languages (English, German, Spanish, French, Italian, Korean, Portuguese, Russian, Simplified Chinese, Traditional Chinese)
- **Simple Integration**: Single function calls for all dialog types
- **User-Friendly**: Automatically selects text for instant copying and validates numeric input
- **Lightweight**: Focused functionality without bloat
- **KROWI_LIBMAN Support**: Modern library structure for dependency management

## Usage Examples

### Basic Link Display
```lua
local PopupDialog = KROWI_LIBMAN:GetLibrary('Krowi_PopupDialog_2')
PopupDialog.ShowExternalLink("https://example.com")
```

### Numeric Input Dialog
```lua
local PopupDialog = KROWI_LIBMAN:GetLibrary('Krowi_PopupDialog_2')
PopupDialog.ShowNumericInput({
    text = "Enter a number:",
    acceptText = "Accept",
    cancelText = "Cancel",
    min = 1,
    max = 100,
    default = 50,
    callback = function(value)
        print("User entered: " .. value)
    end
})
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

-- Numeric input for settings
PopupDialog.ShowNumericInput({
    text = "Set update interval (seconds):",
    min = 5,
    max = 300,
    default = 60,
    callback = function(value)
        MyAddon.UpdateInterval = value
    end
})
```

## API Reference

### Krowi_PopupDialog_2

#### Main Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `ShowExternalLink(url)` | `url` (string) | Displays a popup dialog with the given URL in a copyable text field |
| `ShowNumericInput(options)` | `options` (table) | Displays a numeric input dialog with customizable validation |

**ShowExternalLink Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `url` | string | Yes | The URL or text to display in the copyable popup dialog |

**ShowNumericInput Options:**

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `text` | string | No | "Enter a number:" | The prompt text displayed in the dialog |
| `acceptText` | string | No | "Accept" | Text for the accept button |
| `cancelText` | string | No | "Cancel" | Text for the cancel button |
| `min` | number | No | 1 | Minimum allowed value |
| `max` | number | No | 999 | Maximum allowed value |
| `default` | number | No | `min` value | Default value displayed in the input field |
| `callback` | function | Yes | nil | Function called with the entered value when accepted |

**Behavior:**
- Opens a popup dialog window
- For link display: Displays the provided URL in an editable text field with automatic text selection
- For numeric input: Validates input to ensure it's within min/max range before calling callback
- Automatically selects all text for easy copying (Ctrl+C / Cmd+C) or editing
- Modal dialog prevents other UI interactions until closed
- Close button, Cancel button, or ESC key dismisses the dialog
- All text is automatically localized based on the player's game language

## Use Cases
- Sharing Discord server invites
- Directing users to addon download pages (CurseForge, Wago, WoWInterface)
- Providing GitHub repository or documentation links
- Displaying support or bug report URLs
- Sharing patch notes or changelog locations
- Collecting numeric configuration values from users
- Input dialogs for item counts, timeouts, or other numeric settings
- Any scenario requiring players to copy external links or enter numbers

## Requirements
- KROWI_LIBMAN