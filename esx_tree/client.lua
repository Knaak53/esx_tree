local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)

local TreeStation = {}

local TreePos = {
    { x = -511.607, y = 5401.295, z = 72.904 },
    { x = -499.199, y = 5390.437, z = 74.658 },
    { x = -487.308, y = 5391.439, z = 75.976 },
    { x = -516.813, y = 5382.376, z = 69.32 },
    { x = -519.28, y = -5390.956, z = 69.314 },
    { x = -520.488, y = 5396.993, z = 70.954 },
    { x = -489.21, y = 5387.261, z = 75.823 },
    { x = -483.748, y = 5387.838, z = 76.445 },
    { x = -489.176, y = 5396.343, z = 75.545 },
    { x = -466.356, y = 5396.036, z = 77.17 },
}

Citizen.CreateThread(function()
    LoadModel('Prop_Tree_Cedar_03')

    LoadModel('prop_woodpile_01c')

    LoadAnimDict('melee@hatchet@streamed_core')

    LoadAnimDict('melee@large_wpn@streamed_core')

    LoadAnimDict('anim@heists@narcotics@trash')
end)

Citizen.CreateThread(function()
    while true do 
        for k, v in pairs(TreePos) do 
            local Tree = CreateObject(GetHashKey('Prop_Tree_Cedar_03'), v.x, v.y, v.z, true, true, true)
            FreezeEntityPosition(Tree, true)

            table.insert(TreeStation, Tree)
        end
        Citizen.Wait(30000)
        for k, v in pairs(TreeStation) do 
            DeleteEntity(v)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        for _, tree in pairs(TreeStation) do
            local TreeCoords = GetEntityCoords(tree)
            local PlyToTree = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(tree), true)

            if PlyToTree < 3.0 then
                Draw3DText(TreeCoords.x, TreeCoords.y, TreeCoords.z + 2, '[~g~E~s~]砍樹')
                
                if IsControlJustReleased(0, 38) then
                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_HATCHET')  then
                        CutTree(tree)
                    else
                        Notify('你沒有斧頭!')
                    end
                end
            end
        end
    end
end)

--[[	Function	]]
function CutTree(tree)
    local ped = PlayerPedId()
    local heal = GetEntityHeading(GetPlayerPed(-1))  
    heal = heal + 180  

    FreezeEntityPosition(ped, true)
    TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown", 8.0, -8.0, -1, 0, 0, false, false, false) 
    Wait(2000)
    TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown", 8.0, -8.0, -1, 0, 0, false, false, false)  
    Wait(2000)
    TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown_b", 8.0, -8.0, -1, 0, 0, false, false, false)
    Wait(2000)
    ClearPedTasksImmediately(PlayerPedId())
    SetEntityRotation(tree, 10.0, -0, heal, false, true)
	Citizen.Wait(100)
	SetEntityRotation(tree, 20.0, -0, heal, false, true)
	Citizen.Wait(100)
	SetEntityRotation(tree, 30.0, -0, heal, false, true)
	Citizen.Wait(100)
	SetEntityRotation(tree, 40.0, -0, heal, false, true)
	Citizen.Wait(100)
	SetEntityRotation(tree, 50.0, -0, heal, false, true)
	Citizen.Wait(100)
	SetEntityRotation(tree, 60.0, -0, heal, false, true)
	Citizen.Wait(100)
	SetEntityRotation(tree, 70.0, -0, heal, false, true)
	Citizen.Wait(100)
    SetEntityRotation(tree, 80.0, -0, heal, false, true)
    Citizen.Wait(100)
    FreezeEntityPosition(ped, false)
    BreakTrue(tree)
end

function BreakTrue(tree)
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local PlyCoords = GetEntityCoords(PlayerPedId())
            local PlyToTree = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(tree), true)

            if DoesEntityExist(tree) then
                if PlyToTree > 4.0 and PlyToTree < 8.0 then
                    Draw3DText(PlyCoords.x, PlyCoords.y, PlyCoords.z + 1 , '[~g~E~w~]切割木頭')

                    if IsControlJustReleased(0, 38) then
                        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_HATCHET')  then
                            FreezeEntityPosition(PlayerPedId(), true)
                            TaskPlayAnim(PlayerPedId(), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, -8.0, -1, 0, 0, false, false, false)  
                            Wait(2000)
                            TaskPlayAnim(PlayerPedId(), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, -8.0, -1, 0, 0, false, false, false)  
                            Wait(2000)
                            TaskPlayAnim(PlayerPedId(), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, -8.0, -1, 0, 0, false, false, false)  
                            Wait(2000)
                            FreezeEntityPosition(PlayerPedId(), false)
                            ClearPedTasksImmediately(PlayerPedId())
                            Wait(1000)
                            DeleteEntity(tree)
                            GetWood()
                        else
                            Notify('你沒有斧頭!')
                        end
                    end
                end
            end
        end
    end)
end

function GetWood()
    local PlyCoords = GetEntityCoords(PlayerPedId())
    local wood = CreateObject(GetHashKey('prop_woodpile_01c'), PlyCoords.x + 2, PlyCoords.y + 2, PlyCoords.z - 1, true, true, true)
    local WoodCoords = GetEntityCoords(wood)
    local PlyToWood = GetDistanceBetweenCoords(PlyCoords, WoodCoords, true)
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            if DoesEntityExist(wood) then
                if PlyToWood < 3.0 then
                    Draw3DText(WoodCoords.x, WoodCoords.y, WoodCoords.z + 1, '[~g~E~s~]拾取木材')
        
                    if IsControlJustReleased(0, 38) then
                        TaskPlayAnim(PlayerPedId(), "anim@heists@narcotics@trash", "pickup", 8.0, -8.0, -1, 0, 0, false, false, false) 
                        Citizen.Wait(2000)
                        TriggerServerEvent('Tree:GetWood')
                        DeleteObject(wood)
                    end
                end
            end
        end
    end)
end 

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end

function Draw3DText(x, y, z, text)
    SetTextScale(0.4, 0.4)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end
