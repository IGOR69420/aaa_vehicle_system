local smokeParticles = {}

local function loadParticle(dict)
    if not HasNamedPtfxAssetLoaded(dict) then
        RequestNamedPtfxAsset(dict)
        while not HasNamedPtfxAssetLoaded(dict) do
            Wait(0)
        end
    end
    UseParticleFxAssetNextCall(dict)
end

local function startSmoke(vehicle, intensity)
    local bone = GetEntityBoneIndexByName(vehicle, "wheel_lf")

    loadParticle("core")

    UseParticleFxAssetNextCall("core")

    StartParticleFxNonLoopedOnEntity(
        "veh_backfire", -- fallback safe particle
        vehicle,
        0.0, -0.2, 0.0,
        0.0, 0.0, 0.0,
        intensity,
        false, false, false
    )
end

CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then goto continue end

        local veh = GetVehiclePedIsIn(ped, false)
        local speed = GetEntitySpeed(veh) * 3.6

        local vx, vy, vz = table.unpack(GetEntityVelocity(veh))
        local driftAngle = math.abs(vy * 3.6)

        local tuning = Entity(veh).state.tuning or Config.DefaultTuning
        local gripFactor = tuning.grip or 1.0

        local slip = driftAngle * (speed / 100)

        -- ONLY smoke when actually sliding
        if speed > 20 and slip > 5 then

            local intensity = math.min(1.5, slip / 20)

            -- reduce smoke if high grip
            intensity = intensity * (2.0 - gripFactor)

            if math.random() < 0.6 then
                startSmoke(veh, intensity)
            end
        end

        ::continue::
    end
end)