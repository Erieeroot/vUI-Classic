local AddOn, Namespace = ...
local tonumber = tonumber
local tostring = tostring
local select = select
local sub = string.sub
local len = string.len
local format = string.format
local floor = math.floor
local match = string.match
local reverse = string.reverse
local min = math.min
local max = math.max
local gsub = gsub
local type = type
local UnitLevel = UnitLevel
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local vUI = CreateFrame("Frame", nil, UIParent)

vUI.Modules = {}

local Core = {
	[1] = vUI, -- Functions/Constants
	[2] = CreateFrame("Frame", nil, UIParent), -- GUI
	[3] = {}, -- Language
	[4] = {}, -- Media
	[5] = {}, -- Settings
	[6] = {}, -- Defaults
	[7] = {}, -- Profiles
}

local Hook = function(self, global, hook)
	if _G[global] then
		local Func
	
		if self[global] then
			Func = self[global]
		elseif (hook and self[hook]) then
			Func = self[hook]
		end
		
		if Func then
			hooksecurefunc(global, Func)
		end
	end
end

local ModuleAddOptions = function(self, func)
	local Left, Right = Core[2]:CreateWindow(self.Name)
	
	if func then
		func(self, Left, Right)
	end
end

function vUI:NewModule(name)
	if self.Modules[name] then
		return self.Modules[name]
	end
	
	local Module = CreateFrame("Frame", name, UIParent)
	
	Module.Name = name
	Module.Loaded = false
	Module.Hook = Hook
	Module.AddOptions = ModuleAddOptions
	
	self.Modules[name] = Module
	self.Modules[#self.Modules + 1] = Module
	
	return Module
end

function vUI:GetModule(name)
	if self.Modules[name] then
		return self.Modules[name]
	end
end

function vUI:LoadModule(name)
	if (not self.Modules[name]) then
		return
	end
	
	local Module = self.Modules[name]
	
	if (not Module.Loaded) and Module.Load then
		Module:Load()
		Module.Loaded = true
	end
end

function vUI:LoadModules()
	for i = 1, #self.Modules do
		if self.Modules[i].Load then
			self.Modules[i]:Load()
		end
	end
end

-- Some Data
vUI.UIVersion = GetAddOnMetadata("vUI", "Version")
vUI.GameVersion = GetBuildInfo()
vUI.TOCVersion = select(4, GetBuildInfo())
vUI.UserName = UnitName("player")
vUI.UserClass = select(2, UnitClass("player"))
vUI.UserClassName = UnitClass("player")
vUI.UserRace = UnitRace("player")
vUI.UserRealm = GetRealmName()
vUI.UserFaction = UnitFactionGroup("player")
vUI.UserLocale = GetLocale()
vUI.UserProfileKey = format("%s:%s", vUI.UserName, vUI.UserRealm)
vUI.UserGoldKey = format("%s:%s:%s", vUI.UserName, vUI.UserRealm, vUI.UserFaction)

if (vUI.UserLocale == "enGB") then
	vUI.UserLocale = "enUS"
end

function vUI:VARIABLES_LOADED(event)
	if (not GetCVar("useUIScale")) then
		SetCVar("useUIScale", 1)
	end
	
	Core[6]["ui-scale"] = self:GetSuggestedScale()
	
	Core[7]:CreateProfileData()
	Core[7]:UpdateProfileList()
	Core[7]:ApplyProfile(Core[7]:GetActiveProfileName())
	
	self:SetScale(Core[5]["ui-scale"])
	self:UpdateoUFColors()
	
	-- Load the GUI
	Core[2]:Create()
	Core[2]:RunQueue()
	
	-- Show the default window, if one was found
	if Core[2].DefaultWindow then
		Core[2]:ShowWindow(Core[2].DefaultWindow)
	end
	
	self:UnregisterEvent(event)
end

function vUI:PLAYER_ENTERING_WORLD(event)
	self:LoadModules()
	self:UnregisterEvent(event)
end

Core[2].Queue = {}

Core[2].CreateWindow = function(self, name, func)
	-- add to a table by name where the function is run when the window is selected. After this and AddToWindow are run, flag for a sort
end

Core[2].AddToWindow = function(self, name, func)
	
end

Core[2].AddOptions = function(self, func)
	if (type(func) == "function") then
		tinsert(self.Queue, func)
	end
end

--[[
	Scale comprehension references:
	https://wow.gamepedia.com/UI_Scale
	https://www.reddit.com/r/WowUI/comments/95o7qc/other_how_to_pixel_perfect_ui_xpost_rwow/
	https://www.wowinterface.com/forums/showthread.php?t=31813
--]]

local Resolution = GetCurrentResolution()
local ScreenHeight
local Scale = 1

function vUI:UpdateScreenHeight()
	Resolution = GetCurrentResolution()
	
	if (Resolution > 0) then -- A fullscreen resolution
		self.ScreenResolution = GetCVar("gxFullscreenResolution")
		self.IsFullScreen = 1
	else -- Windowed
		self.ScreenResolution = GetCVar("gxWindowedResolution")
		self.IsFullScreen = 0
	end
	
	ScreenHeight = tonumber(string.match(self.ScreenResolution, "%d+x(%d+)"))
end

vUI:UpdateScreenHeight()

local GetScale = function(x)
	return floor(Scale * x + 0.5)
end

vUI.GetScale = GetScale

function vUI:SetScale(x)
	x = max(0.4, x)
	x = min(1.2, x)
	
	SetCVar("uiScale", x)
	
	self:UpdateScreenHeight()
	
	Scale = (768 / ScreenHeight) / x
	
	self.BackdropAndBorder.edgeSize = GetScale(x)
	self.Outline.edgeSize = GetScale(x)
end

function vUI:SetSuggestedScale()
	self:SetScale(self:GetSuggestedScale())
end

function vUI:GetSuggestedScale()
	return (768 / ScreenHeight)
end

function vUI:IsClassic()
	return self.TOCVersion <= 20000 and true or false
end

function vUI:ShortValue(num)
	if (num >= 1000000) then
		return format("%.2fm", num / 1000000)
	elseif (num >= 10000) then
		return format("%dk", num / 1000)
	else
		return num
	end
end

function vUI:Comma(number)
	if (not number) then
		return
	end
	
	local Number = format("%.0f", floor(number + 0.5))
   	local Left, Number, Right = match(Number, "^([^%d]*%d)(%d+)(.-)$")
	
	return Left and Left .. reverse(gsub(reverse(Number), "(%d%d%d)", "%1,")) or number
end

function vUI:UnitDifficultyColor(unit)
	local T = 5
	
	if (not Core[T]) then
		T = 6
	end
	
	if (not Core[T]["color-standard"]) then
		return
	end
	
	local Level = UnitLevel("player")
	
	if (Level == -1) then
		return "|cFF" .. Core[T]["color-impossible"]
	end
	
	local Difference = UnitLevel(unit) - Level
	
	if (Difference >= 5) then
		return "|cFF" .. Core[T]["color-impossible"]
	elseif (Difference >= 3) then
		return "|cFF" .. Core[T]["color-verydifficult"]
	elseif (Difference >= -2) then
		return "|cFF" .. Core[T]["color-difficult"]
	elseif (-Difference <= GetQuestGreenRange()) then
		return "|cFF" .. Core[T]["color-standard"]
	else
		return "|cFF" .. Core[T]["color-trivial"]
	end
end

vUI.Backdrop = {
	bgFile = "Interface\\AddOns\\vUI\\Media\\Textures\\Blank.tga",
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

vUI.BackdropAndBorder = {
	bgFile = "Interface\\AddOns\\vUI\\Media\\Textures\\Blank.tga",
	edgeFile = "Interface\\AddOns\\vUI\\Media\\Textures\\Blank.tga",
	edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

vUI.Outline = {
	edgeFile = "Interface\\AddOns\\vUI\\Media\\Textures\\Blank.tga",
	edgeSize = 1,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

function vUI:HexToRGB(hex)
	if (not hex) then
		return
	end
	
	if (len(hex) == 8) then
		return tonumber("0x"..sub(hex, 1, 2)) / 255, tonumber("0x"..sub(hex, 3, 4)) / 255, tonumber("0x"..sub(hex, 5, 6)) / 255, tonumber("0x"..sub(hex, 7, 8)) / 255
	else
		return tonumber("0x"..sub(hex, 1, 2)) / 255, tonumber("0x"..sub(hex, 3, 4)) / 255, tonumber("0x"..sub(hex, 5, 6)) / 255
	end
end

function vUI:RGBToHex(r, g, b)
	return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

function vUI:FormatTime(seconds)
	if (seconds >= 86400) then
		return format("%dd", floor(seconds / 86400 + 0.5))
	elseif (seconds >= 3600) then
		return format("%dh", floor(seconds / 3600 + 0.5))
	elseif (seconds >= 60) then
		return format("%dm", floor(seconds / 60 + 0.5))
	elseif (seconds >= 6) then
		return format("%ds", floor(seconds))
	end
	
	return format("%.1fs", seconds)
end

function vUI:Reset()
	-- Create a prompt
	--vUIData = nil
	vUIProfiles = nil
	vUIProfileData = nil
	
	ReloadUI()
end

local NewPrint = function(...)
	local NumArgs = select("#", ...)
	local String = ""
	
	if (NumArgs == 0) then
		return
	elseif (NumArgs > 1) then
		for i = 1, NumArgs do
			if (i == 1) then
				String = tostring(select(i, ...))
			else
				String = String .. " " .. tostring(select(i, ...))
			end
		end
		
		if vUI.FormatLinks then
			String = vUI.FormatLinks(String)
		end
		
		DEFAULT_CHAT_FRAME:AddMessage(String)
	else
		if vUI.FormatLinks then
			String = vUI.FormatLinks(tostring(...))
			
			DEFAULT_CHAT_FRAME:AddMessage(String)
		else
			DEFAULT_CHAT_FRAME:AddMessage(...)
		end
	end
end

setprinthandler(NewPrint)

function vUI:print(...)
	if Core[5]["ui-widget-color"] then
		print("|cFF" .. Core[5]["ui-widget-color"] .. "vUI|r:", ...)
	else
		print("|cFF" .. Core[6]["ui-widget-color"] .. "vUI|r:", ...)
	end
end

function Namespace:get(key)
	if (not key) then
		return Core[1], Core[2], Core[3], Core[4], Core[5], Core[6], Core[7]
	else
		return Core[key]
	end
end

local SetScaledHeight = function(self, height)
	self:SetHeight(GetScale(height))
end

local SetScaledWidth = function(self, width)
	self:SetWidth(GetScale(width))
end

local SetScaledSize = function(self, width, height)
	self:SetSize(GetScale(width), GetScale(height or width))
end

local SetScaledPoint = function(self, anchor1, parent, anchor2, x, y)
	if (type(parent) == "number") then parent = GetScale(parent) end
	if (type(anchor2) == "number") then anchor2 = GetScale(anchor2) end
	if (type(x) == "number") then x = GetScale(x) end
	if (type(y) == "number") then y = GetScale(y) end
	
	self:SetPoint(anchor1, parent, anchor2, x, y)
end

local SetBackdropColorHex = function(self, hex)
	if hex then
		self:SetBackdropColor(vUI:HexToRGB(hex))
	end
end

local SetBackdropBorderColorHex = function(self, hex)
	if hex then
		self:SetBackdropBorderColor(vUI:HexToRGB(hex))
	end
end

local SetTextColorHex = function(self, hex)
	if hex then
		self:SetTextColor(vUI:HexToRGB(hex))
	end
end

local SetVertexColorHex = function(self, hex)
	if hex then
		self:SetVertexColor(vUI:HexToRGB(hex))
	end
end

local SetStatusBarColorHex = function(self, hex)
	if hex then
		self:SetStatusBarColor(vUI:HexToRGB(hex))
	end
end

local SetFontInfo = function(self, font, size, flags)
	local Font, IsPixel = Core[4]:GetFont(font)
	
	if IsPixel then
		self:SetFont(Font, size, "MONOCHROME, OUTLINE")
		self:SetShadowColor(0, 0, 0, 0)
	else
		self:SetFont(Font, size, flags)
		self:SetShadowColor(0, 0, 0)
		self:SetShadowOffset(1, -1)
	end
end

local AddMethodByReference = function(self, key, newkey, value)
	if (self[key] and not self[newkey]) then
		rawset(self, newkey, value)
	end
end

local Handled = {
	["Frame"] = true, 
	["Texture"] = true,
	["FontString"] = true
}

local Object = vUI
local HandledCount = 0

-- Thank you Tukz for letting me use this script!
local AddMethodsToObject = function(object)
	local Metatable = getmetatable(object).__index
	
	AddMethodByReference(Metatable, "SetHeight", "SetScaledHeight", SetScaledHeight)
	AddMethodByReference(Metatable, "SetWidth", "SetScaledWidth", SetScaledWidth)
	AddMethodByReference(Metatable, "SetSize", "SetScaledSize", SetScaledSize)
	AddMethodByReference(Metatable, "SetPoint", "SetScaledPoint", SetScaledPoint)
	AddMethodByReference(Metatable, "SetBackdropColor", "SetBackdropColorHex", SetBackdropColorHex)
	AddMethodByReference(Metatable, "SetBackdropBorderColor", "SetBackdropBorderColorHex", SetBackdropBorderColorHex)
	AddMethodByReference(Metatable, "SetTextColor", "SetTextColorHex", SetTextColorHex)
	AddMethodByReference(Metatable, "SetVertexColor", "SetVertexColorHex", SetVertexColorHex)
	AddMethodByReference(Metatable, "SetStatusBarColor", "SetStatusBarColorHex", SetStatusBarColorHex)
	AddMethodByReference(Metatable, "SetFont", "SetFontInfo", SetFontInfo)
	
	Handled[object:GetObjectType()] = true
end

AddMethodsToObject(Object)
AddMethodsToObject(Object:CreateTexture())
AddMethodsToObject(Object:CreateFontString())

local HandledCount = 0
Object = EnumerateFrames()

while Object do
	if (not Object:IsForbidden() and not Handled[Object:GetObjectType()]) then
		AddMethodsToObject(Object)
		HandledCount = HandledCount + 1
		
		if (HandledCount == 23) then -- We found everything we need
			break
		end
	end
	
	Object = EnumerateFrames(Object)
end

local OnEvent = function(self, event, ...)
	if self[event] then
		self[event](self, event, ...)
	end
end

vUI:RegisterEvent("VARIABLES_LOADED")
vUI:RegisterEvent("PLAYER_ENTERING_WORLD")
vUI:SetScript("OnEvent", OnEvent)

_G["vUI"] = Namespace