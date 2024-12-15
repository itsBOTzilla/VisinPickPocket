-- Ensure Ace3 is loaded
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Initialize the database for settings if it doesn't exist
PickPocketTrackerDB = PickPocketTrackerDB or { showMsg = true }

-- Define the options table with user-configurable settings
local options = {
    type = "group",
    name = "|cffffff00Visin's |cff00ffffPick |cff00ff00Pocketing|r",
    args = {
        description = {
            type = "description",
            name = "Visin's Pick Pocketing tracks money from pickpocketing and saves session data, including lifetime totals.\n" ..
                   " \n\n\n" ..
                   "Commands:\n" ..
                   "/pp - View current session data (total money looted, time running, etc.).\n" ..
                   "/pprestart - Reset the current session and start a new one.\n" ..
                   " \n\n\n" ..
                   "Created By: |cffffff00Visin|cff808080-|cffff0000Doomhowl |cff808080(|cff00ff00HCWOW Classic|cff808080)|r\n" ..
                   " \n\n\n",
            order = 1,
        },
        showMsg = {
            type = "toggle",
            name = "Show Pick Pocket Messages",
            desc = "Display messages in chat when you pickpocket an item.",
            order = 2,  -- This ensures the checkbox is at the top
            width = 1.5, -- Width is changable by number
            set = function(info, value)
                PickPocketTrackerDB.showMsg = value
            end,
            get = function(info)
                return PickPocketTrackerDB.showMsg
            end,
        },
        blankspace = {
            type = "description",
            name = " ",  -- Blank space for separation
            order = 3, 
        },
        resetSession = {
            type = "execute",
            name = "Reset Session",
            desc = "Reset the current session's pick pocket data.",
            order = 4,  -- This places the Reset button below the checkbox
            func = function()
                sessionCopper = 0
                print("Session data has been reset!")
            end,
        },
    },
}

-- Register the options with AceConfig
AceConfig:RegisterOptionsTable("VisinPickPocket", options)

-- Add the options to the Interface Options menu
AceConfigDialog:AddToBlizOptions("VisinPickPocket", "|cffffff00Visin's |cff00ffffPick |cff00ff00Pocketing|r")
