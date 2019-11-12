local vUI, GUI, Language, Media, Settings = select(2, ...):get()

local Gold = vUI:NewModule("Gold")

local GetMoney = GetMoney
local tinsert = table.insert
local tremove = table.remove

Gold.SessionGain = 0
Gold.SessionLoss = 0
Gold.Sorted = {}
Gold.TablePool = {}

function Gold:GetTable()
	local Table
	
	if self.TablePool[1] then
		Table = tremove(self.TablePool, 1)
	else
		Table = {}
	end
	
	return Table
end

function Gold:GetColoredName(name)
	local Color = vUI.ClassColors[vUI.UserClass]
	local Hex = vUI:RGBToHex(Color[1], Color[2], Color[3])
	local Name = format("|cFF%s%s|r", Hex, vUI.UserName)
	
	return Name
end

function Gold:GetSessionStats()
	return self.SessionGain, self.SessionLoss, GetMoney()
end

function Gold:GetServerInfo()
	if self.Sorted[1] then
		for i = 1, #self.Sorted do
			tinsert(self.TablePool, tremove(self.Sorted, 1))
		end
	end
	
	local Table
	local Total = 0
	
	for Name, Value in pairs(vUIGold[vUI.UserRealm]) do
		Table = self:GetTable()
		
		Table[1] = Name
		Table[2] = Value
		
		Total = Total + Value
		
		tinsert(self.Sorted, Table)
	end
	
	table.sort(self.Sorted, function(a, b)
		return a[2] > b[2]
	end)
	
	return self.Sorted, Total
end

function Gold:PLAYER_MONEY()
	local CurrentValue = GetMoney()
	local LastValue = vUIGold[vUI.UserRealm][self.CurrentUser]
	local Diff = CurrentValue - LastValue
	
	if (CurrentValue > LastValue) then
		self.SessionGain = self.SessionGain + Diff
	else
		self.SessionLoss = self.SessionLoss - Diff
	end
end

function Gold:OnEvent(event)
	if self[event] then
		self[event](self)
	end
end

function Gold:Load()
	if (not vUIGold) then
		vUIGold = {}
	end
	
	if (not vUIGold[vUI.UserRealm]) then
		vUIGold[vUI.UserRealm] = {}
	end
	
	self.CurrentUser = self:GetColoredName(vUI.UserName)
	
	vUIGold[vUI.UserRealm][self.CurrentUser] = GetMoney()
	
	self:RegisterEvent("PLAYER_MONEY")
	self:SetScript("OnEvent", self.OnEvent)
end