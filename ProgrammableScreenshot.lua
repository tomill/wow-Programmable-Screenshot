BINDING_HEADER_PROGRAMMABLE_SCREENSHOT = "Programmable Screenshot"
BINDING_NAME_PROGRAMMABLE_SCREENSHOT   = "Programmable Screenshot"

SLASH_PROGRAMMABLE_SCREENSHOT1 = "/programmable_screenshot";

ProgrammableScreenshot = LibStub("AceAddon-3.0"):
                         NewAddon("ProgrammableScreenshot", "AceTimer-3.0")

local _cameraworks = {
    "",
    "Current view",
    "View 1",
    "View 2",
    "View 3",
    "View 4",
    "View 5",
}

local options = {
    type = "group",
    name = "Programmable Screenshot Options",
    childGroups = "tab",
    args = {
        camerawork = {
            type  = "group",
            name  = "Camera Work",
            order = 1,
            args  = {
                take1 = {
                    type   = "select",
                    name   = "Take 1:",
                    order  = 1,
                    values = _cameraworks,
                },
                take2 = {
                    type   = "select",
                    name   = "Take 2:",
                    order  = 2,
                    values = _cameraworks,
                },
                take3 = {
                    type   = "select",
                    name   = "Take 3:",
                    order  = 3,
                    values = _cameraworks,
                },
                take4= {
                    type   = "select",
                    name   = "Take 4:",
                    order  = 4,
                    values = _cameraworks,
                },
                take5 = {
                    type   = "select",
                    name   = "Take 5:",
                    order  = 5,
                    values = _cameraworks,
                },
                take6 = {
                    type   = "select",
                    name   = "Take 6:",
                    order  = 6,
                    values = _cameraworks,
                },
                take7 = {
                    type   = "select",
                    name   = "Take 7:",
                    order  = 7,
                    values = _cameraworks,
                },
                take8 = {
                    type   = "select",
                    name   = "Take 8:",
                    order  = 8,
                    values = _cameraworks,
                },
                take9 = {
                    type   = "select",
                    name   = "Take 9:",
                    order  = 9,
                    values = _cameraworks,
                },
                take10 = {
                    type   = "select",
                    name   = "Take 10:",
                    order  = 10,
                    values = _cameraworks,
                },
                desc = {
                    type  = "description",
                    name  = "\nNote:\nYou can set keybinding to save your favorite view position:\n"
                         .. "ESC > Key Binding > Camera Function > Save View 1-5",
                    order = 20,
                },
            },
        },
        screenshot = {
            type  = "group",
            name  = "Screenshot Options",
            order = 2,
            args  = {
                hideui = {
                    type  = "toggle",
                    name  = "Hide UI",
                    order = 1,
                },
                screenshotQuality = {
                    type  = "select",
                    name  = "screenshot quality",
                    values = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
                    order = 1,
                },
                UnitNameOwn = {
                    type  = "toggle",
                    name  = "My Name",
                    order = 2,
                },
                UnitNameNPC = {
                    type  = "toggle",
                    name  = "NPC Names",
                    order = 3
                },
                UnitNamePlayerGuild = {
                    type  = "toggle",
                    name  = "Guild Names",
                    order = 4,
                },
                UnitNamePlayerPVPTitle = {
                    type  = "toggle",
                    name  = "Titles",
                    order = 5,
                },
                UnitNameFriendlyPlayername  = {
                    type  = "toggle",
                    name  = "Friendly Players",
                    order = 6,
                },
                UnitNameFriendlyPetname  = {
                    type  = "toggle",
                    name  = "Friendly Players' Pets & Minions",
                    order = 7,
                },
                UnitNameFriendlyGuardianname  = {
                    type  = "toggle",
                    name  = "Friendly Players' Guardians",
                    order = 8,
                },
                UnitNameFriendlyTotemname  = {
                    type  = "toggle",
                    name  = "Friendly Players' Totems",
                    order = 9,
                },
                UnitNameEnemyPlayername  = {
                    type  = "toggle",
                    name  = "Enemy Players",
                    order = 10,
                },
                UnitNameEnemyPetname  = {
                    type  = "toggle",
                    name  = "Enemy Players' Pets & Minions",
                    order = 11,
                },
                UnitNameEnemyGuardianname  = {
                    type  = "toggle",
                    name  = "Enemy Player's Guardians",
                    order = 12,
                },
                UnitNameEnemyTotemname  = {
                    type  = "toggle",
                    name  = "Enemy Players' Totems",
                    order = 13,
                },
                UnitNameNonCombatCreaturename  = {
                    type  = "toggle",
                    name  = "Non-combat Pets",
                    order = 14,
                },
            },
        },
    },
}

local defaults = {
    profile = {
        take1  = 2,
        hideui = true,
        screenshotQuality = 11,
        UnitNameOwn                   = true,
        UnitNameNPC                   = true,
        UnitNamePlayerGuild           = true,
        UnitNameFriendlyPlayerName    = true,
    },
}

local function debug(...)
    -- print(...)
end

function ProgrammableScreenshot:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ProgrammableScreenshotDB", defaults, true)
    self.take_number = 0
    
    local reg = LibStub("AceConfigRegistry-3.0")
    local dia = LibStub("AceConfigDialog-3.0")
    local app = "Programmable Screenshot Options"
    options.get = function(item) return self.db.profile[ item[#item] ] end
    options.set = function(item, value) self.db.profile[ item[#item] ] = value end
    reg:RegisterOptionsTable(app, options)
    dia:AddToBlizOptions(app, "Programmable Screenshot")
    
    local frame = CreateFrame("FRAME", "ProgrammableScreenshotFrame")
    frame:RegisterEvent("SCREENSHOT_SUCCEEDED")
    frame:SetScript("OnEvent", function(self, event, unit)
        if event == "SCREENSHOT_SUCCEEDED" then
            ProgrammableScreenshot:ScheduleTimer("Shot", 1) -- wait camera 1 sec
        else
            print("Oops, screenshot failed! - " .. event)
        end
    end)
end

local cvars = {
    "screenshotQuality",
    "UnitNameOwn",
    "UnitNameNPC",
    "UnitNameNonCombatCreatureName",
    "UnitNamePlayerGuild",
    "UnitNamePlayerPVPTitle",
    "UnitNameFriendlyPlayerName",
    "UnitNameFriendlyPetName",
    "UnitNameFriendlyGuardianName",
    "UnitNameFriendlyTotemName",
    "UnitNameEnemyPlayerName",
    "UnitNameEnemyPetName",
    "UnitNameEnemyGuardianName",
    "UnitNameEnemyTotemName",
}

function ProgrammableScreenshot:Initialize()
    debug("init")
    self.take_number = 1
    self.temp = { }
    for i, v in ipairs(cvars) do
        self.temp[v] = GetCVar(v)
        SetCVar(v, self.db.profile[v] and 1 or 0)
    end
    if self.db.profile.hideui then
        UIParent:Hide()
    end
end

function ProgrammableScreenshot:Finalize()
    for i, v in ipairs(cvars) do
        SetCVar(v, self.temp[v])
    end
    if self.db.profile.hideui then
        UIParent:Show()
    end
    debug("fin")
end

function ProgrammableScreenshot:GetTakePosition(no)
    return tonumber( self.db.profile["take" .. tostring(no)] )
end

function ProgrammableScreenshot:Start()
    self:Initialize()
    
    if not self:GetTakePosition(self.take_number) then
        self:Finalize()
    elseif self:GetTakePosition(self.take_number) == 2 then -- current view
        self:Shot()
    else
        self:Move(self.take_number)
        self:ScheduleTimer("Shot", 1)
    end
end

function ProgrammableScreenshot:Move(take_number)
    if self:GetTakePosition(take_number) and
       self:GetTakePosition(take_number) >= 3 and
       self:GetTakePosition(take_number) <= 7 then
        SetView(self:GetTakePosition(take_number) - 2)
        debug("move to view " .. (self:GetTakePosition(take_number) - 2))
    end
end

function ProgrammableScreenshot:Shot()
    if not self:GetTakePosition(self.take_number) then
        self:Finalize()
    else
        debug("shot")
        ActionStatus:Hide()
        Screenshot()
        self.take_number = self.take_number + 1
        self:Move(self.take_number)
    end
end

function SlashCmdList.PROGRAMMABLE_SCREENSHOT(msg, editbox)
    ProgrammableScreenshot:Start()
end
