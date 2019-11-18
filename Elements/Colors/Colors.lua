local AddonName, Namespace = ...
local vUI, GUI, Language, Media, Settings, Defaults = Namespace:get()
local oUF = Namespace.oUF

vUI.ClassColors = {}
vUI.ReactionColors = {}
vUI.ZoneColors = {}
vUI.PowerColors = {}
vUI.DebuffColors = {}
vUI.HappinessColors = {}
vUI.ClassificationColors = {}
vUI.ComboPoints = {}
vUI.Totems = {}

function vUI:AddColorEntry(t, key, hex)
	R, G, B = self:HexToRGB(hex)
	
	if (not t[key]) then
		t[key] = {}
	end
	
	t[key][1] = R
	t[key][2] = G
	t[key][3] = B
	t[key]["Hex"] = hex
end

function vUI:UpdateClassColors()
	self:AddColorEntry(self.ClassColors, "DEATHKNIGHT", Settings["color-death-knight"])
	self:AddColorEntry(self.ClassColors, "DEMONHUNTER", Settings["color-demon-hunter"])
	self:AddColorEntry(self.ClassColors, "DRUID", Settings["color-druid"])
	self:AddColorEntry(self.ClassColors, "HUNTER", Settings["color-hunter"])
	self:AddColorEntry(self.ClassColors, "MAGE", Settings["color-mage"])
	self:AddColorEntry(self.ClassColors, "MONK", Settings["color-monk"])
	self:AddColorEntry(self.ClassColors, "PALADIN", Settings["color-paladin"])
	self:AddColorEntry(self.ClassColors, "PRIEST", Settings["color-priest"])
	self:AddColorEntry(self.ClassColors, "ROGUE", Settings["color-rogue"])
	self:AddColorEntry(self.ClassColors, "SHAMAN", Settings["color-shaman"])
	self:AddColorEntry(self.ClassColors, "WARLOCK", Settings["color-warlock"])
	self:AddColorEntry(self.ClassColors, "WARRIOR", Settings["color-warrior"])
end

function vUI:UpdateReactionColors()
	self:AddColorEntry(self.ReactionColors, 1, Settings["color-reaction-1"])
	self:AddColorEntry(self.ReactionColors, 2, Settings["color-reaction-2"])
	self:AddColorEntry(self.ReactionColors, 3, Settings["color-reaction-3"])
	self:AddColorEntry(self.ReactionColors, 4, Settings["color-reaction-4"])
	self:AddColorEntry(self.ReactionColors, 5, Settings["color-reaction-5"])
	self:AddColorEntry(self.ReactionColors, 6, Settings["color-reaction-6"])
	self:AddColorEntry(self.ReactionColors, 7, Settings["color-reaction-7"])
	self:AddColorEntry(self.ReactionColors, 8, Settings["color-reaction-8"])
end

function vUI:UpdateZoneColors()
	self:AddColorEntry(self.ZoneColors, "sanctuary", Settings["color-sanctuary"])
	self:AddColorEntry(self.ZoneColors, "arena", Settings["color-arena"])
	self:AddColorEntry(self.ZoneColors, "hostile", Settings["color-hostile"])
	self:AddColorEntry(self.ZoneColors, "combat", Settings["color-combat"])
	self:AddColorEntry(self.ZoneColors, "friendly", Settings["color-friendly"])
	self:AddColorEntry(self.ZoneColors, "contested", Settings["color-contested"])
	self:AddColorEntry(self.ZoneColors, "other", Settings["color-other"])
end

function vUI:UpdatePowerColors()
	self:AddColorEntry(self.PowerColors, "MANA", Settings["color-mana"])
	self:AddColorEntry(self.PowerColors, "RAGE", Settings["color-rage"])
	self:AddColorEntry(self.PowerColors, "ENERGY", Settings["color-energy"])
	self:AddColorEntry(self.PowerColors, "FOCUS", Settings["color-focus"])
end

function vUI:UpdateDebuffColors()
	self:AddColorEntry(self.DebuffColors, "Curse", Settings["color-curse"])
	self:AddColorEntry(self.DebuffColors, "Disease", Settings["color-disease"])
	self:AddColorEntry(self.DebuffColors, "Magic", Settings["color-magic"])
	self:AddColorEntry(self.DebuffColors, "Poison", Settings["color-poison"])
	self:AddColorEntry(self.DebuffColors, "none", Settings["color-none"])
end

function vUI:UpdateHappinessColors()
	self:AddColorEntry(self.HappinessColors, 1, Settings["color-happiness-1"])
	self:AddColorEntry(self.HappinessColors, 2, Settings["color-happiness-2"])
	self:AddColorEntry(self.HappinessColors, 3, Settings["color-happiness-3"])
end

function vUI:UpdateClassificationColors()
	self:AddColorEntry(self.ClassificationColors, "trivial", Settings["color-trivial"])
	self:AddColorEntry(self.ClassificationColors, "standard", Settings["color-standard"])
	self:AddColorEntry(self.ClassificationColors, "difficult", Settings["color-difficult"])
	self:AddColorEntry(self.ClassificationColors, "verydifficult", Settings["color-verydifficult"])
	self:AddColorEntry(self.ClassificationColors, "impossible", Settings["color-impossible"])
end

function vUI:UpdateComboColors()
	self:AddColorEntry(self.ComboPoints, 1, Settings["color-combo-1"])
	self:AddColorEntry(self.ComboPoints, 2, Settings["color-combo-2"])
	self:AddColorEntry(self.ComboPoints, 3, Settings["color-combo-3"])
	self:AddColorEntry(self.ComboPoints, 4, Settings["color-combo-4"])
	self:AddColorEntry(self.ComboPoints, 5, Settings["color-combo-5"])
end

function vUI:UpdateTotemColors()
	self:AddColorEntry(self.Totems, 1, Settings["color-totem-fire"])
	self:AddColorEntry(self.Totems, 2, Settings["color-totem-earth"])
	self:AddColorEntry(self.Totems, 3, Settings["color-totem-water"])
	self:AddColorEntry(self.Totems, 4, Settings["color-totem-air"])
end

GUI:AddOptions(function(self)
	local Left, Right = self:CreateWindow(Language["Colors"])
	
	Left:CreateHeader(Language["Class Colors"])
	--Left:CreateColorSelection("color-death-knight", Settings["color-death-knight"], Language["Death Knight"], "")
	--Left:CreateColorSelection("color-demon-hunter", Settings["color-demon-hunter"], Language["Demon Hunter"], "")
	Left:CreateColorSelection("color-druid", Settings["color-druid"], Language["Druid"], "")
	Left:CreateColorSelection("color-hunter", Settings["color-hunter"], Language["Hunter"], "")
	Left:CreateColorSelection("color-mage", Settings["color-mage"], Language["Mage"], "")
	--Left:CreateColorSelection("color-monk", Settings["color-monk"], Language["Monk"], "")
	Left:CreateColorSelection("color-paladin", Settings["color-paladin"], Language["Paladin"], "")
	Left:CreateColorSelection("color-priest", Settings["color-priest"], Language["Priest"], "")
	Left:CreateColorSelection("color-rogue", Settings["color-rogue"], Language["Rogue"], "")
	Left:CreateColorSelection("color-shaman", Settings["color-shaman"], Language["Shaman"], "")
	Left:CreateColorSelection("color-warlock", Settings["color-warlock"], Language["Warlock"], "")
	Left:CreateColorSelection("color-warrior", Settings["color-warrior"], Language["Warrior"], "")
	
	Right:CreateHeader(Language["Power Colors"])
	Right:CreateColorSelection("color-mana", Settings["color-mana"], Language["Mana"], "")
	Right:CreateColorSelection("color-rage", Settings["color-rage"], Language["Rage"], "")
	Right:CreateColorSelection("color-energy", Settings["color-energy"], Language["Energy"], "")
	Right:CreateColorSelection("color-focus", Settings["color-focus"], Language["Focus"], "")
	
	Left:CreateHeader(Language["Zone Colors"])
	Left:CreateColorSelection("color-sanctuary", Settings["color-sanctuary"], "Sanctuary", "")
	Left:CreateColorSelection("color-arena", Settings["color-arena"], "Arena", "")
	Left:CreateColorSelection("color-hostile", Settings["color-hostile"], "Hostile", "")
	Left:CreateColorSelection("color-combat", Settings["color-combat"], "Combat", "")
	Left:CreateColorSelection("color-contested", Settings["color-contested"], "Contested", "")
	Left:CreateColorSelection("color-friendly", Settings["color-friendly"], "Friendly", "")
	Left:CreateColorSelection("color-other", Settings["color-other"], "Other", "")
	
	Right:CreateHeader(Language["Reaction Colors"])
	Right:CreateColorSelection("color-reaction-8", Settings["color-reaction-8"], Language["Exalted"], "")
	Right:CreateColorSelection("color-reaction-7", Settings["color-reaction-7"], Language["Revered"], "")
	Right:CreateColorSelection("color-reaction-6", Settings["color-reaction-6"], Language["Honored"], "")
	Right:CreateColorSelection("color-reaction-5", Settings["color-reaction-5"], Language["Friendly"], "")
	Right:CreateColorSelection("color-reaction-4", Settings["color-reaction-4"], Language["Neutral"], "")
	Right:CreateColorSelection("color-reaction-3", Settings["color-reaction-3"], Language["Unfriendly"], "")
	Right:CreateColorSelection("color-reaction-2", Settings["color-reaction-2"], Language["Hostile"], "")
	Right:CreateColorSelection("color-reaction-1", Settings["color-reaction-1"], Language["Hated"], "")
	
	Right:CreateHeader(Language["Debuff Colors"])
	Right:CreateColorSelection("color-curse", Settings["color-curse"], Language["Curse"], "")
	Right:CreateColorSelection("color-disease", Settings["color-disease"], Language["Disease"], "")
	Right:CreateColorSelection("color-magic", Settings["color-magic"], Language["Magic"], "")
	Right:CreateColorSelection("color-poison", Settings["color-poison"], Language["Poison"], "")
	Right:CreateColorSelection("color-none", Settings["color-none"], Language["None"], "")
	
	Right:CreateHeader(Language["Pet Happiness Colors"])
	Right:CreateColorSelection("color-happiness-3", Settings["color-happiness-3"], Language["Happy"], "")
	Right:CreateColorSelection("color-happiness-2", Settings["color-happiness-2"], Language["Content"], "")
	Right:CreateColorSelection("color-happiness-1", Settings["color-happiness-1"], Language["Unhappy"], "")
	
	Left:CreateHeader(Language["Difficulty Colors"])
	Left:CreateColorSelection("color-trivial", Settings["color-trivial"], Language["Very Easy"], "")
	Left:CreateColorSelection("color-standard", Settings["color-standard"], Language["Easy"], "")
	Left:CreateColorSelection("color-difficult", Settings["color-difficult"], Language["Medium"], "")
	Left:CreateColorSelection("color-verydifficult", Settings["color-verydifficult"], Language["Hard"], "")
	Left:CreateColorSelection("color-impossible", Settings["color-impossible"], Language["Very Hard"], "")
	
	Left:CreateHeader(Language["Combo Points Colors"])
	Left:CreateColorSelection("color-combo-1", Settings["color-combo-1"], Language["Combo Point 1"], "")
	Left:CreateColorSelection("color-combo-2", Settings["color-combo-2"], Language["Combo Point 2"], "")
	Left:CreateColorSelection("color-combo-3", Settings["color-combo-3"], Language["Combo Point 3"], "")
	Left:CreateColorSelection("color-combo-4", Settings["color-combo-4"], Language["Combo Point 4"], "")
	Left:CreateColorSelection("color-combo-5", Settings["color-combo-5"], Language["Combo Point 5"], "")
	
	Right:CreateHeader(Language["Misc Colors"])
	Right:CreateColorSelection("color-tapped", Settings["color-tapped"], Language["Tagged"], "")
	Right:CreateColorSelection("color-disconnected", Settings["color-disconnected"], Language["Disconnected"], "")
	
	Right:CreateHeader(Language["Casting"])
	Right:CreateColorSelection("color-casting-start", Settings["color-casting-start"], Language["Casting"], "")
	Right:CreateColorSelection("color-casting-stopped", Settings["color-casting-stopped"], Language["Stopped"], "")
	Right:CreateColorSelection("color-casting-interrupted", Settings["color-casting-interrupted"], Language["Interrupted"], "")
	
	vUI:UpdateClassColors()
	vUI:UpdateReactionColors()
	vUI:UpdateZoneColors()
	vUI:UpdatePowerColors()
	vUI:UpdateDebuffColors()
	vUI:UpdateHappinessColors()
	vUI:UpdateClassificationColors()
	vUI:UpdateComboColors()
	vUI:UpdateTotemColors()
end)