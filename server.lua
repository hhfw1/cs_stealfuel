local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('hhfw:server:checkStealCan', function(source, cb, tank)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName("filled_can")
    local AFuel = Player.PlayerData.items[item.slot].info.fuel
    if (AFuel - tank) <= 0 then
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        Player.Functions.AddItem("empty_can", 1, item.slot)
        cb(AFuel)
    else
        AFuel = AFuel - tank
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        info = {
            fuel = tonumber(AFuel)
        }
        Player.Functions.AddItem(item.name, 1, item.slot, info)
        cb(AFuel)
    end
end)


QBCore.Functions.CreateUseableItem("filled_can", function(source)
    local src = source
    TriggerClientEvent('hhfw:client:useStealFuel', src)
end)


QBCore.Functions.CreateUseableItem("empty_can", function(source)
    local src = source
    TriggerClientEvent('hhfw:client:useStealEmptyFuel', src)
end)


RegisterNetEvent('hhfw:stealfuel:server', function(oil)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('empty_can', 1) then 
        info = {
            fuel = tonumber(oil)
        }
        TriggerClientEvent('inventory:client:ItemBox', src, 'filled_can', "add")
        Player.Functions.AddItem("filled_can", 1, false, info)
        TriggerClientEvent('QBCore:Notify', src, "Recieved "..oil.."% Fuel", "success")
    end
end)



