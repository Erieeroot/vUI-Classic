local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

GUI:AddOptions(function(self)
	self:CreateSpacer("ZZZ")
	
	local Left, Right = self:CreateWindow(Language["Credits"], nil, "zzzCredits")
	
	Left:CreateHeader(Language["Scripting Help & Mentoring"])
	Left:CreateDoubleLine("Tukz", "Foof")
	Left:CreateDoubleLine("Eclipse", "nightcracker")
	Left:CreateDoubleLine("Elv", "Azilroka")
	Left:CreateDoubleLine("Smelly", "AlleyKat")
	Left:CreateDoubleLine("Zork", "Simpy")
	
	Left:CreateHeader("oUF")
	Left:CreateDoubleLine("haste", "lightspark")
	Left:CreateDoubleLine("p3lim", "Rainrider")
	
	Left:CreateHeader("LibHealComm-4.0")
	Left:CreateDoubleLine("Shadowed103", "xbeeps")
	Left:CreateLine("Azilroka")
	
	Left:CreateHeader("AceSerializer")
	Left:CreateLine("Nevcairiel")
	
	Right:CreateHeader("LibStub")
	Right:CreateDoubleLine("Kaelten", "Cladhaire")
	Right:CreateDoubleLine("ckknight", "Mikk")
	Right:CreateDoubleLine("Ammo", "Nevcairiel")
	Right:CreateLine("joshborke")
	
	Right:CreateHeader("LibSharedMedia")
	Right:CreateDoubleLine("Elkano", "funkehdude")
	
	Right:CreateHeader("LibClassicDurations, LibClassicCasterino")
	Right:CreateLine("d87_")
	
	Right:CreateHeader("LibClassicMobHealth-1.0")
	Right:CreateLine("Pneumatus")
	
	Right:CreateHeader("LibDeflate")
	Right:CreateLine("yoursafety")
	
	Right:CreateHeader("vUI")
	Right:CreateLine("Hydra")
	
	-- Supporters
	local Left, Right = self:CreateWindow(Language["Supporters"], nil, "zzzSupporters")
	
	Left:CreateSupportHeader(Language["Hall of Legends"])
	Left:CreateDoubleLine("Innie", "Brightsides")
	Left:CreateLine("Erthelmi")
	
	Right:CreateMessage("Thank you to all of these amazing people who have supported the development of this project!")
	
	Right:CreateHeader("|cFF0070DDRare Patrons|r")
	Right:CreateLine("Smelly")
end)