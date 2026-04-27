CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then goto continue end

        local veh = GetVehiclePedIsIn(ped, false)
        local class = GetVehicleClass(veh)
        local classData = Config.VehicleClasses[class] or {}

        if classData.drift and exports['aaa_vehicle_system']:isDriftEnabled() then
            SetVehicleReduceGrip(veh, true)
        else
            SetVehicleReduceGrip(veh, false)
        end

        ::continue::
    end
end)