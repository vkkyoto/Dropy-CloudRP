ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('VkkyotoSzef:robiszlodaxd', function(obj) 
			ESX = obj 
		end)
		
		Wait(250)
	end
end)

local Parachute, Crate, soundID
local CanOpen = true

local PlaneDistance = 400.0

local Zrzuty = {}

RegisterNetEvent('vkkyoto:pokazblipa')
AddEventHandler('vkkyoto:pokazblipa', function()
    local blip = AddBlipForCoord(vec3(2269.6721191406, 2040.3735351563, 229.01914978027))
    SetBlipPriority(blip, 6)
    SetBlipScale(blip, Config.Blip['airdrops'].scale)
    SetBlipSprite(blip, Config.Blip['airdrops'].sprite)
    SetBlipColour(blip, Config.Blip['airdrops'].colour)
    SetBlipAlpha(blip, Config.Blip['airdrops'].alpha)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('# Zrzut zaopatrzenia')
    EndTextCommandSetBlipName(blip)
end)


RegisterNetEvent('vkkyoto:runAirDrop')
AddEventHandler('vkkyoto:runAirDrop', function(walasfhjklasjgkhf)
    ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
        if MisiaczekPlayers then
            if MisiaczekPlayers['players'] >= 0 then
                math.randomseed(GetGameTimer())

                local DropCoords = Config.AirDrops.spawns[math.random(1, #Config.AirDrops.spawns)]

                TriggerServerEvent('vkkyoto:wyslijpowiadomienie')

                --ESX.ShowNotification('Na ~b~GPS ~w~oznaczono miejsce ~b~zrzutu,~w~ w którym do ~b~zgarnięcia ~w~są nagrody!')
                Citizen.CreateThread(function()
                    for _, model in ipairs(Config.AirDrops.models) do
                        LoadModel(model)
                    end

                    RequestWeaponAsset(GetHashKey('weapon_flare')) 
                    while not HasWeaponAssetLoaded(GetHashKey('weapon_flare')) do
                        Wait(0)
                    end

                    Crate = CreateObject(GetHashKey('prop_box_wood02a_pu'), DropCoords, true, true, true) 
                    SetEntityLodDist(Crate, 1000) 
                    ActivatePhysics(Crate)
                    SetDamping(Crate, 2, 0.1) 
                    SetEntityVelocity(Crate, 0.0, 0.0, -0.2) 

                    Parachute = CreateObject(GetHashKey('p_cargo_chute_s'), DropCoords, true, true, true) 
                    SetEntityLodDist(Parachute, 1000)
                    SetEntityVelocity(Parachute, 0.0, 0.0, -0.2)

                    soundID = GetSoundId() 
                    PlaySoundFromEntity(soundID, 'Crate_Beeps', Crate, 'MP_Crate_DROP_SOUNDS', true, 0) 

                    AttachEntityToEntity(Parachute, Crate, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

                    while not HasObjectBeenBroken(Crate) do
                        Wait(0)
                    end
                    

                    local ParachuteCoords = vector3(GetEntityCoords(Parachute))
                    ShootSingleBulletBetweenCoords(ParachuteCoords, ParachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey('weapon_flare'), 0, true, false, -1.0) 
                    DetachEntity(Parachute, true, true)

                    DeleteEntity(Parachute)
                    DetachEntity(Crate)

                    ESX.Game.SpawnObject('ex_prop_adv_case_sm', ParachuteCoords, function(obj)
                        SetEntityHeading(obj, GetEntityHeading(playerPed) + 180)
                        PlaceObjectOnGroundProperly(obj)
                
                        x, y, z = table.unpack(GetEntityCoords(obj))
                        TriggerServerEvent('vkkyoto:spawnedZrzut', walasfhjklasjgkhf, { x = x, y = y, z = z })
                    end)

                end)
            else
                ESX.ShowNotification('~r~Nie ma wystarczającej liczby obywateli na dzielnicy!')
            end
        end
    end)
end)

AddLocationOnMap = function(coords)
    --[[ESX.ShowNotification('Na ~b~GPS ~w~oznaczono miejsce ~b~zrzutu,~w~ w którym do ~b~zgarnięcia ~w~są nagrody!')

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipPriority(blip, 6)
    SetBlipScale(blip, Config.Blip['airdrops'].scale)
    SetBlipSprite(blip, Config.Blip['airdrops'].sprite)
    SetBlipColour(blip, Config.Blip['airdrops'].colour)
    SetBlipAlpha(blip, Config.Blip['airdrops'].alpha)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('# Zrzut zaopatrzenia')
    EndTextCommandSetBlipName(blip)--]]
end

LoadModel = function(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(10)
    end
end

LoadAnim = function(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(10)
    end
end

RegisterNetEvent('vkkyoto:spawnedZrzut')
AddEventHandler('vkkyoto:spawnedZrzut', function(zrzut, coords)
	table.insert(Zrzuty, {id = zrzut, coords = coords})
    AddLocationOnMap(coords)
end)

RegisterNetEvent('vkkyoto:wyjebZrzut')
AddEventHandler('vkkyoto:wyjebZrzut', function(KurwaZrzut)
	for i, zrzut in ipairs(Zrzuty) do
		if zrzut.id == KurwaZrzut then
			table.remove(Zrzuty, i)
			break
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(2)
			local ped = PlayerPedId()

			local coords, sleep = GetEntityCoords(ped), true
			for i, zrzut in ipairs(Zrzuty) do
				local objectDistance = #(coords - vec3(zrzut.coords.x, zrzut.coords.y, zrzut.coords.z))
				if objectDistance < 5.0 then
					sleep = false
					DrawText3Ds(zrzut.coords.x, zrzut.coords.y, zrzut.coords.z + 0.2, "Naciśnij [E] aby podnieść okup")
					if objectDistance < 1.3 and IsControlJustPressed(0, 38) then

						RequestAnimDict("amb@prop_human_bum_bin@idle_b")
						while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
							Citizen.Wait(0)
						end

						local pid = PlayerPedId()
						TaskPlayAnim(pid, "amb@prop_human_bum_bin@idle_b", "idle_d", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                        FreezeEntityPosition(PlayerPedId(), true)
                        exports["cloud_taskbar"]:taskBar(40000, "Trwa zbieranie dropu", false, true)
                        FreezeEntityPosition(PlayerPedId(), false)
						StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                        ClearPedTasksImmediately(PlayerPedId())
						ESX.ShowNotification("Podniosles zrzut")							
						TriggerServerEvent('vkkyoto:openDrop', zrzut.id)

					end
				end
			end
		if sleep then
			Citizen.Wait(666)
		end
	end
end)

function DrawText3Ds(x, y, z, text)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vec3(px, py, pz) - vec3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(1)

    SetTextEntry("STRING")
    AddTextComponentString(text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    DrawText(_x,_y)

	local factor = text:len() / 250
	DrawRect(_x, _y + 0.0125, 0.005 + factor, 0.03, 41, 11, 41, 68)
end
