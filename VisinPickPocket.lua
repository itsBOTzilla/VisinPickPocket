-- Initialize saved variables and session variables
PickPocketTrackerDB = PickPocketTrackerDB or { showMsg = true, lifetimeCopper = 0 }
local totalCopper = totalCopper or 0
local sessionCopper = 0
local isPickPocketLoot = false
local sessionStartTime = 0

-- Currency icons
local GOLD_ICON = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12:2:0|t"
local SILVER_ICON = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12:2:0|t"
local COPPER_ICON = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12:2:0|t"

-- Frame for event handling
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterEvent("CHAT_MSG_MONEY")

-- Function to format time in hours, minutes, and seconds
local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Function to format money with icons (properly rounded)
local function FormatMoney(copper)
    local gold = math.floor(copper / 10000)           -- Convert copper to gold
    local silver = math.floor((copper % 10000) / 100)  -- Convert remaining copper to silver
    local copperRemaining = copper % 100              -- Remaining copper
    return string.format("%d%s %d%s %d%s", gold, GOLD_ICON, silver, SILVER_ICON, copperRemaining, COPPER_ICON)
end

-- Event handler
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "VisinPickPocket" then
            sessionStartTime = GetTime() -- Use GetTime() for more accurate time tracking
            print("|cffffff00Visin's |cff00ffffPick |cff00ff00Pocketing |cff808080Loaded!|r")  -- Yellow Teal Green
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unitTag, _, spellID = ...
        if unitTag == "player" and spellID == 921 then -- 921 = Pick Pocket spell ID
            isPickPocketLoot = true
        end
    elseif event == "CHAT_MSG_MONEY" then
        if isPickPocketLoot then
            local msg = ...
            local gold = tonumber(string.match(msg, "(%d+) Gold")) or 0
            local silver = tonumber(string.match(msg, "(%d+) Silver")) or 0
            local copper = tonumber(string.match(msg, "(%d+) Copper")) or 0
            local total = (gold * 10000) + (silver * 100) + copper

            -- Update session and lifetime totals
            totalCopper = totalCopper + total
            sessionCopper = sessionCopper + total

            -- Ensure lifetimeCopper is only updated on valid loot
            if total > 0 then
                PickPocketTrackerDB.lifetimeCopper = PickPocketTrackerDB.lifetimeCopper + total
            end

            isPickPocketLoot = false

            -- Display totals in chat
            if PickPocketTrackerDB.showMsg then
                print("|cff00ff00Visin's Pick Pocketing:|r")
                print(string.format(" Pickpocketed: %s", FormatMoney(total)))
                print(string.format(" Session Total: %s", FormatMoney(sessionCopper)))
                print(string.format(" Lifetime Total: %s", FormatMoney(PickPocketTrackerDB.lifetimeCopper)))
                print(string.format(" Time Running: %s", FormatTime(GetTime() - sessionStartTime)))
            end
        end
    end
end)

-- Slash command for manual status check
SLASH_PICKPOCKET1 = "/pp"
SlashCmdList["PICKPOCKET"] = function()
    print("|cff00ff00Visin's Pick Pocketing:|r")
    print(string.format(" Session Total: %s", FormatMoney(sessionCopper)))
    print(string.format(" Lifetime Total: %s", FormatMoney(PickPocketTrackerDB.lifetimeCopper)))
    print(string.format(" Time Running: %s", FormatTime(GetTime() - sessionStartTime)))
end

-- Slash command to reset session data
SLASH_PICKPOCKETRESET1 = "/pprestart"
SlashCmdList["PICKPOCKETRESET"] = function()
    sessionCopper = 0
    sessionStartTime = GetTime() -- Reset the session start time to the current time
    print("|cff00ff00VisinPickPocket:|r Session data has been reset!")
    print("Session started.")
end
