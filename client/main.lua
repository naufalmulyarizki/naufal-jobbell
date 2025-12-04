local Config = require 'shared.config'
local activeBlips = {}

-----------------------------------------------------------------------------------------
-- FUNCTION --
-----------------------------------------------------------------------------------------

local function CleanupBlip(blipId)
    if activeBlips[blipId] then
        if DoesBlipExist(activeBlips[blipId].handle) then
            RemoveBlip(activeBlips[blipId].handle)
        end
        activeBlips[blipId] = nil
    end
end

-----------------------------------------------------------------------------------------
-- EVENTS --
-----------------------------------------------------------------------------------------

RegisterNetEvent('naufal-jobbell:client:createBlip', function(data)
    local blipId = data.id
    local job = data.job
    local joblabel = data.joblabel
    local coords = GetEntityCoords(cache.ped)
    
    CleanupBlip(blipId)

    local blipCoords = vector3(coords.x, coords.y, coords.z)
    local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
    SetBlipSprite(blip, 280)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Panggilan - " .. (joblabel or "Unknown"))
    EndTextCommandSetBlipName(blip)
    SetBlipFlashes(blip, true)
    
    activeBlips[blipId] = { handle = blip }
    
    SetTimeout(30000, function()
        CleanupBlip(blipId)
    end)
end)

RegisterNetEvent('naufal-jobbell:client:removeBlip', function(blipId)
    CleanupBlip(blipId)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for blipId, _ in pairs(activeBlips) do
            CleanupBlip(blipId)
        end
    end
end)

-----------------------------------------------------------------------------------------
-- THREADS --
-----------------------------------------------------------------------------------------

CreateThread(function()
    for k,v in ipairs(Config.Location['JobBell']) do
        if v.useped then

            local pedModel = v.pedModel -- Model Ped
            local coords = v.coords  -- Coords Ped

            -- Request Model
            RequestModel(pedModel)
            while not HasModelLoaded(pedModel) do
                Wait(500)
            end

            -- Membuat Ped
            local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z, -140.0, false, true)
            SetEntityInvincible(ped, true) -- Membuat Ped Menjadi Kebal
            SetEntityVisible(ped, true, false) -- Membuat Ped Bisa Dilihat
            FreezeEntityPosition(ped, true) -- Membuat Ped Menjadi Kaku

            -- Membuat Target Entity Ped
            exports.ox_target:addLocalEntity(ped, {
                {
                    icon = v.icon, -- Icon Target
                    label = v.label, -- Label Target
                    distance = v.radius, -- Distance Target
                    onSelect = function() -- Ketika Di Trigger pada target
                        local success = lib.callback.await('naufal-jobbell:server:sendnotifjob', false, v.job, v.callmessage, v.sound)
                        if success then
                            -- trigger sukses
                        end
                    end
                },
            })
        else
            -- Membuat Circle Zone
            exports.ox_target:addSphereZone({
                name = "jobbell" .. k, -- Name Target
                radius = v.radius, -- Radius Target
                coords = v.coords, -- Coords Target
                debug = v.debug, -- Debug Target
                rotation = v.rotation, -- Rotation Target
                options = {
                    {
                        icon = v.icon,  -- Icon Target
                        label = v.label, -- Label Target
                        onSelect = function() -- Ketika Di Trigger pada target
                            local success = lib.callback.await('naufal-jobbell:server:sendnotifjob', false, v.job, v.callmessage, v.sound)
                            if success then
                                -- trigger sukses
                            end
                        end
                    },
                },
            })
        end
    end
end)