local vUI, GUI, Language, Assets, Settings = select(2, ...):get()

-- vUI Default
Assets:SetStyle("vUI", {
	["ui-widget-font"] = "Roboto",
	["ui-header-font"] = "Roboto",
	["ui-button-font"] = "Roboto",
	
	["ui-widget-texture"] = "vUI 4",
	["ui-header-texture"] = "vUI 4",
	["ui-button-texture"] = "vUI 4",
	
	["ui-header-font-color"] = "FFE6C0",
	["ui-header-texture-color"] = "424242",
	
	["ui-window-bg-color"] = "424242",
	["ui-window-main-color"] = "2B2B2B",
	
	["ui-widget-color"] = "FFC44D", -- FFC44D - FFCE54
	["ui-widget-bright-color"] = "8E8E8E",
	["ui-widget-bg-color"] = "424242",
	["ui-widget-font-color"] = "FFFFFF",
	
	["ui-button-font-color"] = "FFC44D",
	["ui-button-texture-color"] = "616161",
	
	["ui-font-size"] = 12,
	["ui-header-font-size"] = 14,
	["ui-title-font-size"] = 16,
	
	["chat-font"] = "PT Sans",
	["chat-font-size"] = 12,
	["chat-font-flags"] = "",
	
	["chat-tab-font"] = "Roboto",
	["chat-tab-font-size"] = 12,
	["chat-tab-font-flags"] = "",
	["chat-tab-font-color"] = "FFFFFF",
	["chat-tab-font-color-mouseover"] = "FFC44D",
	
	["chat-bubbles-font"] = "PT Sans",
	["chat-bubbles-font-size"] = 14,
	["chat-bubbles-font-flags"] = "",
	
	["color-casting-start"] = "4C9900",
	["color-casting-stopped"] = "F39C12",
	["color-casting-interrupted"] = "D35400",
	["color-casting-uninterruptible"] = "FF4444",
	
	["action-bars-font"] = "Roboto",
	["action-bars-font-size"] = 12,
	["action-bars-font-flags"] = "",
	
	["tooltips-font"] = "Roboto",
	["tooltips-size"] = 12,
	["tooltips-flags"] = "",
	
	["nameplates-font"] = "Roboto",
	["nameplates-font-size"] = 12,
	["nameplates-font-flags"] = "",
	
	["data-text-font"] = "Roboto",
	["data-text-font-size"] = 12,
	["data-text-font-flags"] = "",
	["data-text-label-color"] = "FFFFFF",
	["data-text-value-color"] = "FFC44D",
	
	["experience-bar-color"] = "4C9900", 
	["experience-rested-color"] = "00B4FF",
})

-- vUI 2
Assets:SetStyle("vUI 2", {
	["ui-widget-font"] = "PT Sans",
	["ui-header-font"] = "PT Sans",
	["ui-button-font"] = "PT Sans",
	
	["ui-widget-texture"] = "Ferous",
	["ui-header-texture"] = "Ferous",
	["ui-button-texture"] = "Ferous",
	
	["ui-header-font-color"] = "FFE6C0",
	["ui-header-texture-color"] = "424242",
	
	["ui-window-bg-color"] = "424242",
	["ui-window-main-color"] = "2B2B2B",
	
	["ui-widget-color"] = "FFB74D",
	["ui-widget-bright-color"] = "8E8E8E",
	["ui-widget-bg-color"] = "424242",
	["ui-widget-font-color"] = "FFFFFF",
	
	["ui-button-font-color"] = "FFB74D",
	["ui-button-texture-color"] = "666666",
	
	["ui-font-size"] = 12,
	["ui-header-font-size"] = 14,
	["ui-title-font-size"] = 16,
	
	["chat-font"] = "PT Sans",
	["chat-font-size"] = 12,
	["chat-font-flags"] = "",
	
	["chat-tab-font"] = "PT Sans",
	["chat-tab-font-size"] = 12,
	["chat-tab-font-flags"] = "",
	["chat-tab-font-color"] = "FFFFFF",
	["chat-tab-font-color-mouseover"] = "FFB74D",
	
	["chat-bubbles-font"] = "PT Sans",
	["chat-bubbles-font-size"] = 14,
	["chat-bubbles-font-flags"] = "",
	
	["color-casting-start"] = "4C9900",
	["color-casting-stopped"] = "F39C12",
	["color-casting-interrupted"] = "D35400",
	["color-casting-uninterruptible"] = "FF4444",
	
	["action-bars-font"] = "PT Sans",
	["action-bars-font-size"] = 12,
	["action-bars-font-flags"] = "",
	
	["tooltips-font"] = "PT Sans",
	["tooltips-size"] = 12,
	["tooltips-flags"] = "",
	
	["nameplates-font"] = "PT Sans",
	["nameplates-font-size"] = 12,
	["nameplates-font-flags"] = "",
	
	["data-text-font"] = "PT Sans",
	["data-text-font-size"] = 12,
	["data-text-font-flags"] = "",
	["data-text-label-color"] = "FFFFFF",
	["data-text-value-color"] = "FFB74D",
	
	["experience-bar-color"] = "4C9900", 
	["experience-rested-color"] = "00B4FF",
})

-- Conjured Muffin -- Casting: 2ECC71 - Interrupted: F39C12 - Failed: D35400
Assets:SetStyle("Conjured Muffin", {
	["ui-widget-font"] = "Roboto",
	["ui-header-font"] = "Roboto",
	["ui-button-font"] = "Roboto",
	
	["ui-widget-texture"] = "vUI 4",
	["ui-header-texture"] = "vUI 4",
	["ui-button-texture"] = "vUI 4",
	
	["ui-header-font-color"] = "EFEBE9",
	["ui-header-texture-color"] = "37474F",
	
	["ui-window-bg-color"] = "424242",
	["ui-window-main-color"] = "263238",
	
	["ui-widget-color"] = "3EC5E9",
	["ui-widget-bright-color"] = "8E8E8E",
	["ui-widget-bg-color"] = "263238",
	["ui-widget-font-color"] = "FAFAFA",
	
	["ui-button-font-color"] = "EFEBE9",
	["ui-button-texture-color"] = "757575",
	
	["ui-font-size"] = 12,
	["ui-header-font-size"] = 14,
	["ui-title-font-size"] = 16,
	
	["chat-font"] = "Roboto",
	["chat-font-size"] = 12,
	["chat-font-flags"] = "",
	
	["chat-tab-font"] = "Roboto",
	["chat-tab-font-size"] = 12,
	["chat-tab-font-flags"] = "",
	["chat-tab-font-color"] = "FFFFFF",
	["chat-tab-font-color-mouseover"] = "3EC5E9",
	
	["chat-bubbles-font"] = "Roboto",
	["chat-bubbles-font-size"] = 14,
	["chat-bubbles-font-flags"] = "",
	
	["color-casting-start"] = "27AE60",
	["color-casting-stopped"] = "FF8C00",
	["color-casting-interrupted"] = "DA3B01",
	["color-casting-uninterruptible"] = "FF4444",
	
	["action-bars-font"] = "Roboto",
	["action-bars-font-size"] = 12,
	["action-bars-font-flags"] = "",
	
	["tooltips-font"] = "Roboto",
	["tooltips-size"] = 12,
	["tooltips-flags"] = "",
	
	["nameplates-font"] = "Roboto",
	["nameplates-font-size"] = 12,
	["nameplates-font-flags"] = "",
	
	["data-text-font"] = "Roboto",
	["data-text-font-size"] = 12,
	["data-text-font-flags"] = "",
	["data-text-label-color"] = "EFEBE9",
	["data-text-value-color"] = "3EC5E9",
	
	["experience-bar-color"] = "27AE60",
	["experience-rested-color"] = "3EC5E9",
})

--[[ Zen
Assets:SetStyle("Zen", {
	["ui-widget-font"] = "Prototype",
	["ui-header-font"] = "Prototype",
	["ui-button-font"] = "Prototype",
	
	["ui-widget-texture"] = "vUI 4",
	["ui-header-texture"] = "vUI 4",
	["ui-button-texture"] = "vUI 4",
	
	["ui-header-font-color"] = "EFEBE9",
	["ui-header-texture-color"] = "37474F",
	
	["ui-window-bg-color"] = "424242",
	["ui-window-main-color"] = "263238",
	
	["ui-widget-color"] = "00FF99", -- 81D4FA
	["ui-widget-bright-color"] = "8E8E8E",
	["ui-widget-bg-color"] = "263238",
	["ui-widget-font-color"] = "FAFAFA",
	
	["ui-button-font-color"] = "00FF99", -- 81D4FA
	["ui-button-texture-color"] = "757575",
	
	["ui-font-size"] = 12,
	["ui-header-font-size"] = 14,
	["ui-title-font-size"] = 16,
	
	["chat-font"] = "Prototype",
	["chat-font-size"] = 12,
	["chat-font-flags"] = "",
	
	["chat-tab-font"] = "Prototype",
	["chat-tab-font-size"] = 12,
	["chat-tab-font-flags"] = "",
	["chat-tab-font-color"] = "FFFFFF",
	["chat-tab-font-color-mouseover"] = "00FF99",
	
	["chat-bubbles-font"] = "Prototype",
	["chat-bubbles-font-size"] = 14,
	["chat-bubbles-font-flags"] = "",
	
	["color-casting-start"] = "4C9900",
	["color-casting-stopped"] = "F39C12",
	["color-casting-interrupted"] = "D35400",
	["color-casting-uninterruptible"] = "FF4444",
	
	["action-bars-font"] = "Prototype",
	["action-bars-font-size"] = 12,
	["action-bars-font-flags"] = "",
	
	["tooltips-font"] = "Prototype",
	["tooltips-size"] = 12,
	["tooltips-flags"] = "",
	
	["nameplates-font"] = "Prototype",
	["nameplates-font-size"] = 12,
	["nameplates-font-flags"] = "",
	
	["data-text-font"] = "Prototype",
	["data-text-font-size"] = 12,
	["data-text-font-flags"] = "",
	["data-text-label-color"] = "FFFFFF",
	["data-text-value-color"] = "00FF99",
	
	["experience-bar-color"] = "4C9900", 
	["experience-rested-color"] = "00B4FF",
})]]

-- Sci-Fi
Assets:SetStyle("Sci-Fi", {
	["ui-widget-font"] = "Prototype",
	["ui-header-font"] = "Prototype",
	["ui-button-font"] = "Prototype",
	
	["ui-widget-texture"] = "Ferous",
	["ui-header-texture"] = "Ferous",
	["ui-button-texture"] = "Ferous",
	
	["ui-header-font-color"] = "FFB54F",
	["ui-header-texture-color"] = "212121",
	
	["ui-window-bg-color"] = "37474F",
	["ui-window-main-color"] = "212121",
	
	["ui-widget-color"] = "4FBBFF",
	["ui-widget-bright-color"] = "8E8E8E",
	["ui-widget-bg-color"] = "263238",
	["ui-widget-font-color"] = "FAFAFA",
	
	["ui-button-font-color"] = "FFB54F",
	["ui-button-texture-color"] = "212121",
	
	["ui-font-size"] = 12,
	["ui-header-font-size"] = 14,
	["ui-title-font-size"] = 16,
	
	["chat-font"] = "PT Sans",
	["chat-font-size"] = 12,
	["chat-font-flags"] = "",
	
	["chat-tab-font"] = "Prototype",
	["chat-tab-font-size"] = 12,
	["chat-tab-font-flags"] = "",
	["chat-tab-font-color"] = "FFB54F",
	["chat-tab-font-color-mouseover"] = "FAFAFA",
	
	["chat-bubbles-font"] = "PT Sans",
	["chat-bubbles-font-size"] = 14,
	["chat-bubbles-font-flags"] = "",
	
	["color-casting-start"] = "4C9900",
	["color-casting-stopped"] = "F39C12",
	["color-casting-interrupted"] = "D35400",
	["color-casting-uninterruptible"] = "FF4444",
	
	["action-bars-font"] = "Prototype",
	["action-bars-font-size"] = 12,
	["action-bars-font-flags"] = "",
	
	["tooltips-font"] = "Prototype",
	["tooltips-size"] = 12,
	["tooltips-flags"] = "",
	
	["nameplates-font"] = "Prototype",
	["nameplates-font-size"] = 12,
	["nameplates-font-flags"] = "",
	
	["data-text-font"] = "Prototype",
	["data-text-font-size"] = 12,
	["data-text-font-flags"] = "",
	["data-text-label-color"] = "FFB54F",
	["data-text-value-color"] = "FAFAFA",
	
	["experience-bar-color"] = "4C9900", 
	["experience-rested-color"] = "00B4FF",
})