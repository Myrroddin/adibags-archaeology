--[[
AdiBags_Archaeology - Adds Archaeology items to AdiBags virtual groups
Copyright © 2022 Paul Vandersypen, All Rights Reserved
]]--

local _, addon = ...

-- localization table; returns English phrase if translation is not found -----
-- see https://phanx.net/addons/tutorials/localize for details ----------------
local L = setmetatable({}, {
    __index = function(t, k)
        local v = tostring(k)
        rawset(t, k, v)
        return v
    end
})

local LOCALE = GetLocale()
if LOCALE == "enUS" then
L["Archaeology Items"] = true
elseif LOCALE == "deDE" then
--@localization(locale="deDE", format="lua_additive_table")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", format="lua_additive_table")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", format="lua_additive_table")@
elseif LOCALE == "esES" then
--@localization(locale="esES", format="lua_additive_table")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", format="lua_additive_table")@
elseif LOCALE == "itIT" then
--@localization(locale="itIT", format="lua_additive_table")@
elseif LOCALE == "ptBR" then
--@localization(locale="ptBR", format="lua_additive_table")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", format="lua_additive_table")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", format="lua_additive_table")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", format="lua_additive_table")@
end

-- Replace remaining true values by their key
for k, v in pairs(L) do
	if v == true then
		L[k] = k
	end
end

-- return localization to files
addon.L = L