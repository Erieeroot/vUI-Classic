local vUI, GUI, Language, Media, Settings, Defaults = select(2, ...):get()

-- These are just default values. Use the GUI to change settings.

-- UI
Defaults["ui-scale"] = 0.71111111111111
Defaults["ui-language"] = GetLocale()
Defaults["ui-display-welcome"] = true
Defaults["ui-display-dev-tools"] = false
Defaults["ui-display-whats-new"] = true

-- Media
Defaults["ui-picker-palette"] = "Default"
Defaults["ui-picker-format"] = "Hex"
Defaults["ui-picker-show-texture"] = true

Defaults["ui-style"] = "vUI"

Defaults["ui-header-font"] = "Roboto"
Defaults["ui-widget-font"] = "Roboto"
Defaults["ui-button-font"] = "Roboto"

Defaults["ui-header-texture"] = "vUI 4"
Defaults["ui-widget-texture"] = "vUI 4"
Defaults["ui-button-texture"] = "vUI 4"

Defaults["ui-header-font-color"] = "FFE6C0"
Defaults["ui-header-texture-color"] = "424242"

Defaults["ui-window-bg-color"] = "424242"
Defaults["ui-window-main-color"] = "2B2B2B"

Defaults["ui-widget-color"] = "FFC44D"
Defaults["ui-widget-bright-color"] = "8E8E8E"
Defaults["ui-widget-bg-color"] = "424242"
Defaults["ui-widget-font-color"] = "FFFFFF"

Defaults["ui-button-font-color"] = "FFC44D"
Defaults["ui-button-texture-color"] = "616161"

Defaults["ui-font-size"] = 12
Defaults["ui-header-font-size"] = 14
Defaults["ui-title-font-size"] = 16

Defaults["ui-highlight-texture"] = "Blank" -- TBI
Defaults["ui-highlight-color"] = "FFFFFF" -- TBI

Defaults["gui-enable-fade"] = false
Defaults["gui-faded-alpha"] = 20
Defaults["gui-hide-in-combat"] = true

-- Classes (populating retail colors as well) -- The commented colors are 10% darker, I like it better on some textures
Defaults["color-death-knight"] = "C41F3B" -- 7F222D
Defaults["color-demon-hunter"] = "A330C9" -- 922BB4
Defaults["color-druid"] = "FF7D0A" -- E56F08
Defaults["color-hunter"] = "ABD473" -- 98BD66
Defaults["color-mage"] = "40C7EB" -- 38B2D2
Defaults["color-monk"] = "00FF96" -- 00E586
Defaults["color-paladin"] = "F58CBA" -- DB7DA7
Defaults["color-priest"] = "FFFFFF" -- E5E5E5
Defaults["color-rogue"] = "FFF569" -- E5DB5D
Defaults["color-shaman"] = "0070DE" -- 0046C6
Defaults["color-warlock"] = "8787ED" -- 6969B8
Defaults["color-warrior"] = "C79C6E" -- B28B62

-- Power Types
Defaults["color-mana"] = "477CB2" -- 0000FF for the default mana color
Defaults["color-rage"] = "E53935" -- FF0000 ^
Defaults["color-energy"] = "FFEB3B" -- FFFF00 ^
Defaults["color-focus"] = "FF7F3F"
Defaults["color-fuel"] = "008C7F"
Defaults["color-insanity"] = "6600CC"
Defaults["color-holy-power"] = "F2E599"
Defaults["color-fury"] = "C842FC"
Defaults["color-pain"] = "FF9C00"
Defaults["color-runic-power"] = "00D1FF"
Defaults["color-chi"] = "B5FFEA"
Defaults["color-maelstrom"] = "007FFF"
Defaults["color-lunar-power"] = "4C84E5"
Defaults["color-arcane-charges"] = "1919F9"
Defaults["color-ammo-slot"] = "CC9900"
Defaults["color-soul-shards"] = "7F518C"
Defaults["color-runes"] = "7F7F7F"
Defaults["color-combo-points"] = "FFF468"

-- Reactions
Defaults["color-reaction-1"] = "BF4400" -- Hated
Defaults["color-reaction-2"] = "BF4400" -- Hostile
Defaults["color-reaction-3"] = "BF4400" -- Unfriendly
Defaults["color-reaction-4"] = "E5B200" -- Neutral
Defaults["color-reaction-5"] = "009919" -- Friendly
Defaults["color-reaction-6"] = "009919" -- Honored
Defaults["color-reaction-7"] = "009919" -- Revered
Defaults["color-reaction-8"] = "009919" -- Exalted

-- Zone PVP Types
Defaults["color-sanctuary"] = "68CCEF"
Defaults["color-arena"] = "FF1919"
Defaults["color-hostile"] = "FF1919"
Defaults["color-combat"] = "FF1919"
Defaults["color-friendly"] = "19FF19"
Defaults["color-contested"] = "FFB200"
Defaults["color-other"] = "FFECC1"

-- Debuff Types
Defaults["color-curse"] = "9900FF"
Defaults["color-disease"] = "996600"
Defaults["color-magic"] = "3399FF"
Defaults["color-poison"] = "009900"
Defaults["color-none"] = "000000"

-- Happiness
Defaults["color-happiness-1"] = "4CAF50" -- "8BC94D"
Defaults["color-happiness-2"] = "FBC02D" -- "FFC44D"
Defaults["color-happiness-3"] = "C62828" -- "EE4D4D"

-- Difficulty
Defaults["color-trivial"] = "9A9A9A"
Defaults["color-standard"] = "27AE60"
Defaults["color-difficult"] = "F1C40F"
Defaults["color-verydifficult"] = "E57A45"
Defaults["color-impossible"] = "FF4444"

-- Combo Points
Defaults["color-combo-1"] = "FF6666"
Defaults["color-combo-2"] = "FFB266"
Defaults["color-combo-3"] = "FFFF66"
Defaults["color-combo-4"] = "B2FF66"
Defaults["color-combo-5"] = "66FF66"

-- Casting
Defaults["color-casting-start"] = "4C9900"
Defaults["color-casting-stopped"] = "F39C12"
Defaults["color-casting-interrupted"] = "D35400"
Defaults["color-casting-success"] = "4C9900" -- TBI

-- Mirror Timers
Defaults["color-mirror-exhaustion"] = "FFE500"
Defaults["color-mirror-breath"] = "007FFF"
Defaults["color-mirror-death"] = "FFB200"
Defaults["color-mirror-feign-death"] = "FFB200"

-- Other
Defaults["color-tapped"] = "A6A6A6"
Defaults["color-disconnected"] = "A6A6A6"

-- Totems
Defaults["color-totem-fire"] = "C0392B"
Defaults["color-totem-earth"] = "B7950B" -- B7950B (Darker)
Defaults["color-totem-water"] = "2E86C1"
Defaults["color-totem-air"] = "80DEEA"

-- Action Bars
Defaults["action-bars-enable"] = true
Defaults["action-bars-layout"] = "DEFAULT"
Defaults["action-bars-show-hotkeys"] = true
Defaults["action-bars-button-size"] = 32
Defaults["action-bars-button-spacing"] = 2
Defaults["action-bars-stance-size"] = 32
Defaults["action-bars-button-highlight"] = "Blank"
Defaults["action-bars-show-bottom-bg"] = true
Defaults["action-bars-show-side-bg"] = true
Defaults["action-bars-show-stance-bg"] = true
Defaults["action-bars-show-hotkeys"] = true
Defaults["action-bars-show-macro-names"] = true
Defaults["action-bars-show-count"] = true
Defaults["action-bars-show-grid"] = true
Defaults["action-bars-font"] = "Roboto"
Defaults["action-bars-font-size"] = 12
Defaults["action-bars-font-flags"] = ""
Defaults["action-bars-show-1"] = true
Defaults["action-bars-show-2"] = true
Defaults["action-bars-show-3"] = true
Defaults["action-bars-show-4"] = true
Defaults["action-bars-show-5"] = true

-- Chat
Defaults["chat-enable"] = true
Defaults["chat-bg-opacity"] = 70
Defaults["chat-enable-url-links"] = true
Defaults["chat-enable-discord-links"] = true
Defaults["chat-enable-email-links"] = true
Defaults["chat-enable-friend-links"] = true
Defaults["chat-font"] = "PT Sans"
Defaults["chat-font-size"] = 12
Defaults["chat-font-flags"] = ""
Defaults["chat-tab-font"] = "Roboto"
Defaults["chat-tab-font-size"] = 12
Defaults["chat-tab-font-flags"] = ""
Defaults["chat-tab-font-color"] = "FFFFFF"
Defaults["chat-tab-font-color-mouseover"] = "FFCE54"
Defaults["chat-frame-width"] = 392
Defaults["chat-frame-height"] = 104
Defaults["chat-enable-fading"] = false
Defaults["chat-fade-time"] = 15

-- Chat Bubbles
Defaults["chat-bubbles-enable"] = true
Defaults["chat-bubbles-opacity"] = 100
Defaults["chat-bubbles-font"] = "PT Sans"
Defaults["chat-bubbles-font-size"] = 14
Defaults["chat-bubbles-font-flags"] = ""

-- Experience
Defaults["experience-enable"] = true
Defaults["experience-display-level"] = false
Defaults["experience-display-progress"] = true
Defaults["experience-display-percent"] = true
Defaults["experience-display-rested-value"] = true
Defaults["experience-show-tooltip"] = true
Defaults["experience-animate"] = true
Defaults["experience-width"] = 310
Defaults["experience-height"] = 18
Defaults["experience-position"] = "TOP"
Defaults["experience-progress-visibility"] = "ALWAYS"
Defaults["experience-percent-visibility"] = "ALWAYS"
Defaults["experience-bar-color"] = "4C9900" -- 1AE045
Defaults["experience-rested-color"] = "00B4FF"

-- Reputation
Defaults["reputation-enable"] = true
Defaults["reputation-width"] = 310
Defaults["reputation-height"] = 18
Defaults["reputation-display-progress"] = true
Defaults["reputation-display-percent"] = true
Defaults["reputation-position"] = "TOP"

-- Auras
Defaults["auras-enable"] = true
Defaults["auras-size"] = 30
Defaults["auras-spacing"] = 2
Defaults["auras-row-spacing"] = 16
Defaults["auras-per-row"] = 12

-- Minimap
Defaults["minimap-enable"] = true
Defaults["minimap-size"] = 140
Defaults["minimap-buttonbar-enable"] = true
Defaults["minimap-buttonbar-direction"] = "LEFT"
Defaults["minimap-buttonbar-buttonspacing"] = 1
Defaults["minimap-buttonbar-buttonsize"] = 20

-- Cooldowns
Defaults["cooldowns-enable"] = true

-- Meter Container
Defaults["meters-container-show"] = true

-- Micro Buttons
Defaults["micro-buttons-visiblity"] = "HIDE"
Defaults["micro-buttons-opacity"] = 40

-- Bags Frame
Defaults["bags-frame-visiblity"] = "SHOW"
Defaults["bags-frame-opacity"] = 40

-- Auto Repair
Defaults["auto-repair-enable"] = true
Defaults["auto-repair-report"] = true

-- Auto Vendor
Defaults["auto-vendor-enable"] = true
Defaults["auto-vendor-report"] = true

-- Delete cheapest
Defaults["delete-filter-consumable"] = false
Defaults["delete-filter-container"] = false
Defaults["delete-filter-weapon"] = true
Defaults["delete-filter-armor"] = true
Defaults["delete-filter-reagent"] = false
Defaults["delete-filter-tradeskill"] = false
Defaults["delete-filter-quest"] = true

-- Announcements
Defaults["announcements-enable"] = true
Defaults["announcements-channel"] = "GROUP"

-- Unitframes -- Add option to color health backdrops by reaction/class color, or use health color, or set a color
Defaults["unitframes-enable"] = true
Defaults["unitframes-class-color"] = true -- temporary
Defaults["unitframes-only-player-debuffs"] = false
Defaults["unitframes-show-player-buffs"] = true

-- Unitframes: Player
Defaults["unitframes-player-width"] = 238
Defaults["unitframes-player-health-height"] = 28
Defaults["unitframes-player-power-height"] = 15

-- Unitframes: Target
Defaults["unitframes-target-width"] = 238
Defaults["unitframes-target-health-height"] = 28
Defaults["unitframes-target-power-height"] = 15

-- Unitframes: Target of Target
Defaults["unitframes-targettarget-width"] = 110
Defaults["unitframes-targettarget-health-height"] = 26 
Defaults["unitframes-targettarget-enable-power"] = true
Defaults["unitframes-targettarget-power-height"] = 3

-- Unitframes: Pet
Defaults["unitframes-pet-width"] = 110
Defaults["unitframes-pet-health-height"] = 26
Defaults["unitframes-pet-enable-power"] = true
Defaults["unitframes-pet-power-height"] = 3

-- Unitframes: Party
Defaults["party-enable"] = true
Defaults["party-width"] = 160
Defaults["party-health-height"] = 29
Defaults["party-power-height"] = 6
Defaults["party-show-debuffs"] = true
Defaults["party-pets-enable"] = true
Defaults["party-pets-width"] = 160
Defaults["party-pets-health-height"] = 22
Defaults["party-pets-power-height"] = 0 -- NYI

-- Unitframes: Raid
Defaults["raid-enable"] = true
Defaults["raid-width"] = 90
Defaults["raid-health-height"] = 23
Defaults["raid-power-height"] = 2

-- Name Plates
Defaults["nameplates-enable"] = true
Defaults["nameplates-width"] = 134
Defaults["nameplates-height"] = 14
Defaults["nameplates-font"] = "Roboto"
Defaults["nameplates-font-size"] = 12
Defaults["nameplates-font-flags"] = ""
Defaults["nameplates-cc-health"] = false
Defaults["nameplates-topleft-text"] = "[LevelColor][Level][Plus] [NameColor][Name20]"
Defaults["nameplates-topright-text"] = "" -- [LevelColor][Level][Plus]
Defaults["nameplates-bottomleft-text"] = "" -- [Classification]
Defaults["nameplates-bottomright-text"] = "[HealthColor][perhp]"
Defaults["nameplates-display-debuffs"] = true
Defaults["nameplates-only-player-debuffs"] = true
Defaults["nameplates-color-by-class"] = true
Defaults["nameplates-color-by-reaction"] = true
Defaults["nameplates-color-by-tapped"] = true
Defaults["nameplates-enable-elite-indicator"] = true
Defaults["nameplates-enable-target-indicator"] = true
Defaults["nameplates-target-indicator-size"] = "SMALL"
Defaults["nameplates-enable-castbar"] = true
Defaults["nameplates-castbar-height"] = 12
Defaults["nameplates-castbar-enable-icon"] = true

-- Tooltips
Defaults["tooltips-enable"] = true
Defaults["tooltips-show-sell-value"] = true
Defaults["tooltips-on-cursor"] = false
Defaults["tooltips-show-id"] = false
Defaults["tooltips-font"] = "Roboto"
Defaults["tooltips-font-size"] = 12
Defaults["tooltips-font-flags"] = ""
Defaults["tooltips-hide-on-unit"] = "NEVER"
Defaults["tooltips-hide-on-item"] = "NEVER"
Defaults["tooltips-hide-on-action"] = "NEVER"
Defaults["tooltips-health-bar-height"] = 15
Defaults["tooltips-show-health-text"] = true

-- Bags
Defaults["bags-loot-from-left"] = false

-- Quests
Defaults["quest-watch-font"] = "Roboto"
Defaults["quest-watch-font-size"] = 12
Defaults["quest-watch-font-flags"] = ""

-- Data Texts
Defaults["data-text-font"] = "Roboto"
Defaults["data-text-font-size"] = 12
Defaults["data-text-font-flags"] = ""
Defaults["data-text-label-color"] = "FFFFFF"
Defaults["data-text-value-color"] = "FFC44D"
Defaults["data-text-chat-left"] = "Gold"
Defaults["data-text-chat-middle"] = "Crit"
Defaults["data-text-chat-right"] = "Durability"
Defaults["data-text-minimap-top"] = "Location"
Defaults["data-text-minimap-bottom"] = "Time - Local"
Defaults["data-text-enable-tooltips"] = true
Defaults["data-text-24-hour"] = false