local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterServerEvent('Tree:GetWood')
AddEventHandler('Tree:GetWood', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = math.random(2, 4)

    xPlayer.addInventoryItem("wood", amount)
    TriggerClientEvent('esx:showNotification', source, '你獲得了 ~g~' .. amount .. ' ~w~片木板')
end)