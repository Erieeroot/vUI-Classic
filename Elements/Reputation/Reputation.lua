local vUI, GUI, Language, Media, Settings = select(2, ...):get()

local Reputation = vUI:NewModule("Reputation")

local format = format
local floor = floor
local GetWatchedFactionInfo = GetWatchedFactionInfo

local FadeOnFinished = function(self)
	self.Parent:Hide()
end

function Reputation:UpdateBarPosition(value)
	local WidthWidget = GUI:GetWidgetByWindow(Language["Reputation"], "reputation-width")
	local HeightWidget = GUI:GetWidgetByWindow(Language["Reputation"], "reputation-height")
	
	self:ClearAllPoints()
	
	if (value == "TOP") then
		self.BGAll:Show()
		self:SetScaledSize(Settings["reputation-width"], Settings["reputation-height"])
		self.Bar.Spark:SetScaledHeight(Settings["reputation-height"])
		
		if (Settings["experience-enable"] and Settings["experience-position"] == "TOP") then
			self:SetScaledPoint("TOP", vUIExperienceBar, "BOTTOM", 0, -8)
		else
			self:SetScaledPoint("TOP", UIParent, 0, -13)
		end
		
		vUIChatFrameBottom:Show()
		
		if vUIBottomActionBarsPanel then
			vUIBottomActionBarsPanel:ClearAllPoints()
			
			if (Settings["experience-enable"] and Settings["experience-position"] ~= "CLASSIC") then
				vUIBottomActionBarsPanel:SetScaledPoint("BOTTOM", UIParent, 0, 10)
			else
				vUIBottomActionBarsPanel:SetScaledPoint("BOTTOM", vUIExperienceBar, "TOP", 0, 5)
			end
		end
		
		WidthWidget:Enable()
		HeightWidget:Enable()
	elseif (value == "CHATFRAME") then
		vUIChatFrameBottom:Hide()
		
		local Height = vUIChatFrameBottom:GetHeight()
		
		self.BGAll:Hide()
		self:SetScaledSize(vUIChatFrameBottom:GetWidth(), Height)
		self:SetScaledPoint("CENTER", vUIChatFrameBottom, 0, 0)
		
		self.Bar.Spark:SetScaledHeight(Height)
		
		if vUIBottomActionBarsPanel then
			vUIBottomActionBarsPanel:ClearAllPoints()
			
			if (Settings["experience-enable"] and Settings["experience-position"] ~= "CLASSIC") then
				vUIBottomActionBarsPanel:SetScaledPoint("BOTTOM", UIParent, 0, 10)
			else
				vUIBottomActionBarsPanel:SetScaledPoint("BOTTOM", vUIExperienceBar, "TOP", 0, 5)
			end
		end
		
		WidthWidget:Disable()
		HeightWidget:Disable()
	elseif (value == "CLASSIC") then
		vUIChatFrameBottom:Show()
		
		self.BGAll:Show()
		self:SetScaledHeight(Settings["reputation-height"])
		self:SetScaledPoint("BOTTOM", UIParent, 0, 13)
		self.Bar.Spark:SetScaledHeight(Settings["reputation-height"])
		
		if vUIBottomActionBarsPanel then
			vUIBottomActionBarsPanel:ClearAllPoints()
			vUIBottomActionBarsPanel:SetScaledPoint("BOTTOM", self, "TOP", 0, 5)
			
			self:SetScaledWidth(vUIBottomActionBarsPanel:GetWidth() - 6)
		end
		
		WidthWidget:Disable()
		HeightWidget:Enable()
	end
end

function Reputation:CreateBar()
	if (not Settings["reputation-enable"]) then
		self:UnregisterAllEvents()
		
		return
	end
	
	self:SetScaledSize(Settings["reputation-width"], Settings["reputation-height"])
	self:SetFrameStrata("HIGH")
	
	self.Fade = CreateAnimationGroup(self)
	
	self.FadeIn = self.Fade:CreateAnimation("Fade")
	self.FadeIn:SetEasing("in")
	self.FadeIn:SetDuration(0.15)
	self.FadeIn:SetChange(1)
	
	self.FadeOut = self.Fade:CreateAnimation("Fade")
	self.FadeOut:SetEasing("out")
	self.FadeOut:SetDuration(0.15)
	self.FadeOut:SetChange(0)
	self.FadeOut:SetScript("OnFinished", FadeOnFinished)
	
	self.BarBG = CreateFrame("Frame", nil, self)
	self.BarBG:SetScaledPoint("TOPLEFT", self, 0, 0)
	self.BarBG:SetScaledPoint("BOTTOMRIGHT", self, 0, 0)
	self.BarBG:SetBackdrop(vUI.BackdropAndBorder)
	self.BarBG:SetBackdropColorHex(Settings["ui-window-main-color"])
	self.BarBG:SetBackdropBorderColor(0, 0, 0)
	
	self.Texture = self.BarBG:CreateTexture(nil, "ARTWORK")
	self.Texture:SetScaledPoint("TOPLEFT", self.BarBG, 1, -1)
	self.Texture:SetScaledPoint("BOTTOMRIGHT", self.BarBG, -1, 1)
	self.Texture:SetTexture(Media:GetTexture(Settings["ui-header-texture"]))
	self.Texture:SetVertexColorHex(Settings["ui-window-main-color"])
	
	self.BGAll = CreateFrame("Frame", nil, self)
	self.BGAll:SetScaledPoint("TOPLEFT", self.BarBG, -3, 3)
	self.BGAll:SetScaledPoint("BOTTOMRIGHT", self.BarBG, 3, -3)
	self.BGAll:SetBackdrop(vUI.BackdropAndBorder)
	self.BGAll:SetBackdropColorHex(Settings["ui-window-bg-color"])
	self.BGAll:SetBackdropBorderColor(0, 0, 0)
	
	self.Bar = CreateFrame("StatusBar", nil, self.BarBG)
	self.Bar:SetStatusBarTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.Bar:SetScaledPoint("TOPLEFT", self.BarBG, 1, -1)
	self.Bar:SetScaledPoint("BOTTOMRIGHT", self.BarBG, -1, 1)
	self.Bar:SetFrameLevel(6)
	
	self.Bar.BG = self.Bar:CreateTexture(nil, "BORDER")
	self.Bar.BG:SetAllPoints(self.Bar)
	self.Bar.BG:SetTexture(Media:GetTexture(Settings["ui-widget-texture"]))
	self.Bar.BG:SetVertexColorHex(Settings["ui-window-main-color"])
	self.Bar.BG:SetAlpha(0.2)
	
	self.Bar.Spark = self.Bar:CreateTexture(nil, "OVERLAY")
	self.Bar.Spark:SetDrawLayer("OVERLAY", 7)
	self.Bar.Spark:SetScaledSize(1, Settings["reputation-height"])
	self.Bar.Spark:SetScaledPoint("LEFT", self.Bar:GetStatusBarTexture(), "RIGHT", 0, 0)
	self.Bar.Spark:SetTexture(Media:GetTexture("Blank"))
	self.Bar.Spark:SetVertexColor(0, 0, 0)
	
	self.Shine = self.Bar:CreateTexture(nil, "ARTWORK")
	self.Shine:SetAllPoints(self.Bar:GetStatusBarTexture())
	self.Shine:SetTexture(Media:GetTexture("pHishTex12"))
	self.Shine:SetVertexColor(1, 1, 1)
	self.Shine:SetAlpha(0)
	self.Shine:SetDrawLayer("ARTWORK", 7)
	
	self.Change = CreateAnimationGroup(self.Bar):CreateAnimation("Progress")
	self.Change:SetOrder(1)
	self.Change:SetEasing("inout")
	self.Change:SetDuration(0.3)
	
	self.Progress = self.Bar:CreateFontString(nil, "OVERLAY")
	self.Progress:SetScaledPoint("LEFT", self.Bar, 5, 0)
	self.Progress:SetFontInfo(Settings["ui-widget-font"], Settings["ui-font-size"])
	self.Progress:SetJustifyH("LEFT")
	
	if (not Settings["reputation-display-progress"]) then
		self.Progress:Hide()
	end
	
	self.Percentage = self.Bar:CreateFontString(nil, "OVERLAY")
	self.Percentage:SetScaledPoint("RIGHT", self.Bar, -5, 0)
	self.Percentage:SetFontInfo(Settings["ui-widget-font"], Settings["ui-font-size"])
	self.Percentage:SetJustifyH("RIGHT")
	
	if (not Settings["reputation-display-percent"]) then
		self.Percentage:Hide()
	end
	
	self:UpdateBarPosition(Settings["reputation-position"])
end

function Reputation:OnEvent()
	local Name, Standing, Min, Max, Value, FactionID = GetWatchedFactionInfo()
	
	if Name then
		Max = Max - Min
		Value = Value - Min
		
		self.Bar:SetMinMaxValues(0, Max)
		self.Bar:SetStatusBarColorHex(Settings["color-reaction-" .. Standing])
		
		self.Progress:SetText(format("%s: %s / %s", Name, vUI:Comma(Value), vUI:Comma(Max)))
		self.Percentage:SetText(floor((Value / Max * 100 + 0.05) * 10) / 10 .. "%")
		
		self.Change:SetChange(Value)
		self.Change:Play()
		
		if (not self:IsShown()) then
			self:Show()
			self.FadeIn:Play()
		end
	elseif self:IsShown() then
		self.FadeOut:Play()
	end
end

function Reputation:Load()
	if (not Settings["reputation-enable"]) then
		return
	end
	
	self:CreateBar()
	self:OnEvent()
	
	self:RegisterEvent("UPDATE_FACTION")
	self:SetScript("OnEvent", self.OnEvent)
end

local UpdateDisplayProgress = function(value)
	if value then
		Reputation.Progress:Show()
	else
		Reputation.Progress:Hide()
	end
end

local UpdateDisplayPercent = function(value)
	if value then
		Reputation.Percentage:Show()
	else
		Reputation.Percentage:Hide()
	end
end

local UpdateBarWidth = function(value)
	if (Settings["reputation-position"] ~= "CHATFRAME") then
		Reputation:SetScaledWidth(value)
	end
end

local UpdateBarHeight = function(value)
	if (Settings["reputation-position"] ~= "CHATFRAME") then
		Reputation:SetScaledHeight(value)
		Reputation.Bar.Spark:SetScaledHeight(value)
	end
end

local UpdateBarPosition = function(value)
	Reputation:UpdateBarPosition(value)
end

GUI:AddOptions(function(self)
	local Left, Right = self:CreateWindow(Language["Reputation"])
	
	Left:CreateHeader(Language["Enable"])
	Left:CreateSwitch("reputation-enable", true, Language["Enable Reputation Module"], "Enable the vUI reputation module", ReloadUI):RequiresReload(true)
	
	Left:CreateHeader(Language["Styling"])
	Left:CreateSwitch("reputation-display-progress", Settings["reputation-display-progress"], Language["Display Progress Value"], "Display your current progress|ninformation in the reputation bar", UpdateDisplayProgress)
	Left:CreateSwitch("reputation-display-percent", Settings["reputation-display-percent"], Language["Display Percent Value"], "Display your current percent|ninformation in the reputation bar", UpdateDisplayPercent)
	
	Right:CreateHeader(Language["Size"])
	Right:CreateSlider("reputation-width", Settings["reputation-width"], 240, 400, 10, Language["Bar Width"], "Set the width of the reputation bar", UpdateBarWidth)
	Right:CreateSlider("reputation-height", Settings["reputation-height"], 6, 30, 1, Language["Bar Height"], "Set the height of the reputation bar", UpdateBarHeight)
	
	Right:CreateHeader(Language["Positioning"])
	Right:CreateDropdown("reputation-position", Settings["reputation-position"], {[Language["Top"]] = "TOP", [Language["Chat Frame"]] = "CHATFRAME", [Language["Classic"]] = "CLASSIC"}, Language["Set Position"], "Set the position of the reputation bar", UpdateBarPosition)
	
	--Right:CreateHeader(Language["Visibility"])
	--Right:CreateDropdown("reputation-progress-visibility", Settings["reputation-progress-visibility"], {[Language["Always Show"]] = "ALWAYS", [Language["Mouseover"]] = "MOUSEOVER"}, Language["Progress Text"], "Set when to display the progress information", UpdateProgressVisibility)
	--Right:CreateDropdown("reputation-percent-visibility", Settings["reputation-percent-visibility"], {[Language["Always Show"]] = "ALWAYS", [Language["Mouseover"]] = "MOUSEOVER"}, Language["Percent Text"], "Set when to display the percent information", UpdatePercentVisibility)
end)