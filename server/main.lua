local QBCore = exports['qb-core']:GetCoreObject()

local isActive = false
local cutPower = false
local CurrentCops = 0
local pcHack = false
local isLooted = false

RegisterNetEvent('nxte-humain:server:removecash', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cash = Player.Functions.RemoveMoney('cash', tonumber(amount))
end)


------------- COMMUNICATION ----------------

RegisterNetEvent('nxte-humain:server:GetCops', function()
	local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    CurrentCops = amount
    TriggerClientEvent('nxte-humain:client:GetCops', -1, amount)
end)

RegisterNetEvent('nxte-humain:server:setactive', function(status)
    if status ~= nil then 
        isActive = status
        TriggerClientEvent('nxte-humain:client:getactive', -1, isActive)
    else
        TriggerClientEvent('nxte-humain:client:getactive', -1, isActive)
    end
end)

RegisterNetEvent('nxte-humain:server:setpower', function(status)
    if status ~= nil then 
        cutPower = status
        TriggerClientEvent('nxte-humain:client:getpower', -1, cutPower)
    else
        TriggerClientEvent('nxte-humain:client:getpower', -1, cutPower)
    end
end)

RegisterNetEvent('nxte-humain:server:setHack', function(status)
    if status ~= nil then 
        pcHack = status
        TriggerClientEvent('nxte-humain:client:getHack', -1, pcHack)
    else
        TriggerClientEvent('nxte-humain:client:getHack', -1, pcHack)
    end
end)

RegisterNetEvent('nxte-humain:server:setLoot', function(status)
    if status ~= nil then 
        isLooted = status
        TriggerClientEvent('nxte-humain:client:getLoot', -1, isLooted)
    else
        TriggerClientEvent('nxte-humain:client:getLoot', -1, isLooted)
    end
end)

RegisterNetEvent('nxte-humain:server:OnPlayerLoad', function()
    local src = source
    TriggerEvent('nxte-humain:server:setactive', src)
    TriggerEvent('nxte-humain:server:setpower', src)
    TriggerEvent('nxte-humain:server:setHack', src)
    TriggerEvent('nxte-humain:server:setLoot', src)
end)


--- NPC
local peds = { 
    `s_m_m_chemsec_01`
}

local getRandomNPC = function()
    return peds[math.random(#peds)]
end

QBCore.Functions.CreateCallback('nxte-humain:server:SpawnNPC', function(source, cb, loc)
    local netIds = {}
    local netId
    local npc
    for i=1, #Config.Shooters['soldiers'].locations[loc].peds, 1 do
        npc = CreatePed(30, getRandomNPC(), Config.Shooters['soldiers'].locations[loc].peds[i], true, false)
        while not DoesEntityExist(npc) do Wait(10) end
        netId = NetworkGetNetworkIdFromEntity(npc)
        netIds[#netIds+1] = netId
    end
    cb(netIds)
end)