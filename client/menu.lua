ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	local PlayerData = {}
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn( ped, false )

Citizen.CreateThread(function()

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job2 == nil do
        Citizen.Wait(10)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
    end
end)


loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSociety2Money(money)
		end, ESX.PlayerData.job2.name)
	end
end

function refreshplayer()
    GetPlayerName(PlayerId())
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		UpdateSociety2Money(money)
	end
end)

function UpdateSocietyMoney(money)
	societymoney = ESX.Math.GroupDigits(money)
end

function UpdateSociety2Money(money)
	societymoney2 = ESX.Math.GroupDigits(money)
end

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

-----tomber pommes
local ragdoll = false
function setRagdoll(flag)
  ragdoll = flag
end
Citizen.CreateThread(function()
  while true do
	Citizen.Wait(0)
	if ragdoll then
	  SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
	end
  end
end)

ragdol = true
RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
	else
		setRagdoll(false)
		ragdol = true
	end
end)

function Ragdoll()
  TriggerEvent("Ragdoll", source)
end


---------------------------------------

local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
local playerPed = PlayerPedId()


menu = {
    billing = {}
    
}

local name = {}
local closestDistance
local closestPlayer
local playerPed 
local IsInVeh = false
local locked
local playervh 
local plaque

----------------------------------------------------------

RMenu.Add("civile", "main", RageUI.CreateMenu("MenuF5","Menu personnel", 15 , 10,"banner","Banner"))
RMenu.Add('civile', 'porte', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Mon portefeuille"))
RMenu.Add('civile', 'pp', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Mes papiers"))
RMenu.Add('civile', 'vh', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Véhicule"))
RMenu.Add('civile', 'facture', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Mes factures non payées"))
RMenu.Add('civile', 'job', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Administration"))
RMenu.Add('civile', 'job2', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Administration"))
RMenu.Add('civile', 'inter', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Interactions"))
RMenu.Add('civile', 'extra', RageUI.CreateSubMenu(RMenu:Get('civile', 'vh'), "MenuF5", "Menu extra"))
RMenu.Add('civile', 'rockstar', RageUI.CreateSubMenu(RMenu:Get('civile', 'main'), "MenuF5", "Enregistrement Rockstart-Editor"))
RMenu:Get('civile', 'main').EnableMouse = false
RMenu:Get('civile', 'main').Closed = function()end



Citizen.CreateThread(function()

    while true do

    Citizen.Wait(1)

    
    RageUI.IsVisible(RMenu:Get("civile","main"),true,true,true,function()
        
        RageUI.ButtonWithStyle("Portefeuille", nil, {RightLabel = "→→→"},true, function()
        end, RMenu:Get('civile', 'porte'))

        RageUI.ButtonWithStyle("Mes papiers", nil, {RightLabel = "→→→"},true, function()
        end, RMenu:Get('civile', 'pp'))

        RageUI.ButtonWithStyle("Interaction", nil, {RightLabel = "→→→"},true, function()
        end, RMenu:Get('civile', 'inter'))
        
        if ESX.PlayerData.job.label == "Chomeur" then
            RageUI.ButtonWithStyle("Vous n'avez aucun emploie", "Regardez les offres d'emploi sur le site de la ville", {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)   
            end)
        elseif ESX.PlayerData.job.grade_label == 'boss' then
            if ESX.PlayerData.job == "fire" or ESX.PlayerData.job == "police" or ESX.PlayerData.job == "ambulance" then
                RageUI.ButtonWithStyle("Administration", nil, {RightLabel = "~b~"..ESX.PlayerData.job.label .."~s~ →"},true, function()
                end, RMenu:Get('civile', 'job'))
            else
                RageUI.ButtonWithStyle("Gérer mon entreprise", nil, {RightLabel = "~b~"..ESX.PlayerData.job.label .."~s~ →"},true, function()
                end, RMenu:Get('civile', 'job'))
            end
        else
            RageUI.ButtonWithStyle("Mon emploi", nil, {RightLabel = "~b~"..ESX.PlayerData.job.label .."~s~ →"},true, function()
            end, RMenu:Get('civile', 'job'))
        end

        if ESX.PlayerData.job2.label == "Etat" or ESX.PlayerData.job2.label == "Chomeur" then
            ------ne rien mettre ici -----
        else
            if ESX.PlayerData.job2.grade_label == 'boss'then
                RageUI.ButtonWithStyle("Gérer mon organisation", nil, {RightLabel = "~b~"..ESX.PlayerData.job2.label .."~s~ →"},true, function()
                end, RMenu:Get('civile', 'job2'))
            else
                RageUI.ButtonWithStyle("Mon second emploi", nil, {RightLabel = "~b~"..ESX.PlayerData.job2.label .."~s~ →"},true, function()
                end, RMenu:Get('civile', 'job2'))
            end
        end

        if IsInVeh then
            RageUI.ButtonWithStyle("Véhicule", nil, {RightLabel = "→→→"},true, function()end, RMenu:Get('civile', 'vh'))
        elseif not IsInVeh then
            RageUI.ButtonWithStyle("Véhicule","Vous n'êtes pas dans un véhicule", {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)end)
        end

        RageUI.ButtonWithStyle("Filmes et Photos", "Enregistrer un clip éditable via le RockStar-Editor", {RightLabel = "→→→"},true, function()
        end, RMenu:Get('civile', 'rockstar'))

        RageUI.ButtonWithStyle("Animations",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerEvent("emote")
                RageUI.CloseAll()
            end
        end)

    end)

    RageUI.IsVisible(RMenu:Get("civile","inter"),true,true,true,function()
        RageUI.ButtonWithStyle("Tomber dans les pommes",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if Selected then
                Ragdoll()
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("civile","rockstar"),true,true,true,function()
        if not IsRecording() then
            RageUI.ButtonWithStyle('Commencer à enregistrer', nil, {RightLabel = "⏺️"}, true, function(Hovered, Active, Selected)
                if Selected then
                    StartRecording(1)
                end
            end)

            RageUI.ButtonWithStyle("Accéder au Rockstar Editor", nil, {RightLabel = "💾"}, true, function(Hovered, Active, Selected)
                if Selected then
                    NetworkSessionLeaveSinglePlayer()
                    ActivateRockstarEditor()
                end
            end)
        elseif IsRecording() then
            RageUI.ButtonWithStyle("Sauvegarder l'enregistrement", nil, {RightLabel = "🛑"}, true, function(Hovered, Active, Selected)
                if Selected then
                    StopRecordingAndSaveClip()
                end
            end)
            RageUI.ButtonWithStyle("Supprimer l'enregistrement", nil, {RightLabel = "💾"}, true, function(Hovered, Active, Selected)
                if Selected then
                    StopRecordingAndDiscardClip()
                end
            end)
        end

        
       
    end)

    RageUI.IsVisible(RMenu:Get("civile","job"),true,true,true,function()

        RageUI.Separator("Entreprise/Service: ~b~"..ESX.PlayerData.job.label .."~s~")
					
	RageUI.Separator("Salaire: ~b~"..ESX.PlayerData.job.grade_salary .."€~s~")			

        RageUI.Separator("~s~"..ESX.PlayerData.job.grade_label .."~s~")

        if ESX.PlayerData.job.grade_name == 'boss' then

            if societymoney ~= nil then
                RageUI.Separator("~g~"..societymoney.."€~s~")
            end

            RageUI.ButtonWithStyle('Recruter une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('recruter', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0, 1)
                        end 
                end
            end)

            RageUI.ButtonWithStyle('Renvoyer une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('virer', GetPlayerServerId(closestPlayer), 1)
                        end
                    
                        ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            end)
        end


    end)

    RageUI.IsVisible(RMenu:Get("civile","job2"),true,true,true,function()
        
        RageUI.Separator("Entreprise/Organisation: ~b~"..ESX.PlayerData.job2.label .."~s~")
					
	RageUI.Separator("Salaire: ~b~"..ESX.PlayerData.job2.grade_salary .."€~s~")

        RageUI.Separator("~s~"..ESX.PlayerData.job2.grade_label .."~s~")

        if ESX.PlayerData.job2.grade_name == 'boss' then

            if societymoney2 ~= nil then
                RageUI.Separator("~g~"..societymoney2.."€~s~")
            end

            RageUI.ButtonWithStyle('Recruter une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('recruter', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0 , 2)
                        end
                end
            end)

            RageUI.ButtonWithStyle('Renvoyer une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('virer', GetPlayerServerId(closestPlayer) , 2)
                        end
                end
            end)
        end

    end)

    RageUI.IsVisible(RMenu:Get("civile","porte"),true,true,true,function()

        RageUI.Separator("Liquide ~b~€"..ESX.Math.GroupDigits(ESX.PlayerData.money).."~s~")

        for i = 1, #ESX.PlayerData.accounts, 1 do
            if ESX.PlayerData.accounts[i].name == 'bank'  then
                RageUI.Separator("Compte bancaire ~b~€"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).."~s~")
            end
        end

        for i = 1, #ESX.PlayerData.accounts, 1 do
            if ESX.PlayerData.accounts[i].name == 'black_money'  then
                RageUI.Separator("Non déclaré~r~€"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).."~s~")
            end
        end


        ESX.TriggerServerCallback('billing', function(bills) menu.billing = bills end)
        
        if #menu.billing == 0 then
            RageUI.ButtonWithStyle("Aucune facture", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
            end)
        else
            RageUI.ButtonWithStyle("Mes factures", nil, {RightLabel = "→→→"},true, function()
            end, RMenu:Get('civile', 'facture'))
        end

            
        


    end)

    RageUI.IsVisible(RMenu:Get('civile', 'facture'), true, true, true, function()
        ESX.TriggerServerCallback('billing', function(bills) menu.billing = bills end)

        if #menu.billing == 0 then
            RageUI.Separator("~b~AUCUNE FACTURE~s~")
        end
            
        for i = 1, #menu.billing, 1 do
            RageUI.ButtonWithStyle(menu.billing[i].label, nil, {RightLabel = '[~b~$' .. ESX.Math.GroupDigits(menu.billing[i].amount.."~s~] →")}, true, function(Hovered,Active,Selected)
                if Selected then
                    local value = menu.billing[i].id
                    ESX.TriggerServerCallback('esx_billing:payBill', function()
                        RageUI.CloseAll()
                    end, value)       
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("civile","extra"),true,true,true,function()
        if IsInVeh then
            for x = 0, 20 do
                if DoesExtraExist(playervh, x) then
                    if IsVehicleExtraTurnedOn(playervh, x) then
                        RageUI.ButtonWithStyle("Extra: "..x.."~s~",nil, {RightLabel = "✔️"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SetVehicleExtra(playervh, x, 1)
                            end
                        end)
                    elseif not IsVehicleExtraTurnedOn(playervh, x) then
                        RageUI.ButtonWithStyle("Extra: "..x.."~s~",nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SetVehicleExtra(playervh, x, 0)
                            end
                        end)
                    end
                end
            end
        else
            RageUI.GoBack()
        end
    end)

    
    RageUI.IsVisible(RMenu:Get("civile","vh"),true,true,true,function()

        if IsInVeh then
            RageUI.Separator("Plaque : ~b~" ..plaque.. "~s~")

            RageUI.ButtonWithStyle("~b~EXTRA", nil, {RightLabel = "→→→"},true, function()
            end, RMenu:Get('civile', 'extra'))
            
            RageUI.ButtonWithStyle("Allumer/Eteindre: Moteur",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if GetIsVehicleEngineRunning(playervh) then
                        SetVehicleEngineOn(playervh, false, false, true)
                        SetVehicleUndriveable(playervh, true)
                    elseif not GetIsVehicleEngineRunning(playervh) then
                        SetVehicleEngineOn(playervh, true, false, true)
                        SetVehicleUndriveable(playervh, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Verrouiller le véhicule",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if locked == 1 or locked == 0 then
                        SetVehicleDoorsLocked(playervh, 2)
                        PlayVehicleDoorCloseSound(playervh, 1)
                        ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
                    elseif locked == 2 then
                        SetVehicleDoorsLocked(playervh, 1)
                        PlayVehicleDoorOpenSound(playervh, 0)
                        ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: Porte avant droite",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not fd then
                        fd = true
                        SetVehicleDoorOpen(playervh, 1, false, false)
                    elseif fd then
                        fd = false
                        SetVehicleDoorShut(playervh, 1, false, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: Porte avant gauche",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not fg then
                        fg = true
                        SetVehicleDoorOpen(playervh, 0, false, false)
                    elseif fg then
                        fg = false
                        SetVehicleDoorShut(playervh, 0, false, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: Porte arriere droite",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not br then
                        br = true
                        SetVehicleDoorOpen(playervh, 3, false, false)
                    elseif br then
                        br = false
                        SetVehicleDoorShut(playervh, 3, false, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: Porte arriere gauche",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not bl then
                        bl = true
                        SetVehicleDoorOpen(playervh, 2, false, false)
                    elseif bl then
                        bl = false
                        SetVehicleDoorShut(playervh, 2, false, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: Capot",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not Capot then
                        Capot = true
                        SetVehicleDoorOpen(playervh, 4, false, false)
                    elseif Capot then
                        Capot = false
                        SetVehicleDoorShut(playervh, 4, false, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: Coffre",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not coffre then
                        coffre = true
                        SetVehicleDoorOpen(playervh, 5, false, false)
                    elseif coffre then
                        coffre = false
                        SetVehicleDoorShut(playervh, 5, false, false)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir/Fermer: toutes les portes",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not all then
                        SetVehicleDoorOpen(playervh, 5, false, false)
                        SetVehicleDoorOpen(playervh, 4, false, false)
                        SetVehicleDoorOpen(playervh, 3, false, false)
                        SetVehicleDoorOpen(playervh, 2, false, false)
                        SetVehicleDoorOpen(playervh, 1, false, false)
                        SetVehicleDoorOpen(playervh, 0, false, false)
                        all = true
                    elseif all then
                        SetVehicleDoorShut(playervh, 5, false, false)
                        SetVehicleDoorShut(playervh, 4, false, false)
                        SetVehicleDoorShut(playervh, 3, false, false)
                        SetVehicleDoorShut(playervh, 2, false, false)
                        SetVehicleDoorShut(playervh, 1, false, false)
                        SetVehicleDoorShut(playervh, 0, false, false)
                        all = false
                    end    
                end
            end)
        else
            RageUI.GoBack()
        end
    end)

    RageUI.IsVisible(RMenu:Get("civile","pp"),true,true,true,function()

        RageUI.Separator("~s~"..GetPlayerName(PlayerId()).."~s~")


        RageUI.ButtonWithStyle("~b~Voir~s~ sa carte d'identité",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                RageUI.CloseAll()
            end
        end)

        
        RageUI.ButtonWithStyle("~r~Présenter~s~ sa carte d'identité",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if Selected then
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                    RageUI.CloseAll()
                else
                    ESX.ShowNotification('Personne autoure')
                end
            end
        end)


        RageUI.ButtonWithStyle("~b~Voir~s~ son permis de conduire",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                RageUI.CloseAll()
            end
        end)

        
        RageUI.ButtonWithStyle("~r~Présenter~s~ son permis de conduire",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if Selected then
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                    RageUI.CloseAll()
                else
                    ESX.ShowNotification('Personne autoure')
                end
            end
        end)
    end)
    end
end)


Citizen.CreateThread(function() ---------------------------------------------- ouvrir menu f6 ------------------------------
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased( 0, 166) then
			RageUI.Visible(RMenu:Get('civile', 'main'), true)
            RefreshMoney()
            RefreshMoney2()   
		end
	end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(750)
        closestPlayer = ESX.Game.GetClosestPlayer()
        closestDistance = ESX.Game.GetClosestPlayer()
        playerPed = PlayerPedId()
        IsInVeh = IsPedSittingInAnyVehicle(playerPed)
        locked = GetVehicleDoorLockStatus(playervh)
        playervh = GetVehiclePedIsIn(playerPed, false)
        plaque = GetVehicleNumberPlateText(playervh)
    end
end)



