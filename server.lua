local leaderboard = {}
local garage = {}

RegisterNetEvent("aaa:syncBackfire", function(netId, scale)
    TriggerClientEvent("aaa:playBackfire", -1, netId, scale)
end)

RegisterNetEvent("aaa:saveTuning", function(plate, tuning)
    exports.oxmysql:execute(
        "REPLACE INTO vehicle_tuning (plate, power, grip, turbo) VALUES (?, ?, ?, ?)",
        {plate, tuning.power, tuning.grip, tuning.turbo}
    )
end)

RegisterNetEvent("aaa:requestTuning", function(plate)
    local src = source
    exports.oxmysql:execute("SELECT * FROM vehicle_tuning WHERE plate = ?", {plate}, function(result)
        if result[1] then
            TriggerClientEvent("aaa:applySavedTuning", src, result[1])
        end
    end)
end)

RegisterNetEvent("aaa:saveScore", function(score)
    local src = source
    leaderboard[src] = {name = GetPlayerName(src), score = score}
end)

RegisterNetEvent("aaa:getLeaderboard", function()
    local src = source
    local list = {}

    for _,v in pairs(leaderboard) do
        table.insert(list, v)
    end

    table.sort(list, function(a,b) return a.score > b.score end)

    TriggerClientEvent("aaa:showLeaderboard", src, list)
end)

RegisterNetEvent("aaa:saveBuild", function(name, tuning)
    local src = source
    garage[src] = garage[src] or {}
    table.insert(garage[src], {name=name, tuning=tuning})
end)

RegisterNetEvent("aaa:getBuilds", function()
    local src = source
    TriggerClientEvent("aaa:receiveBuilds", src, garage[src] or {})
end)