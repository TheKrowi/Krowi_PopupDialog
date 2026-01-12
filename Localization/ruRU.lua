--[[
    Copyright (c) 2026 Krowi
    Licensed under the terms of the LICENSE file in this repository.
]]

---@diagnostic disable: undefined-global

local lib = KROWI_LIBMAN:GetCurrentLibrary(true)
if not lib then	return end

local L = lib.Localization.NewLocale('ruRU')
if not L then return end

-- [[ Everything after this line is automatically generated from CurseForge and is not meant for manual edit - SOURCETOKEN - AUTOGENTOKEN ]] --

-- [[ Exported at 2026-01-12 11-00-00 ]] --
L["Enter a number"] = 'Введите число:'
L["Accept"] = 'Принять'
L["Cancel"] = 'Отмена'
L["Close"] = 'Закрыть'
L["Copy and close"] = 'Нажмите Ctrl + X, чтобы скопировать сайт и закрыть это окно.'