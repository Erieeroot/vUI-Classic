local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

local gsub = gsub
local format = format
local GameTime_GetLocalTime = GameTime_GetLocalTime

local OnMouseUp = function(self, button)
	if (button == "LeftButton") then
		TimeManager_Toggle()
	else
		ToggleCalendar()
	end
end

local OnEnter = function(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	
	local HomeLatency, WorldLatency = select(3, GetNetStats())
	local Framerate = floor(GetFramerate())
	local ServerTime = GameTime_GetGameTime(true)
	
	GameTooltip:AddLine(Language["Realm Time:"], 1, 0.7, 0)
	GameTooltip:AddLine(ServerTime, 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(Language["Latency:"], 1, 0.7, 0)
	GameTooltip:AddLine(format(Language["%s ms (home)"], HomeLatency), 1, 1, 1)
	GameTooltip:AddLine(format(Language["%s ms (world)"], WorldLatency), 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(Language["Framerate:"], 1, 0.7, 0)
	GameTooltip:AddLine(Framerate .. " fps", 1, 1, 1)

	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local Update = function(self, elapsed)
	self.Elapsed = self.Elapsed + elapsed
	
	if (self.Elapsed > 10) then
		local Time = GameTime_GetLocalTime(true)
		
		Time = gsub(Time, "%a+", format("|cff%s%s|r", Settings["data-text-value-color"], "%1"))
		
		self.Text:SetText(Time)
		
		self.Elapsed = 0
	end
end

local OnEnable = function(self)
	self:SetScript("OnUpdate", Update)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:SetScript("OnMouseUp", OnMouseUp)
	
	self.Elapsed = 0
	
	self:Update(11)
end

local OnDisable = function(self)
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseUp", nil)
	
	self.Elapsed = 0
	
	self.Text:SetText("")
end

vUI:AddDataText("Time - Local", OnEnable, OnDisable, Update)