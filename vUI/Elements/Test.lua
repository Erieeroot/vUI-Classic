local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

--[[local BC = vUI:NewModule("Buff Count")

function BC:OnEvent(event, unit)
	if (unit ~= "player") then
		return
	end
	
	local Count = 0
	
	for i = 1, 40 do
		local Name = UnitAura("player", i, "HELPFUL")
		
		if (not Name) then
			break
		end
		
		Count = Count + 1
	end
	
	self.Text:SetText(Count)
end

function BC:Load()
	self.Text = UIParent:CreateFontString(nil, "OVERLAY", 7)
	self.Text:SetPoint("CENTER", UIParent, -300, 0)
	vUI:SetFontInfo(self.Text, "Roboto", 64)
	self.Text:SetText("0")
	
	self:RegisterEvent("UNIT_AURA")
	self:SetScript("OnEvent", self.OnEvent)
end]]

--[[
local Languages = {
	["English"] = "enUS",
	["German"] = "deDE",
	["Spanish (Spain)"] = "esES",
	["Spanish (Mexico)"] = "esMX",
	["French"] = "frFR",
	["Italian"] = "itIT",
	["Korean"] = "koKR",
	["Portuguese (Brazil)"] = "ptBR",
	["Russian"] = "ruRU",
	["Chinese (Simplified)"] = "zhCN",
	["Chinese (Traditional)"] = "zhTW",
}

local UpdateLanguage = function(value)
	-- set override language cvar
end

GUI:AddOptions(function(self)
	local Left, Right = self:GetWindow(Language["General"])
	
	Right:CreateHeader(Language["Language"])
	Right:CreateDropdown("ui-language", vUI.UserLocale, Languages, Language["UI Language"], "", ReloadUI):RequiresReload(true)
	Right:CreateButton(Language["Contribute"], Language["Help Localize"], Language["Contribute"], function() vUI:print("") end)
end)
]]
--[[
local IconSize = 40
local IconHeight = floor(IconSize * 0.6)
local IconRatio = (1 - (IconHeight / IconSize)) / 2

local Icon = CreateFrame("Frame", nil, vUI.UIParent)
Icon:SetScaledPoint("CENTER")
Icon:SetScaledSize(IconSize, IconHeight)
Icon:SetBackdrop(vUI.Backdrop)
Icon:SetBackdropColor(0, 0, 0)

Icon.t = Icon:CreateTexture(nil, "OVERLAY")
Icon.t:SetScaledPoint("TOPLEFT", Icon, 1, -1)
Icon.t:SetScaledPoint("BOTTOMRIGHT", Icon, -1, 1)
Icon.t:SetTexture("Interface\\ICONS\\spell_warlock_soulburn")
Icon.t:SetTexCoord(0.1, 0.9, 0.1 + IconRatio, 0.9 - IconRatio)]]