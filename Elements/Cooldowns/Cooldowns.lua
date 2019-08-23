local vUI, GUI, Language, Media, Settings = select(2, ...):get()

local Cooldowns = vUI:NewModule("Cooldowns")

local GetItemCooldown = GetItemCooldown
local GetSpellCooldown = GetSpellCooldown
local GetSpellTexture = GetSpellTexture
local GetItemInfo = GetItemInfo
local GetTime = GetTime
local tinsert = table.insert
local tremove = table.remove
local pairs = pairs

local CD = CreateFrame("Frame")
local ActiveCount = 0
local MinTreshold = 14
local Running = false
local CurrentTime
local Remaining
local GetCD
local Spells = {}
local Elapsed = 0
local Delay = 0.5

local ActiveCDs = {
	["item"] = {},
	["player"] = {},
}

local Blacklist = {
	["item"] = {
		[6948] = true, -- Hearthstone
		[140192] = true, -- Dalaran Hearthstone
		[110560] = true, -- Garrison Hearthstone
	},
	
	["player"] = {
		[125439] = true, -- Revive Battle Pets
	},
}

local GetTexture = function(cd, id)
	if (cd == "item") then
		return select(10, GetItemInfo(id))
	else
		return GetSpellTexture(id)
	end
end

local Frame = CreateFrame("Frame", nil, UIParent)
Frame:SetScaledSize(60, 60)
Frame:SetScaledPoint("CENTER", UIParent, "CENTER", 0, 100) -- -300
Frame:SetBackdrop(vUI.Backdrop)
Frame:SetBackdropColor(0, 0, 0)
Frame:SetAlpha(0)

Frame.Icon = Frame:CreateTexture(nil, "OVERLAY")
Frame.Icon:SetScaledPoint("TOPLEFT", Frame, 1, -1)
Frame.Icon:SetScaledPoint("BOTTOMRIGHT", Frame, -1, 1)
Frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

Frame.Anim = CreateAnimationGroup(Frame)

Frame.AnimIn = Frame.Anim:CreateAnimation("Fade")
Frame.AnimIn:SetChange(1)
Frame.AnimIn:SetDuration(0.2) -- 0.3
Frame.AnimIn:SetSmoothing("in")

Frame.AnimOut = Frame.Anim:CreateAnimation("Fade")
Frame.AnimOut:SetChange(0)
Frame.AnimOut:SetDuration(0.6)
Frame.AnimOut:SetSmoothing("out")

Frame.Sleep = Frame.Anim:CreateAnimation("Sleep")
Frame.Sleep:SetDuration(1.4)
Frame.Sleep:SetScript("OnFinished", function(self)
	Frame.AnimOut:Play()
end)

local PlayAnimation = function()
	Frame.AnimIn:Play()
	
	Frame.Sleep:Play()
end

local OnUpdate = function(self, ela)
	Elapsed = Elapsed + ela
	
	if (Elapsed < Delay) then
		return
	end
	
	CurrentTime = GetTime()
	
	for CDType, Data in pairs(ActiveCDs) do
		GetCD = (CDType == "item") and GetItemCooldown or GetSpellCooldown
		
		for Position, ID in pairs(Data) do
			local Start, Duration = GetCD(ID)
			
			if (Start ~= nil) then
				local Remaining = Start + Duration - CurrentTime
				
				if (Remaining <= 0) then
					Frame.Icon:SetTexture(GetTexture(CDType, ID))
					PlayAnimation()
					--PlaySound("MapPing", "master")
					tremove(Data, Position)
					ActiveCount = ActiveCount - 1
				end
			end
		end
	end
	
	if (ActiveCount <= 0) then
		self:SetScript("OnUpdate", nil)
		Running = false
	end
	
	Elapsed = 0
end

-- UNIT_SPELLCAST_SUCCEEDED fetches casts, and then SPELL_UPDATE_COOLDOWN checks them after the GCD is done (Otherwise GetSpellCooldown detects GCD)
function Cooldowns:SPELL_UPDATE_COOLDOWN()
	for i = #Spells, 1, -1 do
		local Start, Duration = GetSpellCooldown(Spells[i])
		
		if (Duration >= MinTreshold) then
			tinsert(ActiveCDs.player, Spells[i])
			ActiveCount = ActiveCount + 1
			
			if (ActiveCount > 0 and not Running) then
				self:SetScript("OnUpdate", OnUpdate)
				Running = true
			end
		end
		
		tremove(Spells, i)
	end
end

function Cooldowns:UNIT_SPELLCAST_SUCCEEDED(unit, guid, spellID)
	if (unit == "player") then
		if Blacklist["player"][spellID] then
			return
		end
		
		tinsert(Spells, spellID)
	end
end

local StartItem = function(id)
	if Blacklist["item"][id] then
		return
	end
	
	local Start, Duration = GetItemCooldown(id)
	
	if (Duration and Duration > MinTreshold) then
		tinsert(ActiveCDs.item, id)
		ActiveCount = ActiveCount + 1
		
		if (ActiveCount > 0 and not Running) then
			Cooldowns:SetScript("OnUpdate", OnUpdate)
			Running = true
		end
	end
end

local UseAction = function(slot)
	local ActionType, ItemID = GetActionInfo(slot)
	
	if (ActionType == "item") then
		StartItem(ItemID)
	end
end

local UseInventoryItem = function(slot)
	local ItemID = GetInventoryItemID("player", slot)
	
	if ItemID then
		StartItem(ItemID)
	end
end

local UseContainerItem = function(bag, slot)
	local ItemID = GetContainerItemID(bag, slot)
	
	if ItemID then
		StartItem(ItemID)
	end
end

function Cooldowns:Load()
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)
	
	hooksecurefunc("UseAction", UseAction)
	hooksecurefunc("UseInventoryItem", UseInventoryItem)
	hooksecurefunc("UseContainerItem", UseContainerItem)
end