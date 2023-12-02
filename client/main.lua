RegisterNetEvent("zaps:jobCheckResult")
AddEventHandler(
    "zaps:jobCheckResult",
    function(result)
        if result then
            CanScam = true
        else
            CanScam = false
        end
    end
)

local createmenu = function()
    local menuOptions = {}

    for i = 1, #Config.BlackMarketLocations do
        local location = Config.BlackMarketLocations[i]

        for j = 1, #location.items do
            local item = location.items[j]

            local button = {
                title = item.itemName,
                description = "Price: $" .. item.price,
                onSelect = function()
                    TriggerServerEvent("zaps:fraud:giveitem", item.price, item.itemName, 1)
                end,
                icon = "circle",
                metadata = {
                    {label = "Item Name", value = item.itemName},
                    {label = "Price", value = item.price}
                }
            }

            table.insert(menuOptions, button)
        end
    end

    lib.registerContext(
        {
            id = "zaps_fraud_1",
            title = "Black Market",
            options = menuOptions
        }
    )
end

local emarket = function()
    local menuOptions = {}

    for i = 1, #Config.ElectronicStoreLocations do
        local location = Config.ElectronicStoreLocations[i]

        for j = 1, #location.items do
            local item = location.items[j]

            local button = {
                title = item.itemName,
                description = "Price: $" .. item.price,
                onSelect = function()
                    TriggerServerEvent("zaps:fraud:giveitem", item.price, item.itemName, 1)
                end,
                icon = "circle",
                metadata = {
                    {label = "Item Name", value = item.itemName},
                    {label = "Price", value = item.price}
                }
            }

            table.insert(menuOptions, button)
        end
    end

    lib.registerContext(
        {
            id = "zaps_fraud_2",
            title = "Electronic Market",
            options = menuOptions
        }
    )
end

for i = 1, #Config.BlackMarketLocations do
    local location = Config.BlackMarketLocations[i]
    local blackmarket =
        lib.points.new(
        {
            coords = vector3(location.x, location.y, location.z),
            distance = 5
        }
    )
    function blackmarket:onEnter()
        lib.hideTextUI()
        Wait(100)
        lib.showTextUI("[E] - Open Blackmarket")
    end

    function blackmarket:onExit()
        lib.hideTextUI()
    end

    function blackmarket:nearby()
        DrawMarker(
            2,
            self.coords.x,
            self.coords.y,
            self.coords.z,
            0.0,
            0.0,
            0.0,
            0.0,
            180.0,
            0.0,
            1.0,
            1.0,
            1.0,
            200,
            20,
            20,
            50,
            false,
            true,
            2,
            false,
            nil,
            nil,
            false
        )
        if IsControlJustReleased(0, 38) then
            createmenu()
            lib.showContext("zaps_fraud_1")
        end
    end
end

for i = 1, #Config.ElectronicStoreLocations do
    local location = Config.ElectronicStoreLocations[i]
    local estore =
        lib.points.new(
        {
            coords = vector3(location.x, location.y, location.z),
            distance = 5
        }
    )

    function estore:onEnter()
        lib.hideTextUI()
        Wait(100)
        lib.showTextUI("[E] - Open Electronic Store")
    end

    function estore:onExit()
        lib.hideTextUI()
    end

    function estore:nearby()
        DrawMarker(
            3,
            self.coords.x,
            self.coords.y,
            self.coords.z,
            0.0,
            0.0,
            0.0,
            0.0,
            180.0,
            0.0,
            1.0,
            1.0,
            1.0,
            200,
            20,
            20,
            50,
            false,
            true,
            2,
            false,
            nil,
            nil,
            false
        )
        if IsControlJustReleased(0, 38) then
            emarket()
            lib.showContext("zaps_fraud_2")
        end
    end
end

local placingLaptop = false
local initialLaptopPosition = nil
local initialLaptopHeading = 0.0
local laptopObject = nil
RegisterNetEvent("zaps:fraud:placelaptop")
AddEventHandler(
    "zaps:fraud:placelaptop",
    function()
        TriggerServerEvent("zaps:checkjobb", Config.JobRequirement)
        if not CanScam then
            return
        end
        placingLaptop = not placingLaptop
        lib.showTextUI("Press [Arrow Keys] to move the laptop. Press [E] to confirm placement.")
        if placingLaptop then
            local playerCoords = GetEntityCoords(cache.ped)
            initialLaptopPosition = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            laptopObject =
                CreateObject(
                GetHashKey("prop_laptop_01a"),
                initialLaptopPosition.x - 1,
                initialLaptopPosition.y,
                initialLaptopPosition.z,
                true,
                true,
                true
            )
            initialLaptopHeading = GetEntityHeading(laptopObject)
        end
    end
)
local canPressE = true

CreateThread(
    function()
        while true do
            Citizen.Wait(10)
            if placingLaptop then
                local speed = 0.1
                local playerCoords = GetEntityCoords(cache.ped)
                if IsControlPressed(0, 172) then
                    SetEntityCoordsNoOffset(
                        laptopObject,
                        playerCoords.x + 0.5,
                        playerCoords.y + speed,
                        playerCoords.z,
                        true,
                        true,
                        true
                    )
                    SetEntityHeading(laptopObject, 0.6)
                elseif IsControlPressed(0, 173) then
                    SetEntityCoordsNoOffset(
                        laptopObject,
                        playerCoords.x + 0.5,
                        playerCoords.y - speed,
                        playerCoords.z,
                        true,
                        true,
                        true
                    )
                    SetEntityHeading(laptopObject, 0.0)
                elseif IsControlPressed(0, 174) then
                    SetEntityCoordsNoOffset(
                        laptopObject,
                        playerCoords.x - speed,
                        playerCoords.y,
                        playerCoords.z,
                        true,
                        true,
                        true
                    )
                    SetEntityHeading(laptopObject, 0.0)
                elseif IsControlPressed(0, 175) then
                    SetEntityCoordsNoOffset(
                        laptopObject,
                        playerCoords.x + speed,
                        playerCoords.y,
                        playerCoords.z,
                        true,
                        true,
                        true
                    )
                    SetEntityHeading(laptopObject, 0.0)
                end
                if IsControlJustReleased(0, 38) then
                    placingLaptop = false
                    FreezeEntityPosition(laptopObject, true)
                    laptopObject = nil
                    initialLaptopPosition = nil
                    initialLaptopHeading = 0.0
                    SetEntityHeading(laptopObject, 1.15)
                    lib.hideTextUI()
                    Wait(100)
                    lib.showTextUI("Press [E] To Open Laptop.")
                    UsingLaptop = true
                end
            end
            if UsingLaptop and canPressE then
                if IsControlJustReleased(0, 38) then
                    lib.hideTextUI()
                    Wait(100)
                    lib.showTextUI("Press [G] - Pickup Laptop")
                    if Config.LaptopFeatures.LibSkillCheck then
                        local success = lib.skillCheck({"easy", "easy", {areaSize = 600}, "easy"}, {"w", "a", "s", "d"})
                        if success then
                            TriggerServerEvent("zaps:fraud:giveitem", 1, "forgedcheck", 1)
                            canPressE = false
                        end
                    end
                    if Config.LaptopFeatures.cd_keymaster then
                        local win = exports["cd_keymaster"]:StartKeyMaster()
                        if win then
                            TriggerServerEvent("zaps:fraud:giveitem", 1, "forgedcheck", 1)
                            canPressE = false
                        else
                        end
                    end
                    if Config.LaptopFeatures.Glow_minigamesPathMiniGame then
                        exports["glow_minigames"]:StartMinigame(
                            function(success)
                                if success then
                                    TriggerServerEvent("zaps:fraud:giveitem", 1, "forgedcheck", 1)
                                    canPressE = false
                                else
                                    print("lose")
                                end
                            end,
                            "path"
                        )
                    end
                end
            end
            if IsControlJustReleased(0, 38) and UsingLaptop then
                canPressE = true
                print(canPressE)
            end
            if IsControlJustReleased(0, 47) and UsingLaptop then
                DestroyLaptopObject()
            end
        end
    end
)
for i = 1, #Config.CashCheckingLocations do
    local location = Config.CashCheckingLocations[i]
    local cashsergiocheck =
        lib.points.new(
        {
            coords = vector3(location.x, location.y, location.z),
            distance = 5
        }
    )

    function cashsergiocheck:onEnter()
        lib.hideTextUI()
        Wait(100)
        lib.showTextUI("[E] - Cash Forged Check")
    end

    function cashsergiocheck:onExit()
        lib.hideTextUI()
    end

    function cashsergiocheck:nearby()
        DrawMarker(
            2,
            self.coords.x,
            self.coords.y,
            self.coords.z,
            0.0,
            0.0,
            0.0,
            0.0,
            180.0,
            0.0,
            1.0,
            1.0,
            1.0,
            200,
            20,
            20,
            50,
            false,
            true,
            2,
            false,
            nil,
            nil,
            false
        )
        if IsControlJustReleased(0, 38) then
            local success = lib.skillCheck({"easy", "easy", {areaSize = 60}, "easy"}, {"w", "a", "s", "d"})
            if success then
                lib.notify(
                    {
                        title = "Fraud",
                        description = "Aruguing with Worker about the check being fake...",
                        type = "info"
                    }
                )
                if
                    lib.progressCircle(
                        {
                            duration = 4000,
                            position = "bottom",
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true
                            }
                        }
                    )
                 then
                    TriggerServerEvent("zaps:check:cashcheck")
                end
            else
                TriggerServerEvent("zaps:fraud:policeAlert")
            end
        end
    end
end

function DestroyLaptopObject()
    if not UsingLaptop then
        return
    end
    local x, y, z = table.unpack(GetEntityCoords(cache.ped))
    local LaptopObj = GetClosestObjectOfType(x, y, z, 1.5, GetHashKey("prop_laptop_01a"), false, false, false)
    canPressE = false
    UsingLaptop = false
    SetEntityAsMissionEntity(LaptopObj, true, true)
    DeleteEntity(LaptopObj)
    lib.hideTextUI()
end
RegisterNetEvent("zaps:fraud:notifyClient")
AddEventHandler(
    "zaps:fraud:notifyClient",
    function(title, description, type)
        lib.notify(
            {
                title = title or "Notification title",
                description = description or "Notification description",
                type = type or "success"
            }
        )
    end
)
RegisterNetEvent("zaps:fraud:policeBlip")
AddEventHandler(
    "zaps:fraud:policeBlip",
    function(location)
        local x, y, z = table.unpack(GetEntityCoords(cache.ped))
        SetNewWaypoint(x, y)
        Wait(60 * 1000)
        ClearGpsPlayerWaypoint()
    end
)
