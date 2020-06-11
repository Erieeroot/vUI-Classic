local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

local MicroButtons = vUI:NewModule("Micro Buttons")
local BagsFrame = vUI:GetModule("Bags Frame")

MicroButtons.Buttons = {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	QuestLogMicroButton,
	SocialsMicroButton,
	WorldMapMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
}

local MicroButtonsButtonOnEnter = function(self)
	if (Settings["micro-buttons-visiblity"] == "MOUSEOVER") then
		self:GetParent():SetAlpha(1)
	end
end

local MicroButtonsButtonOnLeave = function(self)
	if (Settings["micro-buttons-visiblity"] == "MOUSEOVER") then
		self:GetParent():SetAlpha(Settings["micro-buttons-opacity"] / 100)
	end
end

function MicroButtons:UpdateVisibility()
	if (Settings["micro-buttons-visiblity"] == "HIDE") then
		self.Panel:SetScript("OnEnter", nil)
		self.Panel:SetScript("OnLeave", nil)
		self.Panel:SetAlpha(0)
		self.Panel:Hide()
	elseif (Settings["micro-buttons-visiblity"] == "MOUSEOVER") then
		self.Panel:SetScript("OnEnter", BagsFrameOnEnter)
		self.Panel:SetScript("OnLeave", BagsFrameOnLeave)
		self.Panel:SetAlpha(Settings["micro-buttons-opacity"] / 100)
		self.Panel:Show()
	elseif (Settings["micro-buttons-visiblity"] == "SHOW") then
		self.Panel:SetScript("OnEnter", nil)
		self.Panel:SetScript("OnLeave", nil)
		self.Panel:SetAlpha(1)
		self.Panel:Show()
	end
end

function MicroButtons:Load()
	if (not Settings["ab-enable"]) then
		return
	end
	
	local Panel = CreateFrame("Frame", "vUI Micro Buttons", vUI.UIParent)
	Panel:SetSize(232, 38)
	Panel:SetPoint("BOTTOMRIGHT", BagsFrame.Panel, "BOTTOMLEFT", -2, 0)
	Panel:SetBackdrop(vUI.BackdropAndBorder)
	Panel:SetBackdropColor(vUI:HexToRGB(Settings["ui-window-bg-color"]))
	Panel:SetBackdropBorderColor(0, 0, 0)
	Panel:SetFrameStrata("LOW")
	
	vUI:CreateMover(Panel)
	
	self.Panel = Panel
	
	local Button
	
	for i = 1, #self.Buttons do
		Button = self.Buttons[i]
		
		Button:SetParent(Panel)
		Button:ClearAllPoints()
		Button:HookScript("OnEnter", MicroButtonsButtonOnEnter)
		Button:HookScript("OnLeave", MicroButtonsButtonOnLeave)
		
		if (i == 1) then
			Button:SetPoint("TOPLEFT", Panel, 0, 20)
		else
			Button:SetPoint("LEFT", self.Buttons[i-1], "RIGHT", 0, 0)
		end
	end
	
	if (not Settings["micro-buttons-show"]) then
		Panel:Hide()
	end
	
	self:UpdateVisibility()
end

local UpdateMicroVisibility = function(value)
	MicroButtons:UpdateVisibility()
end

GUI:AddOptions(function(self)
	local Left, Right = self:GetWindow(Language["Action Bars"])
	
	Right:CreateHeader(Language["Micro Menu Buttons"])
	Right:CreateDropdown("micro-buttons-visiblity", Settings["micro-buttons-visiblity"], {[Language["Hide"]] = "HIDE", [Language["Mouseover"]] = "MOUSEOVER", [Language["Show"]] = "SHOW"}, Language["Set Visibility"], Language["Set the visibility of the micro menu buttons"], UpdateMicroVisibility)
	Right:CreateSlider("micro-buttons-opacity", Settings["micro-buttons-opacity"], 0, 100, 10, Language["Set Faded Opacity"], Language["Set the opacity of the micro menu buttons when visiblity is set to Mouseover"], UpdateMicroVisibility, nil, "%")
end)