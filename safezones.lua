local safezones = {
    { x = 20.0, y = -1105.0, z = 29.8, radius = 50.0 }, -- Ammu-Nation 1 (centrum, Downtown Vinewood)
    { x = 842.4, y = -1035.4, z = 28.2, radius = 50.0 }, -- Ammu-Nation 2 (centraal, Mirror Park)
    { x = -662.1, y = -933.6, z = 21.8, radius = 50.0 }, -- Ammu-Nation 3 (centrum, Little Seoul)
    { x = 252.3, y = -50.0, z = 69.9, radius = 50.0 }, -- Ammu-Nation 4 (centraal, Vinewood Hills)
    { x = -1117.5, y = 2698.6, z = 18.5, radius = 50.0 }, -- Ammu-Nation 5 (oost, Palomino Highlands)
    { x = 1692.6, y = 3759.6, z = 34.7, radius = 50.0 }, -- Ammu-Nation 6 (noord, Sandy Shores)
    { x = -330.2, y = 6083.8, z = 31.4, radius = 50.0 }, -- Ammu-Nation 7 (noord, Paleto Bay)
    { x = 2567.6, y = 294.3, z = 108.7, radius = 50.0 }, -- Ammu-Nation 8 (oost, Grapeseed)
    { x = -3172.6, y = 1087.3, z = 20.8, radius = 50.0 }, -- Ammu-Nation 9 (west, Chumash)
    { x = 812.1, y = -2159.4, z = 29.6, radius = 50.0 }, -- Ammu-Nation 10 (zuid, Rancho)

    { x = 119.0, y = -1936.0, z = 21.0, radius = 100.0 }, -- Grove Street

    { x = 425.1, y = -979.5, z = 30.7, radius = 50.0 }, -- Politiebureau 1 (Mission Row)
    { x = -449.8, y = 6011.2, z = 31.7, radius = 50.0 }, -- Politiebureau 2 (Paleto Bay)
    { x = 1851.3, y = 3686.7, z = 34.3, radius = 50.0 }, -- Politiebureau 3 (Sandy Shores)
    { x = -1096.2, y = -826.4, z = 19.0, radius = 50.0 }, -- Politiebureau 4 (Vespucci Canals)
    { x = 369.8, y = -1597.1, z = 29.3, radius = 50.0 }, -- Politiebureau 5 (La Mesa)
    { x = -560.0, y = -132.4, z = 38.0, radius = 50.0 }, -- Politiebureau 6 (Rockford Hills)
}

local isInSafezone = false


Citizen.CreateThread(function()
    for _, zone in ipairs(safezones) do
        
        local blip = AddBlipForCoord(zone.x, zone.y, zone.z)
        SetBlipSprite(blip, 1) 
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 2) 
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Safezone")
        EndTextCommandSetBlipName(blip)

        
        local circle = AddBlipForRadius(zone.x, zone.y, zone.z, zone.radius)
        SetBlipColour(circle, 2) 
        SetBlipAlpha(circle, 128) 
    end
end)


Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local inAnySafezone = false
        
        for _, zone in ipairs(safezones) do
            local distance = #(playerCoords - vector3(zone.x, zone.y, zone.z))
            if distance < zone.radius then
                if not isInSafezone then
                    
                    isInSafezone = true
                    DisplaySafezoneMessage(true)
                end
                inAnySafezone = true
                break 
            end
        end

        if not inAnySafezone and isInSafezone then
            
            isInSafezone = false
            DisplaySafezoneMessage(false)
        end
        
        Citizen.Wait(1000) 
    end
end)


function DisplaySafezoneMessage(entering)
    local message = entering and "~g~Je bent in een Safezone" or "~r~Je hebt de Safezone verlaten"
    
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end