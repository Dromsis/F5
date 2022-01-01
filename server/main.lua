ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('billing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)

RegisterServerEvent('recruter')
AddEventHandler('recruter', function(target, job, grade, type)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    local _type = type

    if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job2.grade_name == 'boss'  then

        if _type == 1 then
            targetXPlayer.setJob(job, grade)
        elseif _type == 2 then
            targetXPlayer.setJob2(job, grade)
        end

        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
    end
end)

RegisterServerEvent('virer')
AddEventHandler('virer', function(target, type)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    local _type = type

    if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name or sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
        
        if _type == 1 then
            targetXPlayer.setJob('unemployed', 0)
        elseif _type == 2 then
            targetXPlayer.setJob2('unemployed', 0)
        end


        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
    else
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
    end
end)

