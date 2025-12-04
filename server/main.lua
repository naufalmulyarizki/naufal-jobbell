local Config = require 'shared.config'
local QBCore = exports['qb-core']:GetCoreObject()
local CooldownJob = {}

-----------------------------------------------------------------------------------------
-- CALLBACK --
-----------------------------------------------------------------------------------------

lib.callback.register('naufal-jobbell:server:sendnotifjob', function(source, job, callmessage, sound)
    local src = source
    local sekarang = os.time()

    if CooldownJob[job] and (sekarang - CooldownJob[job]) < Config.Cooldown then
        local remaining = Config.Cooldown - (sekarang - CooldownJob[job])
        local jobLabel = (QBCore.Shared?.Jobs[job]?.label or job)
        TriggerClientEvent('ox_lib:notify', src, { 
            title = 'Bell', 
            description = 'Panggilan sedang berlangsung, tunggu '..remaining..' detik lagi untuk bisa memanggil kembali',
            type = 'error'
        })    
        return false
    end

    CooldownJob[job] = sekarang

    local blipId = ('blip_%s_%s'):format(job, sekarang)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    TriggerClientEvent('ox_lib:notify', Player.PlayerData.source, { 
        title = 'Bell', 
        description = 'Panggilan berhasil terkirim!',
        type = 'info'
    })

    local Players = QBCore.Functions.GetQBPlayers()

    for _, v in pairs(Players) do
        if v and v.PlayerData.job.name == job and v.PlayerData.job.onduty then
            TriggerClientEvent('ox_lib:notify', v.PlayerData.source, { 
                title = 'Bell', 
                description = callmessage,
                type = 'info',
                duration = Config.NotifyDuration
            })   
            TriggerClientEvent('InteractSound_CL:PlayOnOne', v.PlayerData.source, sound, 0.4)
            TriggerClientEvent('naufal-jobbell:client:createBlip', v.PlayerData.source, {
                id = blipId,
                job = job,
                joblabel = QBCore.Shared?.Jobs[job]?.label
            })
            return true
        end
    end

    return false
end)