local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

local KeyBinding = vUI:NewModule("Key Binding")

local GetMouseFocus = GetMouseFocus
local match = string.match

KeyBinding.ValidBindings = {
	["ACTIONBUTTON"] = true,
	["BONUSACTIONBUTTON"] = true,
	["MULTIACTIONBAR1BUTTON"] = true,
	["MULTIACTIONBAR2BUTTON"] = true,
	["MULTIACTIONBAR3BUTTON"] = true,
	["MULTIACTIONBAR4BUTTON"] = true,
	["SHAPESHIFTBUTTON"] = true,
}

KeyBinding.Translate = {
	["ActionButton"] = "ACTIONBUTTON",
	["MultiBarBottomLeftButton"] = "MULTIACTIONBAR1BUTTON",
	["MultiBarBottomRightButton"] = "MULTIACTIONBAR2BUTTON",
	["MultiBarRightButton"] = "MULTIACTIONBAR3BUTTON",
	["MultiBarLeftButton"] = "MULTIACTIONBAR4BUTTON",
}

KeyBinding.Filter = {
	["BACKSPACE"] = true,
	["LALT"] = true,
	["RALT"] = true,
	["LCTRL"] = true,
	["RCTRL"] = true,
	["LSHIFT"] = true,
	["RSHIFT"] = true,
	["ENTER"] = true,
	["LeftButton"] = true,
	["RightButton"] = true,
}

function KeyBinding:OnKeyUp(key)
	if (not IsKeyPressIgnoredForBinding(key) and not self.Filter[key] and self.TargetBindingName) then
		if (key == "ESCAPE") then
			local Binding = GetBindingKey(self.TargetBindingName)
			
			if Binding then
				SetBinding(Binding)
			end
			
			return
		end
		
		key = format("%s%s%s%s", IsAltKeyDown() and "ALT-" or "", IsControlKeyDown() and "CTRL-" or "", IsShiftKeyDown() and "SHIFT-" or "", key)
		
		local OldAction = GetBindingAction(key, true)
		
		if OldAction then
			local OldName = GetBindingName(OldAction)
			
			vUI:print(format(Language['Unbound "%s" from %s'], key, OldName))
		end
		
		SetBinding(key, self.TargetBindingName, 1)
		
		local NewAction = GetBindingAction(key, true)
		local NewName = GetBindingName(NewAction)
		
		vUI:print(format(Language['Bound "%s" to %s'], key, NewName))
		
		GUI:GetWidget(Language["General"], Language["Action Bars"], "save"):Enable()
		GUI:GetWidget(Language["General"], Language["Action Bars"], "discard"):Enable()
	end
end

function KeyBinding:OnKeyDown(key)
	local MouseFocus = GetMouseFocus()
	
	if (MouseFocus and MouseFocus.GetName) then
		local Name = MouseFocus:GetName()
		
		if (not Name) then
			return
		end
		
		local ButtonName = match(Name, "%D+")
		if self.Translate[ButtonName] then
			if self.ValidBindings[self.Translate[ButtonName]] then
				self.TargetBindingName = self.Translate[ButtonName] .. match(Name, "(%d+)$")
			end
		end
	end
end

function KeyBinding:OnEvent(event, button)
	local MouseFocus = GetMouseFocus()
	print(event, button)
	if (MouseFocus and MouseFocus.GetName) then
		local Name = MouseFocus:GetName()
		
		if (not Name) then
			return
		end
		
		local ButtonName = match(Name, "%D+")
		if self.Translate[ButtonName] then
			if self.ValidBindings[self.Translate[ButtonName]] then
				self.TargetBindingName = self.Translate[ButtonName] .. match(Name, "(%d+)$")
			end
		end
	end
	
	if (not self.Filter[button] and self.TargetBindingName) then
		if (button == "MiddleButton") then
			button = "BUTTON3"
		end
		
		if match(button, "Button%d+") then
			button = string.upper(button)
		end
		
		button = format("%s%s%s%s", IsAltKeyDown() and "ALT-" or "", IsControlKeyDown() and "CTRL-" or "", IsShiftKeyDown() and "SHIFT-" or "", button)
		
		local OldAction = GetBindingAction(button, true)
		
		if OldAction then
			local OldName = GetBindingName(OldAction)
			
			vUI:print(format(Language['Unbound "%s" from %s'], button, OldName))
		end
		
		SetBinding(button, self.TargetBindingName, 1)
		
		local NewAction = GetBindingAction(button, true)
		local NewName = GetBindingName(NewAction)
		
		vUI:print(format(Language['Bound "%s" to %s'], button, NewName))
		
		GUI:GetWidget(Language["General"], Language["Action Bars"], "discard")Enable()
		GUI:GetWidget(Language["General"], Language["Action Bars"], "save"):Enable()
	end
end

function KeyBinding:OnUpdate(elapsed)
	self.Elapsed = self.Elapsed + elapsed
	
	if (self.Elapsed > 0.05) then
		local MouseFocus = GetMouseFocus()
		
		if (MouseFocus and MouseFocus.action) then
			self.Hover:SetPoint("TOPLEFT", MouseFocus, 1, -1)
			self.Hover:SetPoint("BOTTOMRIGHT", MouseFocus, -1, 1)
			self.Hover:Show()
		elseif self.Hover:IsShown() then
			self.Hover:Hide()
		end
		
		self.Elapsed = 0
	end
end

local OnAccept = function()
	AttemptToSaveBindings(GetCurrentBindingSet())
	
		GUI:GetWidget(Language["General"], Language["Action Bars"], "discard")Disable()
		GUI:GetWidget(Language["General"], Language["Action Bars"], "save"):Disable()
	
	KeyBinding:Disable()
end

local OnCancel = function()
	KeyBinding:Disable()
end

function KeyBinding:Enable()
	--self:RegisterEvent("GLOBAL_MOUSE_UP")
	self.Hover:EnableMouse(true)
	self:EnableKeyboard(true)
	self:SetScript("OnUpdate", self.OnUpdate)
	self:SetScript("OnKeyDown", self.OnKeyDown)
	self:SetScript("OnKeyUp", self.OnKeyUp)
	self.Hover:SetScript("OnMouseUp", self.OnEvent)
	self.Active = true
	
	vUI:DisplayPopup(Language["Attention"], Language["Key binding mode is active. Would you like to save your changes?"], Language["Save"], OnAccept, Language["Cancel"], OnCancel)
end

function KeyBinding:Disable()
	--self:UnregisterEvent("GLOBAL_MOUSE_UP")
	self.Hover:EnableMouse(false)
	self:EnableKeyboard(false)
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnKeyDown", nil)
	self:SetScript("OnKeyUp", nil)
	self.Hover:SetScript("OnMouseUp", nil)
	self.Active = false
	self.TargetBindingName = nil
	
	vUI:ClearPopup()
end

function KeyBinding:Toggle()
	if self.Active then
		self:Disable()
	else
		self:Enable()
	end
end

function KeyBinding:Load()
	self.Elapsed = 0
	
	self.Hover = CreateFrame("Frame", nil, self)
	self.Hover:SetFrameLevel(50)
	self.Hover:SetFrameStrata("DIALOG")
	self.Hover:SetBackdrop(vUI.BackdropAndBorder)
	self.Hover:SetBackdropColor(vUI:HexToRGB("FFC44D"))
	self.Hover:SetBackdropBorderColor(vUI:HexToRGB("FFC44D"))
	self.Hover:SetAlpha(0.6)
	self.Hover:Hide()
end

local ToggleBindingMode = function()
	KeyBinding:Toggle()
end

local SaveChanges = function()
	vUI:DisplayPopup(Language["Attention"], Language["Are you sure you would like to save these key binding changes?"], Language["Accept"], OnAccept, Language["Cancel"], OnCancel)
end

local DiscardChanges = function()
	vUI:DisplayPopup(Language["Attention"], Language["Are you sure you would like to discard these key binding changes?"], Language["Accept"], ReloadUI, Language["Cancel"])
end

GUI:AddSettings(Language["General"], Language["Action Bars"], function(left, right)
	right:CreateHeader(Language["Key Binding"])
	right:CreateButton(Language["Toggle"], Language["Key Bind Mode"], Language["While toggled, you can hover over action buttons and press a key combination to rebind them"], ToggleBindingMode)
	right:CreateButton(Language["Save"], Language["Save Changes"], Language["Save key binding changes"], SaveChanges)
	right:CreateButton(Language["Discard"], Language["Discard Changes"], Language["Discard key binding changes"], DiscardChanges)
	
	--self:GetWidgetByWindow(Language["Action Bars"], "save"):Disable()
	--self:GetWidgetByWindow(Language["Action Bars"], "discard"):Disable()
end)