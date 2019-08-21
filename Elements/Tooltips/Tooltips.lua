local vUI, GUI, Language, Media, Settings = select(2, ...):get()

-- Super minimal, don't judge me. So much to do in this file, but I'm just laying out something basic here
local Tooltips = vUI:NewModule("Tooltips")

local MyGuild

local select = select
local find = string.find
local format = format
local UnitPlayerControlled = UnitPlayerControlled
local UnitCanAttack = UnitCanAttack
local UnitIsPVP = UnitIsPVP
local UnitPVPName = UnitPVPName
local UnitReaction = UnitReaction
local UnitExists = UnitExists
local UnitClass = UnitClass
local GetGuildInfo = GetGuildInfo
local UnitRace = UnitRace
local UnitName = UnitName
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local IsInGuild = IsInGuild

Tooltips.Handled = {
	GameTooltip,
	ItemRefTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	AutoCompleteBox,
	FriendsTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	EmbeddedItemTooltip,
}

local UpdateFonts = function(self)
	for i = 1, self:GetNumRegions() do
		local Region = select(i, self:GetRegions())
		
		if (Region:GetObjectType() == "FontString" and not Region.Handled) then
			Region:SetFont(Media:GetFont(Settings["ui-widget-font"]), 12)
			Region:SetShadowColor(0, 0, 0)
			Region:SetShadowOffset(1, -1)
			Region.Handled = true
		end
	end
	
	-- What a pain in the ass
	for i = 1, self:GetNumChildren() do
		local Child = select(i, self:GetChildren())
		
		if (Child and Child.GetName and Child:GetName() ~= nil and find(Child:GetName(), "MoneyFrame")) then
			local Prefix = _G[Child:GetName() .. "PrefixText"]
			local Suffix = _G[Child:GetName() .. "SuffixText"]
			
			if (Prefix and not Prefix.Handled) then
				Prefix:SetFont(Media:GetFont(Settings["ui-widget-font"]), 12)
				Prefix:SetShadowColor(0, 0, 0)
				Prefix:SetShadowOffset(1, -1)
				Prefix.SetFont = function() end
				Prefix.SetFontObject = function() end
				Prefix.Handled = true
			end
			
			if (Suffix and not Suffix.Handled) then
				Suffix:SetFont(Media:GetFont(Settings["ui-widget-font"]), 12)
				Suffix:SetShadowColor(0, 0, 0)
				Suffix:SetShadowOffset(1, -1)
				Suffix.SetFont = function() end
				Suffix.SetFontObject = function() end
				Suffix.Handled = true
			end
		end
	end
	
	if self.numMoneyFrames then
		local MoneyFrame
		
		for i = 1, self.numMoneyFrames do
			MoneyFrame = _G[self:GetName() .. "MoneyFrame" .. i]
			
			if (MoneyFrame and not MoneyFrame.Handled) then
				for j = 1, MoneyFrame:GetNumChildren() do
					local Region = select(j, MoneyFrame:GetChildren())
					
					if (Region and Region.GetName and Region:GetName()) then
						local Text = _G[Region:GetName() .. "Text"]
						
						if Text then
							Text:SetFont(Media:GetFont(Settings["ui-widget-font"]), 12)
							Text:SetShadowColor(0, 0, 0)
							Text:SetShadowOffset(1, -1)
							Text.SetFont = function() end
							Text.SetFontObject = function() end
						end
					end
				end
				
				MoneyFrame.Handled = true
			end
		end
	end
end

local SetStyle = function(self)
	if self.Styled then
		self.Backdrop:SetBackdrop(vUI.BackdropAndBorder)
		self.Backdrop:SetBackdropBorderColor(0, 0, 0)
		self.Backdrop:SetBackdropColorHex(Settings["ui-window-main-color"])
		
		UpdateFonts(self)
		
		return
	end
	
	self:SetBackdrop(nil)
	
	self.Backdrop = CreateFrame("Frame", nil, self)
	self.Backdrop:SetAllPoints(self)
	self.Backdrop:SetBackdrop(vUI.BackdropAndBorder)
	self.Backdrop:SetBackdropBorderColor(0, 0, 0)
	self.Backdrop:SetBackdropColorHex(Settings["ui-window-main-color"])
	self.Backdrop:SetFrameLevel(self:GetFrameLevel() - 1)
	self.Backdrop:SetFrameStrata("BACKGROUND")
	
	self.OuterBG = CreateFrame("Frame", nil, self)
	self.OuterBG:SetScaledPoint("TOPLEFT", self, -3, 3)
	self.OuterBG:SetScaledPoint("BOTTOMRIGHT", self, 3, -3)
	self.OuterBG:SetBackdrop(vUI.BackdropAndBorder)
	self.OuterBG:SetBackdropBorderColor(0, 0, 0)
	self.OuterBG:SetFrameLevel(self:GetFrameLevel() - 1)
	self.OuterBG:SetFrameStrata("BACKGROUND")
	self.OuterBG:SetBackdropColorHex(Settings["ui-window-bg-color"])
	
	UpdateFonts(self)
	
	self.SetBackdrop = function() end
	self.SetBackdropColor = function() end
	self.SetBackdropBorderColor = function() end
	
	self.Styled = true
end

local GetUnitColor = function(unit)
	local Color
	
	if UnitIsPlayer(unit) then
		local Class = select(2, UnitClass(unit))
		
		if Class then
			Color = vUI.ClassColors[Class]
		end
	else
		local Reaction = UnitReaction(unit, "player")
		
		if Reaction then
			Color = vUI.ReactionColors[Reaction]
		end
	end
	
	if Color then
		return vUI:RGBToHex(Color[1], Color[2], Color[3])
	else
		return "FFFFFF"
	end
end

local OnTooltipSetUnit = function(self)
	local Unit, UnitID = self:GetUnit()
	
	if UnitID then
		local Class = UnitClass(UnitID)
		
		if (not Class) then
			return
		end
		
		local Name, Realm = UnitName(UnitID)
		local Race = UnitRace(UnitID)
		local Level = UnitLevel(UnitID)
		local Title = UnitPVPName(UnitID)
		local Guild, Rank = GetGuildInfo(UnitID)
		local Color = GetUnitColor(UnitID)
		
		if (Class == Name) then
			Class = ""
		end
		
		if UnitIsAFK(Unit) then
			self:AppendText(" " .. CHAT_FLAG_AFK)
		elseif UnitIsDND(Unit) then 
			self:AppendText(" " .. CHAT_FLAG_DND)
		end
		
		if Realm then
			GameTooltipTextLeft1:SetText(format("|cFF%s%s - %s|r", Color, (Title or Name), Realm))
		else
			GameTooltipTextLeft1:SetText(format("|cFF%s%s|r", Color, (Title or Name)))
		end
		
		local Line
		
		for i = 1, self:NumLines() do
			Line = _G[self:GetName() .. "TextLeft" .. i]
			
			if (Line and Guild and (i == 2)) then
				if (Guild == MyGuild) then
					Line:SetText(format("|cFF5DADE2%s|r", Guild))
				else
					Line:SetText(format("|cFF66BB6A%s|r", Guild))
				end
				
			elseif (Line and find(Line:GetText(), "^" .. LEVEL)) then
				local LevelColor = vUI:UnitDifficultyColor(UnitID)
				
				if Race then
					Line:SetText(format("%s %s%s|r %s %s", LEVEL, LevelColor, Level, Race, Class))
				else
					Line:SetText(format("%s %s%s|r %s", LEVEL, LevelColor, Level, Class))
				end
			elseif (Line and find(Line:GetText(), PVP)) then
				Line:SetText(format("|cFFEE4D4D%s|r", PVP))
			end
		end
		
		if (UnitID ~= "player" and UnitExists(UnitID .. "target")) then
			local TargetColor = GetUnitColor(UnitID .. "target")
			
			self:AddLine(Language["Targeting: |cFF"] .. TargetColor .. UnitName(UnitID .. "target") .. "|r", 1, 1, 1)
		end
		
		GameTooltipStatusBar:OldSetStatusBarColor(vUI:HexToRGB(Color))
		GameTooltipStatusBar.BG:SetVertexColorHex(Color)
		
		if self.OuterBG then
			self.OuterBG:SetScaledPoint("TOPLEFT", self, -3, 3)
			self.OuterBG:SetScaledPoint("BOTTOMRIGHT", self, 3, -15)
		end
	end
end

local SetTooltipDefaultAnchor = function(self) -- Not actually moving them yet, not sure where to place it.
	local Unit, UnitID = self:GetUnit()
	
	if UnitID then
		--self:SetAnchorType("ANCHOR_BOTTOMRIGHT", -10, 15)
			
		if self.OuterBG then
			self.OuterBG:SetScaledPoint("BOTTOMRIGHT", self, 3, -15)
		end
	else
		--self:SetAnchorType("ANCHOR_BOTTOMRIGHT", -10, 3)
		
		if self.OuterBG then
			self.OuterBG:SetScaledPoint("BOTTOMRIGHT", self, 3, -3)
		end
	end
end

function Tooltips:AddHooks()
	for i = 1, #self.Handled do
		self.Handled[i]:HookScript("OnShow", SetStyle)
	end
	
	GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
	
	hooksecurefunc("GameTooltip_SetDefaultAnchor", SetTooltipDefaultAnchor)
end

function Tooltips:StyleHealth()
	local HealthBar = GameTooltipStatusBar
	
	HealthBar:ClearAllPoints()
	HealthBar:SetScaledHeight(8)
	HealthBar:SetScaledPoint("TOPLEFT", HealthBar:GetParent(), "BOTTOMLEFT", 1, -3)
	HealthBar:SetScaledPoint("TOPRIGHT", HealthBar:GetParent(), "BOTTOMRIGHT", -1, -3)
	HealthBar:SetStatusBarTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	
	HealthBar.BG = HealthBar:CreateTexture(nil, "ARTWORK")
	HealthBar.BG:SetScaledPoint("TOPLEFT", HealthBar, 0, 0)
	HealthBar.BG:SetScaledPoint("BOTTOMRIGHT", HealthBar, 0, 0)
	HealthBar.BG:SetTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	HealthBar.BG:SetAlpha(0.2)
	
	HealthBar.Backdrop = CreateFrame("Frame", nil, HealthBar)
	HealthBar.Backdrop:SetScaledPoint("TOPLEFT", HealthBar, -1, 1)
	HealthBar.Backdrop:SetScaledPoint("BOTTOMRIGHT", HealthBar, 1, -1)
	HealthBar.Backdrop:SetBackdrop(vUI.BackdropAndBorder)
	HealthBar.Backdrop:SetBackdropColor(0, 0, 0)
	HealthBar.Backdrop:SetBackdropBorderColor(0, 0, 0)
	HealthBar.Backdrop:SetFrameLevel(HealthBar:GetFrameLevel() - 1)
	
	HealthBar.OldSetStatusBarColor = HealthBar.SetStatusBarColor
	HealthBar.SetStatusBarColor = function() end
end

function Tooltips:Load()
	if (not Settings["tooltips-enable"]) then
		return
	end
	
	self:AddHooks()
	self:StyleHealth()
	
	if IsInGuild() then
		MyGuild = GetGuildInfo("player")
	end
end

GUI:AddOptions(function(self)
	local Left, Right = self:CreateWindow(Language["Tooltips"])
	
	Left:CreateHeader(Language["Enable"])
	Left:CreateCheckbox("tooltips-enable", Settings["tooltips-enable"], Language["Enable Tooltips Module"], ""):RequiresReload(true)
end)