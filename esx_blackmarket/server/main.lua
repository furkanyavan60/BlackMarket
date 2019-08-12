ESX = nil

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local number = {}


--alarm




--GET INVENTORY ITEM
ESX.RegisterServerCallback('esx_blackmarket:getInventory', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({items = items})

end)

------------------------------------------------------






RegisterServerEvent('esx_blackmarket:chopNotify')
AddEventHandler('esx_blackmarket:chopNotify', function()
    TriggerClientEvent("esx_blackmarket:chopEnable", source)
end)


RegisterServerEvent('esx_blackmarket:ChopInProgress')
AddEventHandler('esx_blackmarket:ChopInProgress', function(street1, street2, sex)
    TriggerClientEvent("esx_blackmarket:outlawNotify", -1, "~r~Someone is Chopping a vehicle")

end)


RegisterServerEvent('esx_blackmarket:ChopInProgressS1')
AddEventHandler('esx_blackmarket:ChopInProgressS1', function(street1, sex)
    TriggerClientEvent("esx_blackmarket:outlawNotify", -1, "~r~Someone is Chopping a vehicle")

end)



RegisterServerEvent('esx_blackmarket:ChoppingInProgressPos')
AddEventHandler('esx_blackmarket:ChoppingInProgressPos', function(gx, gy, gz)
    TriggerClientEvent('esx_blackmarket:Choplocation', -1, gx, gy, gz)
end)











------------------------------------------------------







--CALLBACKS
ESX.RegisterServerCallback('esx_blackmarket:getShopList', function(source, cb)
  local identifier = ESX.GetPlayerFromId(source).identifier
  local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE identifier = @identifier',
        {
            ['@identifier'] = '0',
        }, function(result)

      cb(result)
    end)
end)


ESX.RegisterServerCallback('esx_blackmarket:getOwnedBlips', function(source, cb)

        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE NOT identifier = @identifier',
        {
            ['@identifier'] = '0',
        }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback('esx_blackmarket:getAllShipments', function(source, cb, id)
  local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
        'SELECT * FROM black_shipments WHERE id = @id AND identifier = @identifier',
        {
            ['@id'] = id,
            ['@identifier'] = identifier,
        }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('esx_blackmarket:getMuhShipments', function(source, cb, id)
  local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
        'SELECT * FROM black_muhshipments WHERE id = @id AND identifier = @identifier',
        {
            ['@id'] = id,
            ['@identifier'] = identifier,
        }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('esx_blackmarket:getTime', function(source, cb)
    cb(os.time())
end)

ESX.RegisterServerCallback('esx_blackmarket:getOwnedShop', function(source, cb, id)
local src = source
local identifier = ESX.GetPlayerFromId(src).identifier

        MySQL.Async.fetchAll(
        'SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = identifier,
        }, function(result)

        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('esx_blackmarket:getShopItems', function(source, cb, number)
  local identifier = ESX.GetPlayerFromId(source).identifier
  
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = identifier,
        }, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('esx_blackmarkets:GetAllItems')
AddEventHandler('esx_blackmarkets:GetAllItems', function(id)
    local _source = source
    local identifier = ESX.GetPlayerFromId(_source).identifier
    local xPlayer = ESX.GetPlayerFromId(_source)
	local sans = math.random(1,100)

    MySQL.Async.fetchAll(
    'SELECT * FROM black_shipments WHERE id = @id AND identifier = @identifier',
    {
        ['@id'] = id,
        ['@identifier'] = identifier
    }, function(result)
	if sans <= 90 then 
        for i=1, #result, 1 do
		
			xPlayer.addWeapon(result[i].item, 0)
			
            MySQL.Async.fetchAll('DELETE FROM black_shipments WHERE id = @id AND identifier = @identifier',{['@id'] = id,['@identifier'] = identifier,})
        end
	else
	MySQL.Async.fetchAll('DELETE FROM black_shipments WHERE id = @id AND identifier = @identifier',{['@id'] = id,['@identifier'] = identifier,})
	TriggerClientEvent("pNotify:SendNotification", _source,{
                    text = ("Silahlar teslim edilemedi.. Teslimat başarısız!"),
                    type = "error",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            ) 	
	end
    end)
end)

RegisterServerEvent('esx_blackmarkets:GetMuhimItem')
AddEventHandler('esx_blackmarkets:GetMuhimItem', function(id)
    local _source = source
    local identifier = ESX.GetPlayerFromId(_source).identifier
    local xPlayer = ESX.GetPlayerFromId(_source)
	local sans = math.random(1,100)

    MySQL.Async.fetchAll(
    'SELECT * FROM black_muhshipments WHERE id = @id AND identifier = @identifier',
    {
        ['@id'] = id,
        ['@identifier'] = identifier
    }, function(result)
	if sans <= 90 then 
        for i=1, #result, 1 do
           
			xPlayer.addInventoryItem(result[i].item, 1)
            MySQL.Async.fetchAll('DELETE FROM black_muhshipments WHERE id = @id AND identifier = @identifier',{['@id'] = id,['@identifier'] = identifier,})
        end
	else
	MySQL.Async.fetchAll('DELETE FROM black_muhshipments WHERE id = @id AND identifier = @identifier',{['@id'] = id,['@identifier'] = identifier,})
	TriggerClientEvent("pNotify:SendNotification", _source,{
                    text = ("Muhimmatlar teslim edilemedi.. Teslimat başarısız!"),
                    type = "error",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            ) 	
	end
    end)
end)


-----------------------------------------------------------------------------------------










--------------------------------------------------------------------------------------------





RegisterServerEvent('esx_blackmarket:MakeShipment')
AddEventHandler('esx_blackmarket:MakeShipment', function(id, item, price, count, label)
  local _source = source
  local identifier = ESX.GetPlayerFromId(_source).identifier
  local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT money FROM users WHERE identifier = @identifier',{['@identifier'] = identifier,}, function(result)

        if result[1].money >= price * count then

            MySQL.Async.execute('INSERT INTO black_shipments (id, label, identifier, item, price, count, time) VALUES (@id, @label, @identifier, @item, @price, @count, @time)',{['@id']       = id,['@label']      = label,['@identifier'] = identifier,['@item']       = item,['@price']      = price,['@count']      = count,['@time']       = os.time()})
            MySQL.Async.fetchAll("UPDATE users SET money = @money WHERE identifier = @identifier",{['@money']    = result[1].money - price * count,})  
            -- TriggerClientEvent('esx:showNotification', _source, '~g~You ordered' .. count .. ' pieces ' .. label .. ' for $' .. price * count)
			
			TriggerClientEvent("pNotify:SendNotification", _source,{
                    text = (" " .. price * count .. "$ ödedin ve " .. count .. " Adet " .. label .. " siparişi verdin!"),
                    type = "alert",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            ) 			
			
            xPlayer.removeMoney(price * count)
        else
            --TriggerClientEvent('esx:showNotification', _source, '~r~Yeterince paran yok.')
			
			TriggerClientEvent("pNotify:SendNotification", _source,{
                    text = ("Yeterince paran yok."),
                    type = "error",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            ) 	
			
        end
    end)
end)

RegisterServerEvent('esx_blackmarket:MakeShipmentMuh')
AddEventHandler('esx_blackmarket:MakeShipmentMuh', function(id, item, price, count, label)
  local _source = source
  local identifier = ESX.GetPlayerFromId(_source).identifier
  local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT money FROM users WHERE identifier = @identifier',{['@identifier'] = identifier,}, function(result)

        if result[1].money >= price * count then

            MySQL.Async.execute('INSERT INTO black_muhshipments (id, label, identifier, item, price, count, time) VALUES (@id, @label, @identifier, @item, @price, @count, @time)',{['@id']       = id,['@label']      = label,['@identifier'] = identifier,['@item']       = item,['@price']      = price,['@count']      = count,['@time']       = os.time()})
            MySQL.Async.fetchAll("UPDATE users SET money = @money WHERE identifier = @identifier",{['@money']    = result[1].money - price * count,})  
            -- TriggerClientEvent('esx:showNotification', _source, '~g~You ordered' .. count .. ' pieces ' .. label .. ' for $' .. price * count)
			
			TriggerClientEvent("pNotify:SendNotification", _source,{
                    text = (" " .. price * count .. "$ ödedin ve " .. count .. " Adet " .. label .. " siparişi verdin!"),
                    type = "alert",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            ) 			
			
            xPlayer.removeMoney(price * count)
        else
            --TriggerClientEvent('esx:showNotification', _source, '~r~Yeterince paran yok.')
			
			TriggerClientEvent("pNotify:SendNotification", _source,{
                    text = ("Yeterince paran yok."),
                    type = "error",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            ) 	
			
        end
    end)
end)
