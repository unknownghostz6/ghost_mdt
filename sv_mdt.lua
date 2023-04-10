VORPCore = {}

TriggerEvent("getCore", function(core)
    VORPCore = core
end)

---------------- WORK IN PROGRESS FOR ITEM USE TO OPEN MDT --------------------
--[[VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local itemName = "mdtbook"
VorpInv.RegisterUsableItem("mdtbook", function(data)
	TriggerClientEvent('ghost_mdt:toggleVisibilty', function(reports, warrants, officer, job, grade, note)
end)]]
---------------- END OF WORK IN PROGRESS PART --------------------------------

RegisterCommand(""..Config.Command.."", function(source, args)
    local _source = source
	local User = VORPCore.getUser(_source)
    local Character = User.getUsedCharacter
    local job = Character.job
	local jobgrade = Character.jobGrade
	local officername = (Character.firstname.. " " ..Character.lastname)
    local job_access = false
        for k,v in pairs(Config.Jobs) do
            if job == v then
                job_access = true
				exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 6) sub ORDER BY `id` DESC", {}, function(reports)
					for r = 1, #reports do
						reports[r].charges = json.decode(reports[r].charges)
					end
					exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 6) sub ORDER BY `id` DESC", {}, function(warrants)
						for w = 1, #warrants do
							warrants[w].charges = json.decode(warrants[w].charges)
						end
						exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_telegrams` ORDER BY `id` DESC LIMIT 6) sub ORDER BY `id` DESC", {}, function(note)
							for n = 1, #note do
								note[n].charges = json.decode(note[n].charges)
							end
						TriggerClientEvent('ghost_mdt:toggleVisibilty', _source, reports, warrants, officername, job, jobgrade, note)
					end)
				end)
			end)
            end
        end
        if job_access == false then
            return false
        end
end)

---------- USABLE MDT ITEM --------------
--[[local itemCount = VorpInv.getItemCount(source, itemName, metadata)
local itemName = "mdtbook"
		VorpInv.RegisterUsableItem(itemName, function(data)
  		VORPInv.CloseInv(data.source)
  	TriggerClientEvent('ghost_mdt:toggleVisibilty', _source, reports, warrants, officername, job, jobgrade, note)
  --print(data.source) -- player using the item
  --print(data.label)  -- item label
end)]]
--------- END OF USABLE MDT ITEM ---------------

RegisterServerEvent("ghost_mdt:getOffensesAndOfficer")
AddEventHandler("ghost_mdt:getOffensesAndOfficer", function()
	local usource = source
	local Character = VORPCore.getUser(usource).getUsedCharacter
	local officername = (Character.firstname.. " " ..Character.lastname)

	local charges = {}
	exports.ghmattimysql:execute('SELECT * FROM fine_types', {}, function(fines)
		for j = 1, #fines do
			if fines[j].category == 0 or fines[j].category == 1 or fines[j].category == 2 or fines[j].category == 3 then
				table.insert(charges, fines[j])
			end
		end

		TriggerClientEvent("ghost_mdt:returnOffensesAndOfficer", usource, charges, officername)
	end)
end)

RegisterServerEvent("ghost_mdt:performOffenderSearch")
AddEventHandler("ghost_mdt:performOffenderSearch", function(query)
	local usource = source
	local matches = {}

	exports.ghmattimysql:execute("SELECT * FROM `characters` WHERE LOWER(`firstname`) LIKE @query OR LOWER(`lastname`) LIKE @query OR CONCAT(LOWER(`firstname`), ' ', LOWER(`lastname`)) LIKE @query", {
		['@query'] = string.lower('%'..query..'%')
	}, function(result)

		for index, data in ipairs(result) do
			table.insert(matches, data)
		end

		TriggerClientEvent("ghost_mdt:returnOffenderSearchResults", usource, matches)
	end)
end)

RegisterServerEvent("ghost_mdt:getOffenderDetails")
AddEventHandler("ghost_mdt:getOffenderDetails", function(offender)
	local usource = source

	--print(offender.charidentifier)

    exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `char_id` = ?', {offender.charidentifier}, function(result)

		if result[1] then
            offender.notes = result[1].notes
            offender.mugshot_url = result[1].mugshot_url
            offender.bail = result[1].bail
		else
			offender.notes = ""
			offender.mugshot_url = ""
			offender.bail = false
		end

        exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `char_id` = ?', {offender.charidentifier}, function(convictions)

            if convictions[1] then
                offender.convictions = {}
                for i = 1, #convictions do
                    local conviction = convictions[i]
                    offender.convictions[conviction.offense] = conviction.count
                end
            end

            exports.ghmattimysql:execute('SELECT * FROM `mdt_warrants` WHERE `char_id` = ?', {offender.charidentifier}, function(warrants)

                if warrants[1] then
                    offender.haswarrant = true
                end
			
				TriggerClientEvent("ghost_mdt:returnOffenderDetails", usource, offender)
            end)
        end)
    end)
end)

RegisterServerEvent("ghost_mdt:getOffenderDetailsById")
AddEventHandler("ghost_mdt:getOffenderDetailsById", function(char_id)
    local usource = source
	print(char_id)

    exports.ghmattimysql:execute('SELECT * FROM `characters` WHERE `charidentifier` = ?', {char_id}, function(result)

        local offender = result[1]

        if not offender then
            TriggerClientEvent("ghost_mdt:closeModal", usource)
            TriggerClientEvent("ghost_mdt:sendNotification", usource, "This person no longer exists.")
            return
        end
    
        exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `char_id` = ?', {char_id}, function(result)

			if result[1] then
                offender.notes = result[1].notes
                offender.mugshot_url = result[1].mugshot_url
                offender.bail = result[1].bail
			else
				offender.notes = ""
				offender.mugshot_url = ""
				offender.bail = false
			end

            exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `char_id` = ?', {char_id}, function(convictions) 

                if convictions[1] then
                    offender.convictions = {}
                    for i = 1, #convictions do
                        local conviction = convictions[i]
                        offender.convictions[conviction.offense] = conviction.count
                    end
                end

                exports.ghmattimysql:execute('SELECT * FROM `mdt_warrants` WHERE `char_id` = ?', {char_id}, function(warrants)
                    
                    if warrants[1] then
                        offender.haswarrant = true
                    end

					TriggerClientEvent("ghost_mdt:returnOffenderDetails", usource, offender)
                end)
            end)
        end)
    end)
end)

RegisterServerEvent("ghost_mdt:saveOffenderChanges")
AddEventHandler("ghost_mdt:saveOffenderChanges", function(charidentifier, changes, identifier)
	local usource = source

	exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `char_id` = ?', {charidentifier}, function(result)
		if result[1] then
			exports.oxmysql:execute('UPDATE `user_mdt` SET `notes` = ?, `mugshot_url` = ?, `bail` = ? WHERE `char_id` = ?', {changes.notes, changes.mugshot_url, changes.bail, charidentifier})
		else
			exports.oxmysql:insert('INSERT INTO `user_mdt` (`char_id`, `notes`, `mugshot_url`, `bail`) VALUES (?, ?, ?, ?)', {charidentifier, changes.notes, changes.mugshot_url, changes.bail})
		end

		if changes.convictions ~= nil then
			for conviction, amount in pairs(changes.convictions) do	
				exports.oxmysql:execute('UPDATE `user_convictions` SET `count` = ? WHERE `char_id` = ? AND `offense` = ?', {charidentifier, amount, conviction})
			end
		end

		for i = 1, #changes.convictions_removed do
			exports.oxmysql:execute('DELETE FROM `user_convictions` WHERE `char_id` = ? AND `offense` = ?', {charidentifier, changes.convictions_removed[i]})
		end

		TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['1'])
	end)
end)

RegisterServerEvent("ghost_mdt:saveReportChanges")
AddEventHandler("ghost_mdt:saveReportChanges", function(data)
	exports.oxmysql:execute('UPDATE `mdt_reports` SET `title` = ?, `incident` = ? WHERE `id` = ?', {data.id, data.title, data.incident})
	TriggerClientEvent("ghost_mdt:sendNotification", source, Config.Notify['2'])
end)

RegisterServerEvent("ghost_mdt:deleteReport")
AddEventHandler("ghost_mdt:deleteReport", function(id)
	exports.oxmysql:execute('DELETE FROM `mdt_reports` WHERE `id` = ?', {id})
	TriggerClientEvent("ghost_mdt:sendNotification", source, Config.Notify['3'])
end)

RegisterServerEvent("ghost_mdt:deleteNote")
AddEventHandler("ghost_mdt:deleteNote", function(id)
	exports.oxmysql:execute('DELETE FROM `mdt_telegrams` WHERE `id` = ?', {id})
	TriggerClientEvent("ghost_mdt:sendNotification", source, Config.Notify['9'])
end)

RegisterServerEvent("ghost_mdt:submitNewReport")
AddEventHandler("ghost_mdt:submitNewReport", function(data)
	local usource = source
	local User = VORPCore.getUser(usource)
    local Character = User.getUsedCharacter
	local officername = (Character.firstname.. " " ..Character.lastname)

	charges = json.encode(data.charges)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports.oxmysql:insert('INSERT INTO `mdt_reports` (`char_id`, `title`, `incident`, `charges`, `author`, `name`, `date`) VALUES (?, ?, ?, ?, ?, ?, ?)', {data.char_id, data.title, data.incident, charges, officername, data.name, data.date,}, function(id)
		TriggerEvent("ghost_mdt:getReportDetailsById", id, usource)
		TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['4'])
	end)

	for offense, count in pairs(data.charges) do
		exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `offense` = ? AND `char_id` = ?', {offense, data.char_id}, function(result)
			if result[1] then
				exports.oxmysql:execute('UPDATE `user_convictions` SET `count` = ? WHERE `offense` = ? AND `char_id` = ?', {data.char_id, offense, count + 1})
			else
				exports.oxmysql:insert('INSERT INTO `user_convictions` (`char_id`, `offense`, `count`) VALUES (?, ?, ?)', {data.char_id, offense, count})
			end
		end)
	end
end)

RegisterServerEvent("ghost_mdt:submitNote")
AddEventHandler("ghost_mdt:submitNote", function(data)
	local usource = source
	local User = VORPCore.getUser(usource)
    local Character = User.getUsedCharacter
	local officername = (Character.firstname.. " " ..Character.lastname)
	charges = json.encode(data.charges)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports.oxmysql:insert('INSERT INTO `mdt_telegrams` ( `title`, `incident`, `author`, `date`) VALUES (?, ?, ?, ?)', {data.title, data.note, officername, data.date,}, function(id)
		TriggerEvent("ghost_mdt:getNoteDetailsById", id, usource)
		TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['8'])
	end)
end)

RegisterServerEvent("ghost_mdt:performReportSearch")
AddEventHandler("ghost_mdt:performReportSearch", function(query)
	local usource = source
	local matches = {}
	exports.ghmattimysql:execute("SELECT * FROM `mdt_reports` WHERE `id` LIKE @query OR LOWER(`title`) LIKE @query OR LOWER(`name`) LIKE @query OR LOWER(`author`) LIKE @query or LOWER(`charges`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			data.charges = json.decode(data.charges)
			table.insert(matches, data)
		end

		TriggerClientEvent("ghost_mdt:returnReportSearchResults", usource, matches)
	end)
end)

RegisterServerEvent("ghost_mdt:getWarrants")
AddEventHandler("ghost_mdt:getWarrants", function()
	local usource = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_warrants`", {}, function(warrants)
		for i = 1, #warrants do
			warrants[i].expire_time = ""
			warrants[i].charges = json.decode(warrants[i].charges)
		end
		TriggerClientEvent("ghost_mdt:returnWarrants", usource, warrants)
	end)
end)

RegisterServerEvent("ghost_mdt:submitNewWarrant")
AddEventHandler("ghost_mdt:submitNewWarrant", function(data)
	local usource = source
	local User = VORPCore.getUser(usource)
    local Character = User.getUsedCharacter
	local officername = (Character.firstname.. " " ..Character.lastname)

	data.charges = json.encode(data.charges)
	data.author = officername
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports.oxmysql:insert('INSERT INTO `mdt_warrants` (`name`, `char_id`, `report_id`, `report_title`, `charges`, `date`, `expire`, `notes`, `author`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {data.name, data.char_id, data.report_id, data.report_title, data.charges, data.date, data.expire, data.notes, data.author}, function()
		TriggerClientEvent("ghost_mdt:completedWarrantAction", usource)
		TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['5'])
	end)
end)

RegisterServerEvent("ghost_mdt:deleteWarrant")
AddEventHandler("ghost_mdt:deleteWarrant", function(id)
	local usource = source
	exports.oxmysql:execute('DELETE FROM `mdt_warrants` WHERE `id` = ?', {id}, function()
		TriggerClientEvent("ghost_mdt:completedWarrantAction", usource)
	end)
	TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['6'])
end)

RegisterServerEvent("ghost_mdt:getReportDetailsById")
AddEventHandler("ghost_mdt:getReportDetailsById", function(query, _source)
	if _source then source = _source end
	local usource = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_reports` WHERE `id` = ?", {query}, function(result)
		if result and result[1] then
			result[1].charges = json.decode(result[1].charges)
			TriggerClientEvent("ghost_mdt:returnReportDetails", usource, result[1])
		else
			TriggerClientEvent("ghost_mdt:closeModal", usource)
			TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['7'])
		end
	end)
end)

RegisterServerEvent("ghost_mdt:getNoteDetailsById")
AddEventHandler("ghost_mdt:getNoteDetailsById", function(query, _source)
	if _source then source = _source end
	local usource = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_telegrams` WHERE `id` = ?", {query}, function(result)
		if result and result[1] then
			TriggerClientEvent("ghost_mdt:returnNoteDetails", usource, result[1])
		else
			TriggerClientEvent("ghost_mdt:closeModal", usource)
			TriggerClientEvent("ghost_mdt:sendNotification", usource, Config.Notify['8'])
		end
	end)
end)
