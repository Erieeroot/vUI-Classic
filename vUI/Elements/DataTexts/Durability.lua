local vUI, GUI, Language, Media, Settings = select(2, ...):get()

local DT = vUI:GetModule("DataText")

local Slots = {1, 3, 5, 9, 10, 6, 7, 8, 16, 17, 18}
local GetRepairAllCost = GetRepairAllCost
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local floor = math.floor
local format = format
local Label = Language["Durability"]

local ScanTooltip = CreateFrame("GameTooltip", nil, UIParent, "GameTooltipTemplate")

local OnEnter = function(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	
	local TotalCost = 0
	local Current, Max, HasItem, HasCooldown, RepairCost
	
	for i = 1, #Slots do
		Current, Max = GetInventoryItemDurability(Slots[i])
		
		HasItem, HasCooldown, RepairCost = ScanTooltip:SetInventoryItem("player", Slots[i])
		
		if (HasItem and RepairCost) then
			TotalCost = TotalCost + RepairCost
		end
		
		if Current then
			GameTooltip:AddDoubleLine(GetInventoryItemLink("player", Slots[i]), format("%s%%", floor(Current / Max * 100)))
		end
	end
	
	if (TotalCost > 0) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(Language["Repair cost"], GetCoinTextureString(TotalCost), 1, 1, 1, 1, 1, 1)
	end
	
	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local OnMouseUp = function()
	ToggleCharacter("PaperDollFrame")
end

local Update = function(self)
	local Total, Count = 0, 0
	local Current, Max
	
	for i = 1, #Slots do
		Current, Max = GetInventoryItemDurability(Slots[i])
		
		if Current then
			Total = Total + (Current / Max)
			Count = Count + 1
		end
	end
	
	self.Text:SetFormattedText("|cff%s%s:|r |cff%s%s%%|r", Settings["data-text-label-color"], Label, Settings["data-text-value-color"], floor(Total / Count * 100))
end

local OnEnable = function(self)
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent("MERCHANT_SHOW")
	self:SetScript("OnEvent", Update)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:SetScript("OnMouseUp", OnMouseUp)
	
	self:Update()
end

local OnDisable = function(self)
	self:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:UnregisterEvent("MERCHANT_SHOW")
	self:SetScript("OnEvent", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseUp", nil)
	
	self.Text:SetText("")
end

DT:SetType("Durability", OnEnable, OnDisable, Update)