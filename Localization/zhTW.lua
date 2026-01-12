--[[
    Copyright (c) 2026 Krowi
    Licensed under the terms of the LICENSE file in this repository.
]]

---@diagnostic disable: undefined-global

local lib = KROWI_LIBMAN:GetCurrentLibrary(true)
if not lib then	return end

local L = lib.Localization.NewLocale('zhTW')
if not L then return end

-- [[ Everything after this line is automatically generated from CurseForge and is not meant for manual edit - SOURCETOKEN - AUTOGENTOKEN ]] --

-- [[ Exported at 2026-01-12 11-00-00 ]] --
L["Enter a number"] = '輸入數字：'
L["Accept"] = '接受'
L["Cancel"] = '取消'
L["Close"] = '關閉'
L["Copy and close"] = '按 Ctrl + X 複製網站並關閉此視窗。'