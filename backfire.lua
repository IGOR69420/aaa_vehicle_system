local state = {}

function DoBackfire(vehicle, scale)
    TriggerServerEvent("aaa:syncBackfire", VehToNet(vehicle), scale)
end

CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then goto continue end

        local veh = GetVehiclePedIsIn(ped, false)
        local rpm = GetVehicleCurrentRpm(veh)
        local throttle = GetControlValue(0,71)
        local gear = GetVehicleCurrentGear(veh)

        if not state[veh] then
            state[veh] = {lastThrottle=0,lastGear=gear,lastFire=0}
        end

        local data = state[veh]
        local now = GetGameTimer()

        local tuning = Entity(veh).state.tuning or Config.DefaultTuning
        local classData = Config.VehicleClasses[GetVehicleClass(veh)] or {}

        local intensity = (tuning.turbo and 2 or 1) * (classData.backfire or 1.0)

        local throttleDrop = (data.lastThrottle - throttle) > 50
        local gearChange = (gear ~= data.lastGear)

        if rpm > Config.Backfire.minRPM and (throttleDrop or gearChange) then
            if now - data.lastFire > Config.Backfire.cooldown then
                if math.random() < Config.Backfire.chance then
                    DoBackfire(veh, intensity)
                    data.lastFire = now
                end
            end
        end

        data.lastThrottle = throttle
        data.lastGear = gear

        ::continue::
    end
end)