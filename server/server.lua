ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- REMOVE MONEY

RegisterServerEvent("esx:rent:server:removemoney")
AddEventHandler("esx:rent:server:removemoney", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(money)
end)

RegisterServerEvent("esx_rent:server:markAsUsed")
AddEventHandler("esx_rent:server:markAsUsed", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    xPlayer.addInventoryItem('box', 1)
end)


-- START

AddEventHandler('onResourceStart', function(ressourceName)
 
if(GetCurrentResourceName() ~= ressourceName)then
    return
end
    print(ressourceName.." Started")
    print("This scrip is create by Sergio")
end)
 


-- STOP

AddEventHandler('onResourceStop', function(ressourceName)
 
if(GetCurrentResourceName() ~= ressourceName)then
    return
end
    print(ressourceName.." Stopped")
end)


RegisterServerEvent("esx_rent:server:removeMoney")
AddEventHandler("esx_rent:server:removeMoney", function()

    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if xPlayer.getMoney() >= Config.PriceRent then
        xPlayer.removeMoney(Config.PriceRent)
        xPlayer.showNotification(Config.MessageRent)
    else 
        xPlayer.showNotification(Config.MessageNoMoney)
    end
end)

