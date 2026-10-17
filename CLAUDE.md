# CLAUDE.md

Krowi_PopupDialog (`Krowi_PopupDialog_2`) is a World of Warcraft library in Lua 5.1 that Krowi's addons embed for two Blizzard `StaticPopup` dialogs: a copyable link (`ShowExternalLink`) and a number input (`ShowNumericInput`). The workspace-wide rules (tooling traps, the game loop, taint, LibStub minors, git, release safety) load from `../../CLAUDE.md` and `Krowi_ClaudeKit/WowAddons.md`; this file adds only what is specific to this repo.

There is no build, lint or test step: a consumer addon in the game is the test harness. The `krowi` plugin (enabled in `.claude/settings.json`) syntax-checks every edited `.lua` with Lua 5.1 and guards the known tooling traps. The repo is public, but the settings point at the private kit by absolute path, so the plugin loads only on Krowi's machine; that is intended.

## Clients and loading

- `Krowi_PopupDialog.toc` loads `Krowi_PopupDialog.xml`, which loads `Krowi_PopupDialog.lua` and then `Localization\Files.xml` (enUS, the ten other locales, `Shared.lua` last). No saved variables, no declared dependencies.
- `## Interface: 120000, 110207, 50503, 20505, 11508` is behind the live clients (12.1.5, 5.5.4, 2.5.6, 1.15.9). It only matters for a standalone install, the README badges and the upload's game versions; update it at the next release.
- It needs `KROWI_LIBMAN` (Krowi_Util's `LibMan.lua`), LibStub and AceLocale loaded first; every consumer includes `Krowi_Util.xml` first in its `Libs/Files.xml`.
- One code path for every client: Retail and all Classic clients share the rewritten `Blizzard_StaticPopup` (dialog frames with `EditBox` and `ButtonContainer.Button1`). The `editBox or EditBox` and `button1 or ButtonContainer.Button1` lookups also cover the old frame layout.

## Versioning

- One LibStub entry: `KROWI_LIBMAN:NewLibrary('Krowi_PopupDialog_2', 0, {...})` in `Krowi_PopupDialog.lua:8`; LibMan passes the minor to `LibStub:NewLibrary` (`Krowi_Util/LibMan.lua:22`). Bump it in every release that changes a Lua file, locale files included.
- The locale files and `Shared.lua` register nothing. They attach to `KROWI_LIBMAN:GetCurrentLibrary(true)` (`Localization/enUS.lua:8`), which `NewLibrary` sets to the loaded `Krowi_PopupDialog_2` even when this copy did not win (`LibMan.lua:23-25`). A copy that did not win skips its strings, because `NewDefaultLocale` and `NewLocale` return nil for a locale already loaded (`Krowi_Util/LocalizationHelper.lua:15,24`).
- A newer copy that upgrades an older one skips its strings too, so a bump alone does not ship new or changed strings (Known debt).
- `## Version:` in the TOC is the release version and must match the top changelog entry; it is unrelated to the minor.
- A breaking change to either function needs a new major name (`Krowi_PopupDialog_3`); consumers call `LibStub('Krowi_PopupDialog_2')` by name.

## Consumers

| Consumer | Pinned | Calls |
|---|---|---|
| Krowi_AchievementFilter | 2.0 | `ShowExternalLink(link)`: the achievement right-click Wowhead and pet battle links (`Gui/RightClickMenu/AchievementMenu/WowheadLink.lua`, `PetBattleLinks.lua`), the Discord, CurseForge and Wago buttons in `Options/General.lua` |
| Krowi_ExtendedVendorUI | 2.0 | `ShowExternalLink` (`Options/General.lua`); `ShowNumericInput` with a PascalCase options table (`Gui/OptionsButton/OptionsButtonMixin.lua:96,167`) and with positional arguments (`:129`), for custom rows, columns and housing quantity |
| Krowi_Vendorer | 2.0 | `ShowExternalLink` (`Options/General.lua`) |

A change reaches players only after a release here and, in each consumer, a `Libs/Krowi_PopupDialog` submodule bump and a release. With equal minors the copy loaded first wins, and addons load alphabetically, so Krowi_AchievementFilter's copy is the one in use whenever it is enabled.

## Architecture

- `Krowi_PopupDialog.lua` adds `KROWI_EXTERNAL_LINK` and `KROWI_NUMERIC_INPUT` to Blizzard's `StaticPopupDialogs`. Their callbacks read file-level upvalues (`externalLink`, `numericInputMin`, `numericInputMax`, `numericInputDefault`, `numericInputCallback`) that the two functions set right before `StaticPopup_Show`.
- `ShowExternalLink(link[, text[, closeText]])` or `ShowExternalLink({Link, Text, CloseText})`: the edit box holds the link and is refilled on every change, so it cannot be edited; emptying it (Ctrl+X) clicks the close button.
- `ShowNumericInput(text, min, max, default, callback[, acceptText[, cancelText]])` or `ShowNumericInput({Text, Min, Max, Default, Callback, AcceptText, CancelText})`: range 1 to 999 and the default value is `Min` unless given; the callback runs only for a number in range.
- `lib.L` supplies the texts a caller leaves out (lines 62-63, 126-128).

## Taint-sensitive areas

Run the `krowi:taint-reviewer` agent after changing `Krowi_PopupDialog.lua`:

- It writes two keys into Blizzard's `StaticPopupDialogs` table and shows them with `StaticPopup_Show` from addon code, on the `StaticPopup1..N` frames Blizzard's own dialogs reuse. Never set `editBoxSecureText` (`StaticPopup_Show` errors from a tainted caller) and never change Blizzard's own dialog entries.
- Its callbacks change the shared frame's edit box (`SetNumeric`, `SetMaxLetters`, `SetText`) and click its buttons (`Button1:Click()`); the edit box settings outlive the dialog (Known debt).

## Localization

- `Localization/enUS.lua` and ten more (deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW): code above the `AUTOGENTOKEN` marker (line 14), the CurseForge export below it, starting at the `-- [[ Exported at ... ]] --` line (16). The CurseForge project is krowi-popup-dialog (link in `Shared.lua:6`). `Shared.lua` sets `lib.L` from AceLocale.
- enUS uses `= true` where the key is the text (`Accept`, `Cancel`, `Close`); every other locale is fully translated, with no `= true`. A new string goes below the `Exported at` line in enUS and, translated, in every other file. Leave it out of a file rather than writing `= true` there, which shows the raw key instead of the English text.
- String lines are `L["Key"] = "..."` with double quotes (the export's format), unlike the single quotes in code.

## Code style

- Tabs in `Krowi_PopupDialog.lua` (4 spaces in the `NewLibrary` options), 4 spaces in the locale files.
- No semicolons. Single quotes in code and in XML attributes.
- Each Lua file starts with the copyright block (`--[[`, `    Copyright (c) 2023 Krowi` (2026 in `Localization/`), `    Licensed under the terms of the LICENSE file in this repository.`, `]]`), a blank line, `---@diagnostic disable: undefined-global`, a blank line, then the registration and `if not lib then return end`. Sections are marked `-- [[ Name ]] --`. The TOC and XML carry the same notice as `#` and `<!-- -->` comments.
- CRLF on disk (LF in git, `core.autocrlf=true`, no `.gitattributes` or `.editorconfig`), no BOM, no final newline except in `Localization/Files.xml`.

## Testing in game

Test through a consumer. Do not deploy this repo on its own: `Deploy.ps1` here would add an `AddOns\Krowi_PopupDialog` folder, which is not installed today and loads after Krowi_AchievementFilter and ExtendedVendorUI.

1. Bump the minor first; at equal minors Krowi_AchievementFilter's copy wins and the test proves nothing.
2. In a consumer worktree made with `New-Worktree.ps1`, point the submodule at the change: `git -C Libs\Krowi_PopupDialog fetch "E:\World of Warcraft Addon Development\Krowi_Libraries\Krowi_PopupDialog" <branch>`, then `git -C Libs\Krowi_PopupDialog checkout FETCH_HEAD`. Deploy that worktree and `/reload`. Commit the new pointer only after this library is released.
3. Link dialog: any consumer's options page (Discord, CurseForge, Wago), or Krowi_AchievementFilter's achievement right-click Wowhead link. Number dialog: only ExtendedVendorUI, at a merchant, options button, Rows, Columns or Housing Quantity, Set custom. A new string shows only when the tested copy is the first loaded (Known debt).

## Git and release

- `main` is the only branch and the release branch: every `Release x.y` commit and its tag `x.y` are on `main` (2.0 at `2349271`). Branch from `main` and open PRs against it.
- Release only with `krowi:release`, from the main checkout `Krowi_Libraries\Krowi_PopupDialog` (it is in the addon manager's `LIBRARY_NAMES`). Every upload is a full release: `--stability stable`.
- The changelog is for addon authors. `README.md` (the TOC's client badges plus `_Packaging/Description.md`) and `_Packaging/ReleaseNotes.md` are generated at release.

## Known debt (verified 2026-10-17)

- `StaticPopup_Show` from addon code (lines 65, 133) puts these dialogs into Blizzard's shared `shownDialogFrames` list from an insecure path. They stay open (`timeout = 0`), and while one is open every Blizzard dialog shown reads that list and writes its `which` and `data` tainted, so its accept handler runs tainted: deleting a good item then fails with "<addon> has been blocked from an action only available to the Blizzard UI", blamed on the embedding addon. Confirmed in the source (wow-ui-source `StaticPopup.lua` `StaticPopup_Show` and `StaticPopup_FindVisible`; Blizzard's own comment there warns about it), not reproduced in game. A small frame the library owns, with its own edit box, removes this and the edit-box leak below.
- New or changed strings are lost when a newer copy upgrades an older one. LibStub hands the upgrade the same `lib` table (`Krowi_Util/LibMan.lua:22`), `InitLocalization` returns early because `lib.Localization` already exists (`LocalizationHelper.lua:37`), and the old `localeIsLoaded` makes `NewDefaultLocale()` and `NewLocale()` return nil (`LocalizationHelper.lua:15,24`, `Localization/enUS.lua:11-12`). A new key then shows raw, with an AceLocale "Missing entry" error (`Krowi_Util/Libs/AceLocale-3.0.lua:24-27`). AceLocale itself accepts a second registration; the fix belongs in Krowi_Util's `LocalizationHelper`. Nobody sees it today: every string dates from 2.0 and every consumer pins 2.0.
- `ShowNumericInput` leaves Blizzard's dialog edit box numeric. `SetNumeric(true)` in `OnShow` (line 83) is undone only in `EditBoxOnEnterPressed` and `EditBoxOnEscapePressed` (96, 104), so closing with the mouse leaves it on. Blizzard never calls `SetNumeric` (`GameDialogMixin:SetupEditBox`, wow-ui-source `live/Interface/AddOns/Blizzard_StaticPopup_Game/GameDialog.lua:206-228`, the same in the Classic clones), so the next dialog on that frame, Blizzard's or another addon's, accepts only digits. `SetMaxLetters` (lines 27, 84) carries over the same way into dialogs without `maxLetters`.
- `_Packaging/Description.md`, and so `README.md`, documents `ShowNumericInput` with lowercase keys (`text`, `min`, `callback`, ...), but the code reads `Text`, `Min`, `Callback` (lines 126-132): the documented call opens a 1 to 999 dialog that does nothing. It documents `ShowExternalLink(url)` without the text and close-text arguments.
- `Localization/Shared.lua:11` reads `if not lib and not lib.L then return end`: it errors instead of returning when `lib` is nil and never returns otherwise. `lib` is always set in practice.
- The TOC `## Interface:` is behind the live clients (see Clients and loading).