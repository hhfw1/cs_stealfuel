
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('hhfw:client:useStealEmptyFuel', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(Ecan)
        if not Ecan then QBCore.Functions.Notify("You need empty can to steal fuel", "error") return end
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local veh = QBCore.Functions.GetClosestVehicle(pos)
        if veh == nil or veh == 0 then return end
        if #(pos - GetEntityCoords(veh)) > 2.5 then return end
        local fuel = math.floor(exports[CodeStudio.FuelType]:GetFuel(veh))
        if fuel > 1 then
            local seconds = CodeStudio.Seconds
            local circles = CodeStudio.Circles
            SetVehicleAlarm(veh, true)
            StartVehicleAlarm(veh)
            SetVehicleAlarmTimeLeft(veh, 30000)
            ExecuteCommand('e mechanic3')
            QBCore.Functions.Progressbar("stealfuel", "Stealing Fuel..", CodeStudio.StealTime * 1000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                if CodeStudio.EnableMiniGame then
                    exports['abrp_ui']:Circle(function(success)
                        if success then
                            ExecuteCommand('e c')
                            exports[CodeStudio.FuelType]:SetFuel(veh, 0)
                            TriggerServerEvent('hhfw:stealfuel:server', fuel)
                        else
                            ExecuteCommand('e c')
                            if CodeStudio.ExplodeOnFail then
                                QBCore.Functions.Notify("Failed, Engine Caught Fire", "error")
                                Wait(1600)
                                AddExplosion(GetEntityCoords(veh), 5, 50.0, true, false, true)
                            end
                            if CodeStudio.RemoveOnFail then 
                                TriggerEvent("inventory:client:ItemBox", "empty_can", "remove")
                                TriggerServerEvent("QBCore:Server:RemoveItem", "empty_can", 1)
                            end
                        end
                    end, circles, seconds)
                else
                    ExecuteCommand('e c')
                    exports[CodeStudio.FuelType]:SetFuel(veh, 0)
                    TriggerServerEvent('hhfw:stealfuel:server', fuel)
                end
            end, function()
                QBCore.Functions.Notify("Canceled!", "error")
            end)
        else
            QBCore.Functions.Notify("Fuel Tank is Empty!", "error")
        end
    end, "empty_can")
end)


RegisterNetEvent('hhfw:client:useStealFuel', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local veh = QBCore.Functions.GetClosestVehicle(pos)
    if veh == nil or veh == 0 then return end
    if #(pos - GetEntityCoords(veh)) > 2.5 then QBCore.Functions.Notify("No Vehicle Nearby!", "error") return end
    local tank = math.floor(exports[CodeStudio.FuelType]:GetFuel(veh))
    if tank <= 99 then
        QBCore.Functions.TriggerCallback('hhfw:server:checkStealCan', function(fuel)
            TaskTurnPedToFaceEntity(ped, veh, 1000)
            Wait(1000)
            LoadAnimDict("weapon@w_sp_jerrycan")
            TaskPlayAnim(ped,"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            local hash = GetHashKey("w_am_jerrycan")
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(100)
                RequestModel(hash)
            end
            local prop = CreateObject(hash, GetEntityCoords(PlayerPedId()), true, true, true)
            AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.0, 0.0, 0.2, -150.0, -50.0, -250.0, true, true, false, false, 1, true)
            QBCore.Functions.Progressbar("stealfuel", "Filling Fuel..", CodeStudio.RefuellingTime * 1000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                exports[CodeStudio.FuelType]:SetFuel(veh, fuel+tank)
                QBCore.Functions.Notify("Tank Filled!", "success")
                DeleteEntity(prop)
            end, function()
                QBCore.Functions.Notify("Canceled!", "error")
            end)
        end, tonumber(100-tank))
    end
end)


function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
end


if CodeStudio.EnableShops then 
    CreateThread(function()
        RequestModel(GetHashKey(CodeStudio.ShopPed))
        while not HasModelLoaded(GetHashKey(CodeStudio.ShopPed)) do
            Wait(1)
        end

        local options = {}
        local option = { 
            type = "client",
            event = "hhfw:mechanic:client:Store",
            icon = "fas fa-circle",
            label = 'Open Shop'
        }
        table.insert(options, option)
        for k,v in pairs(CodeStudio.Location) do
            exports[CodeStudio.Target]:SpawnPed({
                model = GetHashKey(CodeStudio.ShopPed),
                coords = v,
                minusOne = true,
                freeze = true,
                invincible = true,
                blockevents = true,
                scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                target = {
                    options = options,
                    distance = 3.0 
                },
                spawnNow = true,
            })
        end
    end)

    RegisterNetEvent('hhfw:mechanic:client:Store', function()
        TriggerServerEvent('inventory:server:OpenInventory', "shop", 'fuelshop', CodeStudio.ToolItems)
    end)
end




