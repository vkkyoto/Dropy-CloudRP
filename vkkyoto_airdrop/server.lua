ESX = nil
TriggerEvent('VkkyotoSzef:robiszlodaxd', function(obj) ESX = obj end)

local Zrzuty = {}


RegisterCommand("vkkyotodrop", function(source)
    local zrzucikpl = math.random(1111, 9999)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

    if xPlayer.group == "best" or xPlayer.group == "superadmin" or xPlayer.group == "headadmin" or xPlayer.group == "opiekunadministracji" or xPlayer.group == "starszyadmin" or xPlayer.group == "admin" then
        TriggerClientEvent("vkkyoto:runAirDrop", source, zrzucikpl)
        table.insert(Zrzuty, {id = zrzucikpl, allow = true})
    else
        xPlayer.showNotification('~r~Nie posiadasz permisji')
    end
end)

RegisterServerEvent('vkkyoto:wyslijpowiadomienie')
AddEventHandler('vkkyoto:wyslijpowiadomienie', function(id, coords)
    TriggerClientEvent('chat:addMessage1', -1, "^*System", {255, 0, 0}, "Na WIATRAKACH oznaczono miejsce zrzutu, w którym do zgarnięcia są nagrody!", "fas fa-globe-europe")
    TriggerClientEvent('vkkyoto:pokazblipa', -1)
end)

RegisterServerEvent('vkkyoto:spawnedZrzut')
AddEventHandler('vkkyoto:spawnedZrzut', function(id, coords)
    TriggerClientEvent('vkkyoto:spawnedZrzut', -1, id, coords)
end)

RegisterServerEvent('vkkyoto:openDrop')
AddEventHandler('vkkyoto:openDrop', function(dropID)
    local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	for i=1, #Zrzuty, 1 do
		if Zrzuty[i].id == dropID then
            table.remove(Zrzuty, i)
            TriggerClientEvent("vkkyoto:wyjebZrzut", -1, dropID)

            local randomDrop = Config.AirDrops.drop

            local zrzutdluga = math.random(1,10)

            if zrzutdluga >= 10 then
                xPlayer.addInventoryItem('dluga-chest', 1)
                TriggerClientEvent('chat:addMessage1', -1, "^*System", {255, 0, 0}, "Zrzut okazał sie SZCZĘŚLIWY i jest w niej rzadki pakunek!", "fas fa-globe-europe")
            end

            if string.find(xPlayer.hiddenjob.name, "org") then
                TriggerClientEvent('chat:addMessage1', -1, "^*System", {255, 0, 0}, "Organizacja "..xPlayer.hiddenjob.label.." przejeła zrzut!", "fas fa-globe-europe")
            else
                TriggerClientEvent('chat:addMessage1', -1, "^*System", {255, 0, 0}, "Chłop bez organizacji zdobył zrzut!", "fas fa-globe-europe")
            end

            if string.find(xPlayer.hiddenjob.name, "org") then
                MySQL.Async.fetchAll("SELECT zrzut FROM bitki WHERE org_name = @org_name", {
                    ["@org_name"] = xPlayer.hiddenjob.name
                }, function(res)
                    if res and res[1] then
                        local zrzutCount = res[1].zrzut + 1
                        MySQL.Async.execute("UPDATE bitki SET zrzut = @zrzut WHERE org_name = @org_name", {
                            ["@zrzut"] = zrzutCount,
                            ["@org_name"] = xPlayer.hiddenjob.name
                        }, function(rowsChanged)
                            sendToDiscord(xPlayer.source, "Organizacja **" .. xPlayer.hiddenjob.label .. "** przejeła zrzut!\n\nIlość zdobytych zrzutów: **" .. zrzutCount .. "**")
                        end)
                    end
                end)
            end

           -- if data.item then
                xPlayer.addInventoryItem('weaponchest', math.random(1,5))
                xPlayer.addInventoryItem('legalna', math.random(1,2))
                xPlayer.addInventoryItem('crimowa', math.random(1,4))
                xPlayer.addInventoryItem('kawa', math.random(100,500))
                xPlayer.addInventoryWeapon('WEAPON_VINTAGEPISTOL', math.random(5,15), 250)
                xPlayer.addInventoryWeapon('WEAPON_SNSPISTOL_MK2', math.random(5,15), 250)
                Player.addInventoryItem('cloudcoins', math.random(100,1000))
            --end
    
		end
	end
end)

function sendToDiscord(ssID, msg)
	local embed = {
		  {
			  ["color"] = "16711680",
			  ["title"] = "[CloudRP] | Zrzut",
			  ['author'] = {
				['name'] = 'Nowa Zrzut',
				['icon_url'] = 'https://i.imgur.com/5l2oZXd.png'
			  },
			  ["description"] = msg,
			 --[[ ["image"] = {
				["url"] = img,
			  },--]]
			  ["footer"] = {
				["text"] = "[" .. ssID .. "]" .. GetPlayerName(ssID),
				--["icon_url"] = 'https://i.imgur.com/5l2oZXd.png',
			  }
		  }
	  }
  
	PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  end