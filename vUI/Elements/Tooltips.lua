local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

local Tooltips = vUI:NewModule("Tooltips")
local LCMH = LibStub("LibClassicMobHealth-1.0")
local MyGuild

local select = select
local find = string.find
local match = string.match
local floor = floor
local format = format
local UnitPVPName = UnitPVPName
local UnitReaction = UnitReaction
local UnitExists = UnitExists
local UnitClass = UnitClass
local GetGuildInfo = GetGuildInfo
local UnitCreatureType = UnitCreatureType
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitName = UnitName
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsGhost = UnitIsGhost
local UnitIsDead = UnitIsDead
local UnitClassification = UnitClassification
local GetPetHappiness = GetPetHappiness
local GetMouseFocus = GetMouseFocus
local GetItemInfo = GetItemInfo
local InCombatLockdown = InCombatLockdown
local GetQuestDifficultyColor = GetQuestDifficultyColor

local GameTooltipStatusBar = GameTooltipStatusBar

Tooltips.Handled = {
	GameTooltip,
	ItemRefTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	--AutoCompleteBox,
	FriendsTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	EmbeddedItemTooltip,
}

Tooltips.Classifications = {
	["rare"] = Language["|cFFBDBDBDRare|r"],
	["elite"] = Language["|cFFFDD835Elite|r"],
	["rareelite"] = Language["|cFFBDBDBDRare Elite|r"],
	["worldboss"] = Language["Boss"],
}

function Tooltips:UpdateFonts(tooltip)
	for i = 1, tooltip:GetNumRegions() do
		local Region = select(i, tooltip:GetRegions())
		
		if (Region:GetObjectType() == "FontString") then
			vUI:SetFontInfo(Region, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
		end
	end
	
	for i = 1, tooltip:GetNumChildren() do
		local Child = select(i, tooltip:GetChildren())
		
		if (Child and Child.GetName and Child:GetName() ~= nil and find(Child:GetName(), "MoneyFrame")) then
			local Prefix = _G[Child:GetName() .. "PrefixText"]
			local Suffix = _G[Child:GetName() .. "SuffixText"]
			
			if Prefix then
				vUI:SetFontInfo(Prefix, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
			end
			
			if Suffix then
				vUI:SetFontInfo(Suffix, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
			end
		end
	end
	
	if tooltip.numMoneyFrames then
		local MoneyFrame
		
		for i = 1, tooltip.numMoneyFrames do
			MoneyFrame = _G[tooltip:GetName() .. "MoneyFrame" .. i]
			
			if MoneyFrame then
				for j = 1, MoneyFrame:GetNumChildren() do
					local Region = select(j, MoneyFrame:GetChildren())
					
					if (Region and Region.GetName and Region:GetName()) then
						local Text = _G[Region:GetName() .. "Text"]
						
						if Text then
							vUI:SetFontInfo(Text, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
						end
					end
				end
			end
		end
	end
	
	self:UpdateStatusBarFonts()
end

local SetTooltipStyle = function(self)
	if self.Styled then
		if (self.GetUnit and self:GetUnit()) then
			vUI:SetPoint(self.OuterBG, "TOPLEFT", GameTooltipStatusBar, -4, 4)
		else
			vUI:SetPoint(self.OuterBG, "TOPLEFT", self, -3, 3)
		end
		
		Tooltips:UpdateFonts(self)
	else
		self:SetBackdrop(nil) -- To stop blue tooltips
		self:SetFrameLevel(10)
		self.SetFrameLevel = function() end
		
		self.Backdrop = CreateFrame("Frame", nil, self)
		self.Backdrop:SetAllPoints(self)
		self.Backdrop:SetBackdrop(vUI.BackdropAndBorder)
		self.Backdrop:SetBackdropBorderColor(0, 0, 0)
		self.Backdrop:SetBackdropColor(vUI:HexToRGB(Settings["ui-window-main-color"]))
		self.Backdrop:SetFrameStrata("TOOLTIP")
		self.Backdrop:SetFrameLevel(2)
		
		self.OuterBG = CreateFrame("Frame", nil, self)
		vUI:SetPoint(self.OuterBG, "TOPLEFT", self, -3, 3)
		vUI:SetPoint(self.OuterBG, "BOTTOMRIGHT", self, 3, -3)
		self.OuterBG:SetBackdrop(vUI.BackdropAndBorder)
		self.OuterBG:SetBackdropBorderColor(0, 0, 0)
		self.OuterBG:SetFrameStrata("TOOLTIP")
		self.OuterBG:SetFrameLevel(1)
		self.OuterBG:SetBackdropColor(vUI:HexToRGB(Settings["ui-window-bg-color"]))
		
		if (self == AutoCompleteBox) then
			for i = 1, AUTOCOMPLETE_MAX_BUTTONS do
				local Text = _G["AutoCompleteButton" .. i .. "Text"]
				
				vUI:SetFontInfo(Text, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
			end
			
			vUI:SetFontInfo(AutoCompleteInstructions, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
			
			AutoCompleteBox.Backdrop:SetFrameStrata("DIALOG")
			AutoCompleteBox.OuterBG:SetFrameStrata("DIALOG")
		end
		
		Tooltips:UpdateFonts(self)
		
		self.SetBackdrop = function() end
		
		self.Styled = true
	end
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
	if (Settings["tooltips-hide-on-unit"] == "NO_COMBAT" and InCombatLockdown()) or Settings["tooltips-hide-on-unit"] == "ALWAYS" then
		self:Hide()
		
		return
	end
	
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
		local CreatureType = UnitCreatureType(UnitID)
		local Classification = Tooltips.Classifications[UnitClassification(UnitID)]
		local Flag = ""
		local Line
		
		if (Class == Name) then
			Class = ""
		end
		
		if UnitIsAFK(UnitID) then
			Flag = "|cFFFDD835" .. CHAT_FLAG_AFK .. "|r "
		elseif UnitIsDND(UnitID) then 
			Flag = "|cFFF44336" .. CHAT_FLAG_DND .. "|r "
		end
		
		if Guild then
			if (Guild == MyGuild) then
				Guild = format("|cFF5DADE2<%s>|r", Guild)
			else
				Guild = format("|cFF66BB6A<%s>|r", Guild)
			end
		else
			Guild = ""
		end
		
		if (Realm and find(Realm, "%S+")) then
			GameTooltipTextLeft1:SetText(format("%s|cFF%s%s-%s %s|r", Flag, Color, (Title or Name), Realm, Guild))
		else
			GameTooltipTextLeft1:SetText(format("%s|cFF%s%s %s|r", Flag, Color, (Title or Name), Guild))
		end
		
		for i = 2, self:NumLines() do
			Line = _G["GameTooltipTextLeft" .. i]
			
			if (Line and Line.GetText and find(Line:GetText(), "^" .. LEVEL)) then
				local LevelColor = GetQuestDifficultyColor(Level)
				LevelColor = vUI:RGBToHex(LevelColor.r, LevelColor.g, LevelColor.b)
				
				if (Level == -1) then
					Level = "??"
				end
				
				if Race then
					Line:SetText(format("%s |cFF%s%s|r %s %s", LEVEL, LevelColor, Level, Race, Class))
				elseif CreatureType then
					if Classification then
						Line:SetText(format("%s |cFF%s%s|r %s %s", LEVEL, LevelColor, Level, Classification, CreatureType))
					else
						Line:SetText(format("%s |cFF%s%s|r %s", LEVEL, LevelColor, Level, CreatureType))
					end
				else
					Line:SetText(format("%s |cFF%s%s|r %s", LEVEL, LevelColor, Level, Class))
				end
			elseif (Line and find(Line:GetText(), PVP)) then
				Line:SetText(format("|cFFEE4D4D%s|r", PVP))
			end
		end
		
		if (UnitID ~= "player" and UnitExists(UnitID .. "target")) then
			local TargetColor = GetUnitColor(UnitID .. "target")
			
			self:AddLine(Language["Targeting: |cFF"] .. TargetColor .. UnitName(UnitID .. "target") .. "|r", 1, 1, 1)
		end
		
		if (vUI.UserClass == "HUNTER" and UnitID == "pet") then
			local Happiness = GetPetHappiness()
			
			if Happiness then
				local Color = vUI.HappinessColors[Happiness]
				
				if Color then
					self:AddDoubleLine(Language["Happiness:"], format("|cFF%s%s|r", vUI:RGBToHex(Color[1], Color[2], Color[3]), Tooltips.HappinessLevels[Happiness]))
				end
			end
		end
		
		--GameTooltipStatusBar:OldSetStatusBarColor(vUI:HexToRGB(Color))
		--GameTooltipStatusBar.BG:SetVertexColorHex(Color)
		
		if self.OuterBG then
			vUI:SetPoint(self.OuterBG, "TOPLEFT", self, -3, 22)
		end
	end
end

local OnTooltipSetItem = function(self)
	if (Settings["tooltips-hide-on-item"] == "NO_COMBAT" and InCombatLockdown()) or Settings["tooltips-hide-on-item"] == "ALWAYS" then
		self:Hide()
		
		return
	end
	
	if (MerchantFrame and MerchantFrame:IsShown()) then
		return
	end
	
	local Link = select(2, self:GetItem())
	
	if (not Link) then
		return
	end
	
	if Settings["tooltips-show-id"] then
		local ID = match(Link, ":(%w+)")
		
		self:AddLine(" ")
		self:AddDoubleLine(Language["Item ID:"], ID, 1, 1, 1, 1, 1, 1)
	end
end

local OnItemRefTooltipSetItem = function(self)
	local Link = select(2, self:GetItem())
	
	if (not Link) then
		return
	end
	
	if Settings["tooltips-show-id"] then
		local ID = match(Link, ":(%w+)")
		
		self:AddLine(" ")
		self:AddDoubleLine(Language["Item ID:"], ID, 1, 1, 1, 1, 1, 1)
	end
end

local OnTooltipSetSpell = function(self)
	if (Settings["tooltips-hide-on-action"] == "NO_COMBAT" and InCombatLockdown()) or Settings["tooltips-hide-on-action"] == "ALWAYS" then
		self:Hide()
		
		return
	end
	
	if (not Settings["tooltips-show-id"]) then
		return
	end
	
	local ID = select(2, self:GetSpell())
	
	self:AddLine(" ")
	self:AddDoubleLine(Language["Spell ID:"], ID, 1, 1, 1, 1, 1, 1)
end

Tooltips.GameTooltip_SetDefaultAnchor = function(self, parent)
	if Settings["tooltips-on-cursor"] then
		self:SetOwner(parent, "ANCHOR_CURSOR", 0, 8)
		
		return
	end
	
	local Unit, UnitID = self:GetUnit()
	
	if (not UnitID) then
		local MouseFocus = GetMouseFocus()
		
		if MouseFocus and MouseFocus:GetAttribute("unit") then
			UnitID = MouseFocus:GetAttribute("unit")
		end
	end
	
	if (not UnitID and UnitExists("mouseover")) then
		UnitID = "mouseover"
	end
	
	self:ClearAllPoints()
	
	if vUIMetersFrame then
		vUI:SetPoint(self, "BOTTOMLEFT", vUIMetersFrame, "TOPLEFT", 3, 5)
	else
		vUI:SetPoint(self, "BOTTOMRIGHT", Tooltips, -3, 3)
	end
end

function Tooltips:AddHooks()
	for i = 1, #self.Handled do
		self.Handled[i]:HookScript("OnShow", SetTooltipStyle)
	end
	
	GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
	GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
	GameTooltip:HookScript("OnTooltipSetSpell", OnTooltipSetSpell)
	ItemRefTooltip:HookScript("OnTooltipSetItem", OnItemRefTooltipSetItem)
	
	self:Hook("GameTooltip_SetDefaultAnchor")
end

local GetColor = function(p, r1, g1, b1, r2, g2, b2)
	return r1 + (r2 - r1) * p, g1 + (g2 - g1) * p, b1 + (b2 - b1) * p
end

local OnValueChanged = function(self)
	local Unit = select(2, self:GetParent():GetUnit())
	
	if (not Unit) then
		return
	end
	
	local Current, Max, Found = LCMH:GetUnitHealth(Unit)
	
	if (not Found) then
		Current = self:GetValue()
		Max = select(2, self:GetMinMaxValues())
	end
	
	local Color = GetUnitColor(Unit)
	
	if Settings["tooltips-show-health-text"] then
		local Current = self:GetValue()
		local Max = select(2, self:GetMinMaxValues())
		
		if (Max == 0) then
			if UnitIsDead(Unit) then
				self.HealthValue:SetText("|cFFD64545" .. Language["Dead"] .. "|r")
			elseif UnitIsGhost(Unit) then
				self.HealthValue:SetText("|cFFEEEEEE" .. Language["Ghost"] .. "|r")
			else
				self.HealthValue:SetText(" ")
				self.HealthPercent:SetText(" ")
			end
		else
			if UnitIsDead(Unit) then
				self.HealthValue:SetText("|cFFD64545" .. Language["Dead"] .. "|r")
			elseif UnitIsGhost(Unit) then
				self.HealthValue:SetText("|cFFEEEEEE" .. Language["Ghost"] .. "|r")
			else
				self.HealthValue:SetText(format("%s / %s", vUI:ShortValue(Current), vUI:ShortValue(Max)))
			end
			
			self.HealthPercent:SetText(format("%s%%", floor((Current / Max * 100 + 0.05) * 10) / 10))
		end
	end
	
	self:SetStatusBarColor(vUI:HexToRGB(Color))
	self.BG:SetVertexColor(vUI:HexToRGB(Color))
end

function Tooltips:UpdateStatusBarFonts()
	vUI:SetFontInfo(GameTooltipStatusBar.HealthValue, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
	vUI:SetFontInfo(GameTooltipStatusBar.HealthPercent, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
end

function Tooltips:StyleStatusBar()
	GameTooltipStatusBar:ClearAllPoints()
	vUI:SetHeight(GameTooltipStatusBar, Settings["tooltips-health-bar-height"])
	vUI:SetPoint(GameTooltipStatusBar, "BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 1, 3)
	vUI:SetPoint(GameTooltipStatusBar, "BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -1, 3)
	GameTooltipStatusBar:SetStatusBarTexture(Assets:GetTexture(Settings["ui-widget-texture"]))
	
	GameTooltipStatusBar.BG = GameTooltipStatusBar:CreateTexture(nil, "ARTWORK")
	vUI:SetPoint(GameTooltipStatusBar.BG, "TOPLEFT", GameTooltipStatusBar, 0, 0)
	vUI:SetPoint(GameTooltipStatusBar.BG, "BOTTOMRIGHT", GameTooltipStatusBar, 0, 0)
	GameTooltipStatusBar.BG:SetTexture(Assets:GetTexture(Settings["ui-widget-texture"]))
	GameTooltipStatusBar.BG:SetAlpha(0.2)
	
	GameTooltipStatusBar.Backdrop = CreateFrame("Frame", nil, GameTooltipStatusBar)
	vUI:SetPoint(GameTooltipStatusBar.Backdrop, "TOPLEFT", GameTooltipStatusBar, -1, 1)
	vUI:SetPoint(GameTooltipStatusBar.Backdrop, "BOTTOMRIGHT", GameTooltipStatusBar, 1, -1)
	GameTooltipStatusBar.Backdrop:SetBackdrop(vUI.BackdropAndBorder)
	GameTooltipStatusBar.Backdrop:SetBackdropColor(0, 0, 0)
	GameTooltipStatusBar.Backdrop:SetBackdropBorderColor(0, 0, 0)
	GameTooltipStatusBar.Backdrop:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() - 1)
	
	GameTooltipStatusBar.HealthValue = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY")
	vUI:SetFontInfo(GameTooltipStatusBar.HealthValue, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
	vUI:SetPoint(GameTooltipStatusBar.HealthValue, "LEFT", GameTooltipStatusBar, 3, 0)
	GameTooltipStatusBar.HealthValue:SetJustifyH("LEFT")
	
	GameTooltipStatusBar.HealthPercent = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY")
	vUI:SetFontInfo(GameTooltipStatusBar.HealthPercent, Settings["tooltips-font"], Settings["tooltips-font-size"], Settings["tooltips-font-flags"])
	vUI:SetPoint(GameTooltipStatusBar.HealthPercent, "RIGHT", GameTooltipStatusBar, -3, 0)
	GameTooltipStatusBar.HealthPercent:SetJustifyH("RIGHT")
	
	GameTooltipStatusBar:HookScript("OnValueChanged", OnValueChanged)
	GameTooltipStatusBar:HookScript("OnShow", OnValueChanged)
end

local ItemRefCloseOnEnter = function(self)
	self.Cross:SetVertexColor(vUI:HexToRGB("C0392B"))
end

local ItemRefCloseOnLeave = function(self)
	self.Cross:SetVertexColor(vUI:HexToRGB("EEEEEE"))
end

local ItemRefCloseOnMouseUp = function(self)
	self.Texture:SetVertexColor(vUI:HexToRGB(Settings["ui-header-texture-color"]))
	
	ItemRefTooltip:Hide()
end

local ItemRefCloseOnMouseDown = function(self)
	local R, G, B = vUI:HexToRGB(Settings["ui-header-texture-color"])
	
	self.Texture:SetVertexColor(R * 0.85, G * 0.85, B * 0.85)
end

function Tooltips:SkinItemRef()
	ItemRefCloseButton:Hide()
	
	-- Close button
	local CloseButton = CreateFrame("Frame", nil, ItemRefTooltip)
	vUI:SetSize(CloseButton, 20, 20)
	vUI:SetPoint(CloseButton, "TOPRIGHT", ItemRefTooltip, -3, -3)
	CloseButton:SetBackdrop(vUI.BackdropAndBorder)
	CloseButton:SetBackdropColor(0, 0, 0, 0)
	CloseButton:SetBackdropBorderColor(0, 0, 0)
	CloseButton:SetScript("OnEnter", ItemRefCloseOnEnter)
	CloseButton:SetScript("OnLeave", ItemRefCloseOnLeave)
	CloseButton:SetScript("OnMouseUp", ItemRefCloseOnMouseUp)
	CloseButton:SetScript("OnMouseDown", ItemRefCloseOnMouseDown)
	
	CloseButton.Texture = CloseButton:CreateTexture(nil, "ARTWORK")
	vUI:SetPoint(CloseButton.Texture, "TOPLEFT", CloseButton, 1, -1)
	vUI:SetPoint(CloseButton.Texture, "BOTTOMRIGHT", CloseButton, -1, 1)
	CloseButton.Texture:SetTexture(Assets:GetTexture(Settings["ui-header-texture"]))
	CloseButton.Texture:SetVertexColor(vUI:HexToRGB(Settings["ui-header-texture-color"]))
	
	CloseButton.Cross = CloseButton:CreateTexture(nil, "OVERLAY")
	vUI:SetPoint(CloseButton.Cross, "CENTER", CloseButton, 0, 0)
	vUI:SetSize(CloseButton.Cross, 16, 16)
	CloseButton.Cross:SetTexture(Assets:GetTexture("Close"))
	CloseButton.Cross:SetVertexColor(vUI:HexToRGB("EEEEEE"))
	
	ItemRefTooltip.NewCloseButton = CloseButton
end

function Tooltips:Load()
	if (not Settings["tooltips-enable"]) then
		return
	end
	
	vUI:SetSize(self, 200, 26)
	vUI:SetPoint(self, "BOTTOMRIGHT", UIParent, -13, 101)
	
	self:AddHooks()
	self:StyleStatusBar()
	self:SkinItemRef()
	
	vUI:CreateMover(self)
	
	if IsInGuild() then
		MyGuild = GetGuildInfo("player")
	end
end

local UpdateHealthBarHeight = function(value)
	vUI:SetHeight(GameTooltipStatusBar, value)
end

local UpdateShowHealthText = function(value)
	if (value ~= true) then
		GameTooltipStatusBar.HealthValue:SetText(" ")
		GameTooltipStatusBar.HealthPercent:SetText(" ")
	end
end

GUI:AddOptions(function(self)
	local Left, Right = self:CreateWindow(Language["Tooltips"])
	
	Left:CreateHeader(Language["Enable"])
	Left:CreateSwitch("tooltips-enable", Settings["tooltips-enable"], Language["Enable Tooltips Module"], Language["Enable the vUI tooltips module"]):RequiresReload(true)
	
	Left:CreateHeader(Language["Styling"])
	Left:CreateSlider("tooltips-health-bar-height", Settings["tooltips-health-bar-height"], 2, 30, 1, Language["Health Bar Height"], Language["Set the height of the tooltip health bar"], UpdateHealthBarHeight)
	Left:CreateSwitch("tooltips-show-health-text", Settings["tooltips-show-health-text"], Language["Display Health Text"], Language["Dislay health information on the tooltip health bar"], UpdateShowHealthText)
	Left:CreateSwitch("tooltips-on-cursor", Settings["tooltips-on-cursor"], Language["Tooltip On Cursor"], Language["Anchor the tooltip to the mouse cursor"])
	Left:CreateSwitch("tooltips-show-id", Settings["tooltips-show-id"], Language["Display ID's"], Language["Dislay item and spell ID's in the tooltip"])
	
	Left:CreateHeader(Language["Font"])
	Left:CreateDropdown("tooltips-font", Settings["tooltips-font"], Assets:GetFontList(), Language["Font"], Language["Set the font of the tooltip text"], nil, "Font")
	Left:CreateSlider("tooltips-font-size", Settings["tooltips-font-size"], 8, 18, 1, Language["Font Size"], Language["Set the font size of the tooltip text"])
	Left:CreateDropdown("tooltips-font-flags", Settings["tooltips-font-flags"], Assets:GetFlagsList(), Language["Font Flags"], Language["Set the font flags of the tooltip text"])
	
	Right:CreateHeader(Language["Information"])
	Right:CreateSwitch("tooltips-display-realm", Settings["tooltips-display-realm"], Language["Display Realm"], Language["Display character realms"])
	Right:CreateSwitch("tooltips-display-title", Settings["tooltips-display-title"], Language["Display Title"], Language["Display character titles"])
	
	Right:CreateHeader(Language["Disable Tooltips"])
	Right:CreateDropdown("tooltips-hide-on-unit", Settings["tooltips-hide-on-unit"], {[Language["Never"]] = "NEVER", [Language["Always"]] = "ALWAYS", [Language["Combat"]] = "NO_COMBAT"}, Language["Disable Units"], Language["Set the tooltip to not display units"])
	Right:CreateDropdown("tooltips-hide-on-item", Settings["tooltips-hide-on-item"], {[Language["Never"]] = "NEVER", [Language["Always"]] = "ALWAYS", [Language["Combat"]] = "NO_COMBAT"}, Language["Disable Items"], Language["Set the tooltip to not display items"])
	Right:CreateDropdown("tooltips-hide-on-action", Settings["tooltips-hide-on-action"], {[Language["Never"]] = "NEVER", [Language["Always"]] = "ALWAYS", [Language["Combat"]] = "NO_COMBAT"}, Language["Disable Actions"], Language["Set the tooltip to not display actions"])
end)