local vUI, GUI, Language, Media, Settings = select(2, ...):get()

local DT = vUI:GetModule("DataText")

local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local floor = floor

local OnEnter = function(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	
	local ZoneText = GetRealZoneText()
	local SubZoneText = GetMinimapZoneText()
	local PVPType, IsFFA, Faction = GetZonePVPInfo()
	local Color = vUI.ZoneColors[PVPType or "other"]
	local Label
	
	if (ZoneText ~= SubZoneText) then
		Label = format("%s - %s", ZoneText, SubZoneText)
	else
		Label = ZoneText
	end
	
	GameTooltip:AddLine(Label, Color[1], Color[2], Color[3])
	
	if (PVPType == "friendly" or PVPType == "hostile") then
		GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, Faction), Color[1], Color[2], Color[3])
	elseif (PVPType == "sanctuary") then
		GameTooltip:AddLine(SANCTUARY_TERRITORY, Color[1], Color[2], Color[3])
	elseif IsFFA then
		GameTooltip:AddLine(FREE_FOR_ALL_TERRITORY, Color[1], Color[2], Color[3])
	else
		GameTooltip:AddLine(CONTESTED_TERRITORY, Color[1], Color[2], Color[3])
	end
	
	self.TooltipShown = true
	
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
	self.TooltipShown = false
end

local Update = function(self, elapsed)
	self.Elapsed = self.Elapsed + elapsed
	
	if (self.Elapsed > 0.5) then
		local MapID = GetBestMapForUnit("player")
		local Position = GetPlayerMapPosition(MapID, "player")
		local X, Y = Position:GetXY()
		
		X = X * 100
		Y = Y * 100
		
		self.Text:SetFormattedText("|cff%s%.2f|r, |cff%s%.2f|r", Settings["data-text-value-color"], X, Settings["data-text-value-color"], Y)
		
		self.Elapsed = 0
	end
end

local OnEnable = function(self)
	self.Elapsed = 0
	self:SetScript("OnUpdate", Update)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:Update(1)
end

local OnDisable = function(self)
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self.Elapsed = 0
	
	self.Text:SetText("")
end

DT:SetType("Coordinates", OnEnable, OnDisable, Update)