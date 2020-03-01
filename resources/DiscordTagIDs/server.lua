roleList = {
{0, "~g~"}, -- Regular Civilian / Non-Staff
{626800628122779674, "~g~VIP ~w~"}, -- VIP 577661583497363456
{626074276612669440, "~r~MODERADOR ~w~"}, --[[ Moderator --- 506211787214159872 ]]
{626074195029393419, "~r~ADMIN ~w~"}, --[[ Admin --- 506212543749029900 ]]
{626072026280493056, "~p~PROGRAMADOR ~w~"}, --[[ Management --- 577966729981067305 ]]
{626800405417820210, "~o~OWNER ~w~"}, --[[ Owner --- 506212786481922058]]
}

prefixes = {}
hasPrefix = {}

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
RegisterNetEvent('Print:PrintDebug')
AddEventHandler('Print:PrintDebug', function(msg)
	print(msg)
	TriggerClientEvent('chatMessage', -1, "^7[^1Badger's Scripts^7] ^1DEBUG ^7" .. msg)
end)
hidePrefix = {}
hideAll = {}

local function get_index (tab, val)
	local counter = 1
    for index, value in ipairs(tab) do
        if value == val then
            return counter
        end
		counter = counter + 1
    end

    return nil
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
hideTags = {}

function HideUserTag(src)
	table.insert(hideTags, GetPlayerName(src))
	TriggerClientEvent('ID:HideTag', -1, hideTags, false)
end
function ShowUserTag(src)
	table.remove(hideTags, get_index(hideTags, GetPlayerName(src)))
	TriggerClientEvent('ID:HideTag', -1, hideTags, false)
end

RegisterCommand("tag-toggle", function(source, args, rawCommand)
	local name = GetPlayerName(source)
	if (has_value(hidePrefix, name)) then
		-- Turn on their tag-prefix and remove them
		table.remove(hidePrefix, get_index(hidePrefix, name))
		TriggerClientEvent("ID:Tag-Toggle", -1, hidePrefix, false)
		TriggerClientEvent('chatMessage', source, "^9[^1Badger-Tags^9] ^3Tu tag esta ahora ^2activado")
	else
		-- Turn off their tag-prefix and add them
		table.insert(hidePrefix, name)
		TriggerClientEvent("ID:Tag-Toggle", -1, hidePrefix, false)
		TriggerClientEvent('chatMessage', source, "^9[^1Badger-Tags^9] ^3Tu tag esta ahora ^1desactivado")
	end
end)
RegisterCommand("tags-toggle", function(source, args, rawCommand)
	local name = GetPlayerName(source)
	if (has_value(hideAll, name)) then
		-- Have them not hide all tags
		table.remove(hideAll, get_index(hideAll, name))
		TriggerClientEvent("ID:Tags-Toggle", source, false, false)
		TriggerClientEvent('chatMessage', source, "^9[^1Badger-Tags^9] ^3Los tags de los jugadores ahora estan ^2activados")
	else
		-- Have them hide all tags
		table.insert(hideAll, name)
		TriggerClientEvent("ID:Tags-Toggle", source, true, false)
		TriggerClientEvent('chatMessage', source, "^9[^1Badger-Tags^9] ^3Los tags de los jugadores ahora estan ^1desactivados")
	end
end)
alreadyGotRoles = {}

RegisterNetEvent('dtid:playerSpawned')
AddEventHandler('dtid:playerSpawned', function()
--AddEventHandler('chatMessage', function(source, name, msg)
	local src = source
	for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
	end
	local roleGive = ""
	if identifierDiscord then
		if not has_value(alreadyGotRoles, GetPlayerName(src)) then
			local roleIDs = exports.discord_perms:GetRoles(src)
			if not (roleIDs == false) then
				for i = 1, #roleList do
					for j = 1, #roleIDs do
						if (tostring(roleList[i][1]) == tostring(roleIDs[j])) then
							local roleGive = roleList[i][2]
							print(GetPlayerName(src) .. " has ID tag for: " .. roleList[i][2])
							table.insert(prefixes, {GetPlayerName(src), roleGive})
							table.insert(alreadyGotRoles, GetPlayerName(src))
						end
					end
				end
			else
				table.insert(prefixes, {GetPlayerName(src), roleGive})
				table.insert(alreadyGotRoles, GetPlayerName(src))
				print(GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
			end
			table.insert(hasPrefix, GetPlayerName(src))
		end
	else
		table.insert(prefixes, {GetPlayerName(src), roleGive})
		table.insert(alreadyGotRoles, GetPlayerName(src))
	end
	TriggerClientEvent("GetStaffID:StaffStr:Return", -1, prefixes, false)
	TriggerClientEvent("ID:Tag-Toggle", -1, hidePrefix, false)
end)