local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterServerEvent('Tree:GetWood')
AddEventHandler('Tree:GetWood', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = math.random(2, 4)

    if xPlayer.canCarryItem("wood", amount) then
        xPlayer.addInventoryItem("wood", amount)
        TriggerClientEvent('esx:showNotification', source, 'You received ~g~' .. amount .. ' ~w~ wood')
    else
        TriggerClientEvent('esx:showNotification', source, 'You cant carry this item')
    end
end)
