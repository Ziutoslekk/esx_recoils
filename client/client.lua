Server = Config.Servers[math.random(1, #Config.Servers)]

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while true do
        if IsControlJustReleased(0, 183) then
            OpenRecoilsMenu()
        end

        if Server then
            if IsPedShooting(PlayerPedId()) then
                local playerWeapon = GetSelectedPedWeapon(PlayerPedId())

                if Server.recoil then
                    local weaponRecoil = Server.recoil[playerWeapon]
                    
                    if weaponRecoil and #weaponRecoil > 0 then
                        local i, tv = (1 or 2), 0
                        if GetFollowPedCamViewMode() ~= 4 and GetFollowPedCamViewMode() == 4  then
                            repeat
                                SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
                                tv = tv + 0.1
                                Citizen.Wait(0)
                            until tv >= weaponRecoil[i]
                        else
                            repeat
                                local t = GetRandomFloatInRange(0.1, weaponRecoil[i])
                                SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (weaponRecoil[i] > 0.1 and 1.2))
                                tv = tv + t
                                Citizen.Wait(0)
                            until tv >= weaponRecoil[i]
                        end
                    end
                end
                
                if Server.effect then
                    local weaponEffect = Server.effect[playerWeapon]

                    if weaponEffect and #weaponEffect > 0 then
                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ((weaponEffect[1] * 3) or weaponEffect[2]))
                    end
                end
            end
        else
            Citizen.Wait(250)
        end

        Citizen.Wait(0)
    end
end)

OpenRecoilsMenu = function ()
    local elements = {}
	table.insert(elements, { label = ("Wybrany recoil: <span style='color: #7cfc00;'>%s</span>"):format(Server and Server.name or "Brak"), value = "recoils" })

    for i=1, #Config.Servers do
        table.insert(elements, { label = Config.Servers[i].name })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_recoil', {
		title    = 'Wybierz Recoil',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        if (data.current.value ~= "recoils") then
            SetRecoil(data.current.label)
        end
        OpenRecoilsMenu()
	end, function(data, menu)
		menu.close()
	end)
end

ViewmodeTick = function()
    local checkOut = nil
    
    while true do
		if IsPlayerFreeAiming(PlayerId()) or IsControlPressed(1, 25) or IsControlPressed(1, 24) then
            if GetFollowPedCamViewMode() == 4 and checkOut == false then
                checkOut = false
            else
                SetFollowPedCamViewMode(4)
                checkOut = true
            end
        else
            if checkOut == true then
                SetFollowPedCamViewMode(1)
                checkOut = false
			end
		end

        if GetFollowPedCamViewMode() ~= 4 then 
            DisableControlAction(0, 140, true) 
            DisablePlayerFiring(PlayerPedId(), true) 
        else
            Citizen.Wait(100)
        end

        if not Config.Controls then
            if IsPedArmed(PlayerPedId(), 6) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
        end
	
        Citizen.Wait(0)
    end
end
Citizen.SetTimeout(0, ViewmodeTick)

DotManager = function()
	while true do
		if not Config.Dot then
			HideHudComponentThisFrame(14)
            DisplayAmmoThisFrame(false)
            SetPlayerTargetingMode(2)
		end

		Citizen.Wait(0)
	end
end
Citizen.SetTimeout(0, DotManager)

SetRecoil = function(name)
    for i=1, #Config.Servers do
        if Config.Servers[i].name == name then
            Server = Config.Servers[i]
            
            break
        end
    end
end