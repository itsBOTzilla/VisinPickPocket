-- Ensure Ace3 is loaded
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Initialize the database for settings if it doesn't exist
PickPocketTrackerDB = PickPocketTrackerDB or { showMsg = true }

-- Function to generate a unique number of spaces between 1 and 12 (ensures no repetition)
local spaceVariations = {}
local function GenerateUniqueSpaces()
    local numSpaces = math.random(1, 12)
    
    -- Check if the number of spaces has already been used
    while spaceVariations[numSpaces] do
        numSpaces = math.random(1, 12)  -- Generate again if the space variation has already been used
    end
    
    -- Mark this space variation as used
    spaceVariations[numSpaces] = true
    
    return string.rep(" ", numSpaces)  -- Return the string with the unique number of spaces
end

-- Function to create the rogue macros
local function CreateRogueMacros()
    local abilities = {
        {name = "Sinister Strike", spellID = 1752},
        {name = "Ambush", spellID = 8676},
        {name = "Garrote", spellID = 703},
        {name = "Cheap Shot", spellID = 1833},
        {name = "Sap", spellID = 11297},
        {name = "Backstab", spellID = 53}
    }

    for _, ability in ipairs(abilities) do
        local macroName = GenerateUniqueSpaces()  -- Generate a unique variation of spaces
        local macroContent = string.format(
            "#showtooltip %s\n/cast Pick Pocket\n/cast %s",
            ability.name,
            ability.name
        )
        
        -- Check if the macro already exists
        local existingMacroId = GetMacroIndexByName(macroName)
        if existingMacroId == 0 then
            -- Create a new macro if it doesn't exist
            local macroIcon = GetSpellTexture(ability.spellID)
            CreateMacro(macroName, macroIcon, macroContent, false)
            print("Macro created for " .. ability.name)
        else
            -- If the macro already exists, delete it and recreate it
            DeleteMacro(existingMacroId)
            local macroIcon = GetSpellTexture(ability.spellID)
            CreateMacro(macroName, macroIcon, macroContent, false)
            print("Existing macro for " .. ability.name .. " deleted and recreated.")
        end
    end
end

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
        -- New button to create macros
        createMacros = {
            type = "execute",
            name = "Create Rogue Macros",
            desc = "Automatically creates macros for your rogue abilities with Pick Pocket.",
            order = 5,
            func = function()
                CreateRogueMacros()
            end,
        },
    },
}

-- Register the options with AceConfig
AceConfig:RegisterOptionsTable("VisinPickPocket", options)

-- Add the options to the Interface Options menu
AceConfigDialog:AddToBlizOptions("VisinPickPocket", "|cffffff00Visin's |cff00ffffPick |cff00ff00Pocketing|r")
