local QBCore = exports['qb-core']:GetCoreObject()

---------------
-- VARIABLES --
---------------
local CurrentCops = 0
local isActive = false
local cutPower = false
local pcHack = false
local isLooted = false

local hack1Blip = nil
local PCBlip = nil
local LootBlip = nil


-- on player load ( prevent exploit )
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('nxte-humain:server:SetInfoOnLoad')
end)
---------------
-- FUNCTIONS --
---------------


local function PowerBlip()
    hack1Blip = AddBlipForCoord(3498.17, 3653.05, 42.6)
    SetBlipSprite(hack1Blip, 436)
    SetBlipColour(hack1Blip, 69)
    SetBlipDisplay(hack1Blip, 4)
    SetBlipScale(hack1Blip, 0.8)
    SetBlipAsShortRange(hack1Blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Power Supply')
    EndTextCommandSetBlipName(hack1Blip)
    SetBlipRoute(hack1Blip, true)
end

local function PCBlip()
    PCBlip = AddBlipForCoord(3536.43, 3658.8, 29.42)
    SetBlipSprite(PCBlip, 606)
    SetBlipColour(PCBlip, 69)
    SetBlipDisplay(PCBlip, 4)
    SetBlipScale(PCBlip, 0.8)
    SetBlipAsShortRange(PCBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Hack PC')
    EndTextCommandSetBlipName(PCBlip)
    SetBlipRoute(PCBlip, false)
end

local function LootBlip()
    LootBlip = AddBlipForCoord(3622.7, 3730.36, 30.54)
    SetBlipSprite(LootBlip, 478)
    SetBlipColour(LootBlip, 69)
    SetBlipDisplay(LootBlip, 4)
    SetBlipScale(LootBlip, 0.8)
    SetBlipAsShortRange(LootBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Crate')
    EndTextCommandSetBlipName(LootBlip)
    SetBlipRoute(LootBlip, false)
end



local PlantBomb = function()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do Wait(50) end
    local ped = PlayerPedId() 
    local pos = vector4(3499.45, 3652.84, 42.6, 264.01) 
    SetEntityHeading(ped, pos.w)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, pos.x, pos.y, pos.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local charge = CreateObject(`ch_prop_ch_explosive_01a`, x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(charge, false, true)
    AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Wait(5000)
    DetachEntity(charge, 1, 1)
    FreezeEntityPosition(charge, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)
    QBCore.Functions.Notify('The bomb will explode in 30 seconds!', 'success')
    Citizen.Wait(30000)
    DeleteEntity(charge) 
    AddExplosion(3499.45, 3652.84, 42.6, 50, 5.0, true, false, 15.0) 
    TriggerEvent('nxte-humain:client:setBlackout')
    QBCore.Functions.Notify('You cut the power to the city!', 'success')
    RemoveBlip(hack1Blip)
    PCBlip()
    if Config.SpawnPedOnBlackout then 
        TriggerEvent('nxte-humain:client:SpawnNPC', 1)
    end
end

local function OnHackDone(success)
    if Config.SpawnPedOnHack then 
        TriggerEvent('nxte-humain:client:SpawnNPC', 2)
    end

    if success then 
        RemoveBlip(PCBlip)
        LootBlip()
        QBCore.Functions.Notify('Successfully hacked the PC', 'success')
        TriggerServerEvent('QBCore:Server:RemoveItem', Config.PCItem, 1, slot, info)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.PCItem], 'remove')
        TriggerServerEvent('nxte-humain:server:setHack', true)
    else
        QBCore.Functions.Notify('You failed to hack the PC!', 'error')
        TriggerServerEvent('QBCore:Server:RemoveItem', Config.PCItem, 1, slot, info)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.PCItem], 'remove')
    end
end

------------
-- EVENTS --
------------
-- trigger blackout 
RegisterNetEvent('nxte-humain:client:setBlackout', function()
    TriggerServerEvent("qb-weathersync:server:toggleBlackout")
    Citizen.Wait(Config.BlackoutTimer*60000)
    TriggerServerEvent("qb-weathersync:server:toggleBlackout")
end)

-- start heist
RegisterNetEvent('nxte-humain:client:startheist', function()
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(3.84, -200.72, 52.0))
    SetEntityHeading(ped, 341.87)
    FreezeEntityPosition(ped , true)
    local Player = QBCore.Functions.GetPlayerData()
    local cash = Player.money.cash

    TriggerServerEvent('nxte-humain:server:GetCops')
    TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
    QBCore.Functions.Progressbar("door", "knocking on door", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        FreezeEntityPosition(ped , false)
        if CurrentCops >= Config.MinCop then 
            if not isActive then 
                if cash >= Config.StartPrice then
                    TriggerServerEvent('nxte-humain:server:setactive', true)
                    QBCore.Functions.Notify('You paid $ '..Config.StartPrice.. ' , watch your GPS for the power supply location', 'success')
                    TriggerServerEvent('nxte-humain:server:removecash', Config.StartPrice)
                    PowerBlip()
                    -- start heist
                else
                    QBCore.Functions.Notify('Come back when you have my money', 'error')
                end
            else 
                QBCore.Functions.Notify('Nobody answered the door right now', 'error') 
            end
        else
            QBCore.Functions.Notify('There is not enough police', 'error') 
        end
    end, function() -- Cancel
        FreezeEntityPosition(ped , false)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Canceled knocking on the door", "error")
    end)
end)


-- cut power supply 
RegisterNetEvent('nxte-humain:client:cutpower', function()
    TriggerServerEvent('nxte-humain:server:setactive')
    if not isActive then
        QBCore.Functions.Notify('You can\'t do this right now', 'error') 
    else
        if not cutPower then 
            if QBCore.Functions.HasItem(Config.PowerItem) then 
                TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
                QBCore.Functions.Progressbar("power", "Placing Thermite...", 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    exports["memorygame"]:thermiteminigame(Config.BombBlocks,Config.BombBlocksFail, Config.BombShowTime, Config.BombHackTime,
                    function() -- success
                        TriggerServerEvent('nxte-humain:server:setpower', true)
                        TriggerServerEvent('QBCore:Server:RemoveItem', Config.PowerItem, 1, slot, info)
                        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.PowerItem], 'remove')
                        PlantBomb()
                    end,
                    function() -- failure
                        if Config.SpawnPedOnBlackout then 
                            TriggerEvent('nxte-humain:client:SpawnNPC', 1)
                        end
                        TriggerServerEvent('QBCore:Server:RemoveItem', Config.PowerItem, 1, slot, info)
                        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.PowerItem], 'remove')
                        QBCore.Functions.Notify('You failed to cut the power!', 'error')
                    end) 
                end, function() -- Cancel
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    QBCore.Functions.Notify("Canceled Placing Thermite...", "error")
                end)
            else
                QBCore.Functions.Notify('You don\t have the right tools to do this', 'error') 
            end
        else
            QBCore.Functions.Notify('The power has already been cut', 'error')
        end
    end
end)

RegisterNetEvent('nxte-humain:client:pchack', function()
    TriggerServerEvent('nxte-humain:server:setpower')
    if not cutPower then
        QBCore.Functions.Notify('You can\'t do this right now', 'error') 
    else
        if not pcHack then 
            if QBCore.Functions.HasItem(Config.PCItem) then 
                TriggerEvent('nxte-humain:anim:pchack')
            else
                QBCore.Functions.Notify('You don\'t have the right tools to do this', 'error') 
            end
        else 
            QBCore.Functions.Notify('This computer has already been hacked', 'error') 
        end
    end
end)


RegisterNetEvent('nxte-humain:anim:pchack', function()
    local loc = {x,y,z,h}
    loc.x = 3536.69
    loc.y = 3659.18
    loc.z = 28.12
    loc.h = 168.66

    local animDict = 'anim@heists@ornate_bank@hack'
    RequestAnimDict(animDict)
    RequestModel('hei_prop_hst_laptop')
    RequestModel('hei_p_m_bag_var22_arm_s')

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded('hei_prop_hst_laptop')
        or not HasModelLoaded('hei_p_m_bag_var22_arm_s') do
        Wait(100)
    end

    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    SetEntityHeading(ped, loc.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, 'hack_enter', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, 'hack_loop', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, 'hack_exit', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey('hei_prop_hst_laptop'), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, 'hack_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, 'hack_enter_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, 'hack_enter_laptop', 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, 'hack_loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, 'hack_loop_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, 'hack_loop_laptop', 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, 'hack_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, 'hack_exit_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, 'hack_exit_laptop', 4.0, -8.0, 1)

    Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Wait(2000)

    exports['hacking']:OpenHackingGame(Config.PCTime, Config.PCSquares, Config.PCRepeat, function(success)
        NetworkStartSynchronisedScene(netScene3)
        NetworkStopSynchronisedScene(netScene3)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, Config.BagUseID, 0, 1)
        DeleteObject(laptop)
        FreezeEntityPosition(ped, false)
        OnHackDone(success)
    end)
end)


RegisterNetEvent('nxte-humain:client:loot', function()
    TriggerServerEvent('nxte-humain:server:setHack')
    if not pcHack then 
        QBCore.Functions.Notify('You can not do this right now', 'error')
    else 
        TriggerServerEvent('nxte-humain:server:setLoot')
        Citizen.Wait(100)
        if not isLooted then
            TriggerServerEvent('nxte-humain:server:setLoot', true)
            TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
            QBCore.Functions.Progressbar("loot", "Searching Crate...", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                RemoveBlip(LootBlip)
                TriggerEvent('nxte-humain:client:giveLoot')
            end, function() -- Cancel
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify("Canceled Searching Crate...", "error")
            end)
        else
            QBCore.Functions.Notify('This crate is empty', 'error')
        end
    end
end)



RegisterNetEvent('nxte-humain:client:giveLoot', function()
    local DefaultAmount = math.random(Config.DefaultMin , Config.DefaultMax)
    TriggerServerEvent('QBCore:Server:AddItem', Config.DefaultReward, DefaultAmount, slot, info)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.DefaultReward], 'add' , DefaultAmount)

    local Rarechance =  math.random(1 , 100)
    if Rarechance <= Config.RareChance then
        local RareAmount = math.random(Config.RareMin , Config.RareMax)
        TriggerServerEvent('QBCore:Server:AddItem', Config.RareReward, RareAmount, slot, info)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.RareReward], 'add' , RareAmount)
    end

    local ExtraRarechance =  math.random(1 , 100)
    if ExtraRarechance <= Config.ExtraRareChance then
        local ExtraRareAmount = math.random(Config.ExtraRareMin , Config.ExtraRareMax)
        TriggerServerEvent('QBCore:Server:AddItem', Config.ExtraRareReward, ExtraRareAmount, slot, info)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.ExtraRareReward], 'add' , ExtraRareAmount)
    end
end)





---- Server Communication ----
RegisterNetEvent('nxte-humain:client:GetCops', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('nxte-humain:client:getactive', function(status)
    isActive = status
end)

RegisterNetEvent('nxte-humain:client:getpower', function(status)
    cutPower = status
end)

RegisterNetEvent('nxte-humain:client:getHack', function(status)
    pcHack = status
end)

RegisterNetEvent('nxte-humain:client:getLoot', function(status)
    isLooted = status
end)


-- set NPC data
RegisterNetEvent('nxte-humain:client:SpawnNPC', function(position)
    QBCore.Functions.TriggerCallback('nxte-humain:server:SpawnNPC', function(netIds, position)
        Wait(1000)
        local ped = PlayerPedId()
        for i=1, #netIds, 1 do
            local npc = NetworkGetEntityFromNetworkId(netIds[i])
            SetPedDropsWeaponsWhenDead(npc, false)
            GiveWeaponToPed(npc, Config.PedGun, 250, false, true)
            SetPedMaxHealth(npc, 300)
            SetPedArmour(npc, 200)
            SetCanAttackFriendly(npc, true, false)
            TaskCombatPed(npc, ped, 0, 16)
            SetPedCombatAttributes(npc, 46, true)
            SetPedCombatAttributes(npc, 0, false)
            SetPedCombatAbility(npc, 100)
            SetPedAsCop(npc, true)
            SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
            SetPedAccuracy(npc, 60)
            SetPedFleeAttributes(npc, 0, 0)
            SetPedKeepTask(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
        end
    end, position)
end)