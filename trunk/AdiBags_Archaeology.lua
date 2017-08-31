local addon_name, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

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
L["Archaeology Bought Items"] = true
L["Archaeology Items"] = true
L["Filter all crates, completed artifacts, key stones, and restored artifacts into their own category."] = true
L["Purchasable things from vendors."] = true
L["Put the artifact on display."] = true
L["Use: Carefully crate the restored artifact."] = true
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

local MatchIDs
local Tooltip
local Result = {}

local function AddToSet(Set, List)
	for _, v in ipairs(List) do
		Set[v] = true
	end
end

-- known Archaeology items list -----------------------------------------------
local items = {
    -- crates
    87536,      -- Night Elf
    87533,      -- Dwarf
    87534,      -- Draenei
    87535,      -- Fossil
    87537,      -- Nerubian
    87538,      -- Orc
    87539,      -- Tol'vir
    87540,      -- Troll
    87541,      -- Vrykul
    117386,     -- Pandaren
    117387,     -- Mogu
    117388,     -- Mantid
    142113,     -- Arakkoa
    142114,     -- Draenor Clans
    142115,     -- Ogre
    -- Restored Artifact
    87399,
    -- key stones
    109584,     -- Ogre Missive
    79869,      -- Mogu Statue Piece
    78868,      -- Pandaren Pottery Shard
    64397,      -- Tol'vir Hieroglypic
    52843,      -- Dwarf Rune Stone
    63128,      -- Troll Tablet
    63127,      -- Highborne Scroll
    64394,      -- Draenei Tome
    64392,      -- Orc Blood Text
    64395,      -- Vrykul Rune Stick
    64396,      -- Nerubian Obelisk
    95373,      -- Mantid Amber Sliver
    109585,     -- Arakkoa Cipher
    108439,     -- Draenor Clan Orator Cane
    130905,     -- Mark of the Deceiver
    130903,     -- Ancient Suramar Scroll
    130904,     -- Highmountain Ritual-Stone
}

local purchases = {
    122606,     -- Explorer's Notebook
    87548,      -- Lorewalker's Lodestone
    87549,      -- Lorewalker's Map
    117389,     -- Draenor Achaeologist's Lodestone
    117390,     -- Draenor Archaeologist's Map
    104198,     -- Mantid Artifact Hunter's Kit
}

local function MatchIDs_Init(self)
    table.wipe(Result)
    if self.db.profile.moveItems then
        AddToSet(Result, items)
    end

    if self.db.profile.moveCurrency then
        AddToSet(Result, purchases)
    end

    return Result
end

local function Tooltip_Init()
	local tip, leftside = CreateFrame("GameTooltip"), {}
	for i = 1, 6 do
		local Left, Right = tip:CreateFontString(), tip:CreateFontString()
		Left:SetFontObject(GameFontNormal)
		Right:SetFontObject(GameFontNormal)
		tip:AddFontStrings(Left, Right)
		leftside[i] = Left
	end
	tip.leftside = leftside
	return tip
end

local setFilter = AdiBags:RegisterFilter("Archaeology", 90, "ABEvent-1.0")
setFilter.uiName = PROFESSIONS_ARCHAEOLOGY
setFilter.uiDesc = L["Archaeology Items"]

function setFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace("Archaeology", {
        profile = {
            moveItems = true,
            moveCurrency = true
        }
    })
end

function setFilter:Update()
	MatchIDs = nil
	self:SendMessage("AdiBags_FiltersChanged")
end

function setFilter:OnEnable()
	AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
	AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)
	MatchIDs = MatchIDs or MatchIDs_Init(self)
	if MatchIDs[slotData.itemId] then
		return PROFESSIONS_ARCHAEOLOGY
	end
	
	Tooltip = Tooltip or Tooltip_Init()
	Tooltip:SetOwner(UIParent,"ANCHOR_NONE")
	Tooltip:ClearLines()
	
	if slotData.bag == BANK_CONTAINER then
		Tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
	else
		Tooltip:SetBagItem(slotData.bag, slotData.slot)
	end

    for i = 1, 6 do
        local t = Tooltip.leftside[i]:GetText()
        if self.db.profile.moveItems and t == L["Put the artifact on display."] or t == L["Use: Carefully crate the restored artifact."] then
            return PROFESSIONS_ARCHAEOLOGY
        end
    end
	
	Tooltip:Hide()
end

function setFilter:GetOptions()
    return{
        moveItems = {
            name = L["Archaeology Items"],
            desc = L["Filter all crates, completed artifacts, key stones, and restored artifacts into their own category."],
            type = "toggle",
            order = 10
        },
        moveCurrency = {
            name = L["Archaeology Bought Items"],
            desc = L["Purchasable things from vendors."],
            type = "toggle",
            order = 20,
        }
    },
    AdiBags:GetOptionHandler(self, false, function()
		return self:Update()
	end)
end