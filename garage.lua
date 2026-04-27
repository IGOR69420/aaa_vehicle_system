RegisterCommand("garage", function()
    SetNuiFocus(true, true)
    TriggerServerEvent("aaa:getBuilds")
end)

RegisterNetEvent("aaa:receiveBuilds", function(builds)
    SendNUIMessage({action="garage", builds=builds})
end)

RegisterNUICallback("loadBuild", function(data, cb)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)

    SetVehicleEnginePowerMultiplier(veh,(data.tuning.power-1.0)*50)
    SetVehicleHandlingFloat(veh,"CHandlingData","fTractionCurveMax",2.5*data.tuning.grip)

    cb("ok")
end)