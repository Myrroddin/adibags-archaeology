--[[
AdiBags_Archaeology - Adds Archaeology items to AdiBags virtual groups
Copyright © 2022 Paul Vandersypen, All Rights Reserved
]]--

local _, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local db = addon.db

-- check for existing filter
local function CheckFilter(newFilter)
	local filterExists = false
	for _, value in AdiBags:IterateFilters() do
		if value.filterName == newFilter then
			filterExists = true
			return filterExists
		end
	end
	return filterExists
end

-- create filter
local function CreateFilter(name, uiName, uiDesc, title, items)
	local filter = AdiBags:RegisterFilter(uiName, 98, "ABEvent-1.0")
	-- Register Filter with AdiBags
	filter.uiName = uiName
	filter.uiDesc = uiDesc
	filter.items = items

	function filter:OnInitialize()
		-- Assign item table to filter
		self.items = filter.items
	end

	function filter:Update()
		self:SendMessage("AdiBags_FiltersChanged")
	end

	function filter:OnEnable()
		AdiBags:UpdateFilters()
	end

	function filter:OnDisable()
		AdiBags:UpdateFilters()
	end

	function filter:Filter(slotData)
		if self.items[tonumber(slotData.itemId)] then
			return title
		end
	end
end

-- run filter
local function AllFilters(db)
	for name, group in pairs(db.Filters) do
		-- Does filter already exist?
		local filterExists = CheckFilter(group.uiName)
		if not filterExists == nil or filterExists == false then
			-- name = Name of table
			-- group.uiName = Name to use in filter listing
			-- group.uiDesc = Description to show in filter listing
			-- group.items = table of items to sort
			CreateFilter(name, group.uiName, group.uiDesc, group.title, group.items)
		end
	end
end

-- start here
AllFilters(db)

--[[
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
        },
        moveQuestItems = {
            name = AUCTION_CATEGORY_QUEST_ITEMS,
            desc = L["Rewards from Legion Archaeology quests. Does not include toys or mounts."],
            type = "toggle",
            order = 30
        }
    },
    AdiBags:GetOptionHandler(self, false, function()
		return self:Update()
	end)
end
]]--