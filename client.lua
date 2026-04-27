local driftEnabled = false
local alsEnabled = false

RegisterKeyMapping('toggleDrift', 'Toggle Drift Mode', 'keyboard', 'LSHIFT')
RegisterKeyMapping('toggleALS', 'Toggle Anti-Lag', 'keyboard', 'B')

RegisterCommand('toggleDrift', function()
    driftEnabled = not driftEnabled
end)

RegisterCommand('toggleALS', function()
    alsEnabled = not alsEnabled
end)

exports('isDriftEnabled', function() return driftEnabled end)
exports('isALS', function() return alsEnabled end)

-- Load tuning
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            TriggerServerEvent("aaa:requestTuning", GetVehicleNumberPlateText(veh))
        end
    end
end)

RegisterNetEvent("aaa:applySavedTuning", function(tuning)
    if not tuning then return end
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)

    SetVehicleEnginePowerMultiplier(veh, (tuning.power - 1.0) * 50.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax", 2.5 * tuning.grip)

    Entity(veh).state:set("tuning", tuning, true)
end)

-- Backfire sync
RegisterNetEvent("aaa:playBackfire", function(netId, scale)
    local veh = NetToVeh(netId)

    UseParticleFxAssetNextCall("core")
    StartParticleFxNonLoopedOnEntity("veh_backfire", veh, 0.0,-2.0,0.2,0.0,0.0,0.0, scale, false,false,false)
end)

-- Leaderboard UI
RegisterCommand("leaderboard", function()
    SetNuiFocus(true, true)
    TriggerServerEvent("aaa:getLeaderboard")
end)

RegisterNetEvent("aaa:showLeaderboard", function(data)
    SendNUIMessage({action = "leaderboard", data = data})
end)