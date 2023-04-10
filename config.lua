--[[....................................]]--
--[[       Config by i3ucky#4415        ]]--
--[[            wildfired.de            ]]--
--[[....................................]]--

Config = {}

--[[ Command ]]--
Config.Command = "aa"

--[[ Allowed Jobs ]]--
Config.Jobs = {"ranger","marshal","sheriff","police"}

--[[ Offices ]]--
Config.UseOffice = true
Config.Open = { 
	['key'] = 0xCEFD9220, -- E
	['text'] = "~e~[E] ~q~to open Archive",
	} 
Config.Office = {
    [1] = {
        coords={-279.33, 808.34, 119.43}, -- Valentine
    },
    [2] = {
        coords={-762.25, -1266.68, 44.15}, -- Blackwater
    },
    [3] = {
        coords={-1807.25, -348.27, 164.71}, -- Strawberry Jail Desk
    },
    [4] = {
        coords={1362.43, -1300.95, 77.81}, -- Rhodes by Bed
    },
    [5] = {
        coords={2510.12, -1308.78, 49.05}, -- Saint Denis Middle Desk
    },
    [6] = {
        coords={2907.39, 1313.98, 45.04}, -- Annesburg
    },
    [7] = {
        coords={-3624.39, -2601.61, -13.24}, -- Armadillo
    },
    [8] = {
        coords={-5530.79, -2930.5, -1.31}, -- Tumbleweed
    },
}

--[[ Notifys ]]--
Config.Notify = {  
	['1'] = "Offender changes have been saved.", 
	['2'] = "Report changes have been saved.",
	['3'] = "Report has been successfully deleted.",
	['4'] = "A new report has been submitted.",
	['5'] = "A new warrant has been created.", 
	['6'] = "Warrant has been successfully deleted.",
	['7'] = "This report cannot be found.",
	['8'] = "Telegram saved.",
	['9'] = "Telegram deleted.",
	} 
