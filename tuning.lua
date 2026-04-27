RegisterCommand("tunemenu", function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    SetNuiFocus(true, true)

    SendNUIMessage({
        action = "open",
        tuning = Entity(veh).state.tuning or Config.DefaultTuning
    })
end)

RegisterNUICallback("applyTuning", function(data, cb)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)

    SetVehicleEnginePowerMultiplier(veh, (data.power - 1.0) * 50.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax", 2.5 * data.grip)

    Entity(veh).state:set("tuning", data, true)
    TriggerServerEvent("aaa:saveTuning", GetVehicleNumberPlateText(veh), data)

    cb("ok")
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)