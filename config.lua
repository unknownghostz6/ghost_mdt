--[[....................................]]--
--[[       Config by i3ucky#4415        ]]--
--[[            wildfired.de            ]]--
--[[....................................]]--

Config = {}

--[[ Command ]]--
Config.Command = "aa"

--[[ Allowed Jobs ]]--
Config.Jobs = {"police","sheriff","marshal","ranger"}

--[[ Offices ]]--
Config.UseOffice = true
Config.Open = { 
	['key'] = 0xCEFD9220, -- E
	['text'] = "~e~[E] ~q~to open Archive",
	} 
Config.Office = {
    [1] = {
        coords={-304.10, 829.9, 120.0}, -- Valentine
    },
    [2] = {
        coords={-325.81, 819.8, 118.0}, -- Valentine 2
    },
    [3] = {
        coords={-762.25, -1266.68, 44.15}, -- Blackwater
    },
    [4] = {
        coords={-1807.1, -348.27, 164.76}, -- Strawberry
    },
    [5] = {
        coords={-1810.71, -353.21, 161.54}, -- Strawberry Downstairs
    },
    [6] = {
        coords={-325.81, 819.8, 118.0}, -- Rhodes
    },
    [7] = {
        coords={2510.12, -1308.78, 49.05}, -- Saint Denis Middle Desk
    },
    [8] = {
        coords={2495.93, -1306.78, 49.05}, -- Saint Denis Cells
    },
    [9] = {
        coords={2907.39, 1313.98, 45.04}, -- Annesburg
    },
    [10] = {
        coords={-3624.39, -2601.61, -13.24}, -- Armadillo
    },
    [11] = {
        coords={-5531.15, -2930.18, -1.26}, -- Tumbleweed
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
