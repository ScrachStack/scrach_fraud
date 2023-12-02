if GetResourceState('qb-core') ~= 'missing' then
	QBCore = exports['qb-core']:GetCoreObject()
    
    for i = 1, #Config.ScamItems do 
        local Item = Config.ScamItems[i]
        QBCore.Functions.CreateUseableItem(Item.itemName, function(source)
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if xPlayer then
                xPlayer.removeInventoryItem(Item.itemName, 1)
                xPlayer.showNotification('You used ' .. Item.itemName)
                TriggerClientEvent('zaps:fraud:placelaptop', xPlayer.source)
            end
        end)
    end
    
    RegisterNetEvent('zaps:fraud:giveitem', function(cost, itemName, count)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if cost <= 0 then
            DropPlayer(source, "[Zaps_Fraud]: Cheater Using Invalid Inputs on event 'zaps:giveitem'")
            return
        end
        if xPlayer.getMoney() >= cost then
            xPlayer.removeMoney(cost)
            xPlayer.addItem(itemName, count)
        end
    end)

    RegisterNetEvent('zaps:check:cashcheck', function()
        local source = source
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local hasForgedCheck = xPlayer.getInventoryItem(Config.ScamItems[3].itemName).count > 0
            if hasForgedCheck then
                local success = math.random() <= 0.9 
                local dirtyMoneyAmount = 500
                if success then
                    xPlayer.addAccountMoney('black_money', dirtyMoneyAmount)
                    xPlayer.removeInventoryItem(Config.ScamItems[3].itemName, 1)
                    TriggerClientEvent('zaps:fraud:notifyClient', source, 'Cash Checking', 'Cash check successful! You received $' .. dirtyMoneyAmount .. ' dirty money.', 'success')
                else
                    TriggerClientEvent('zaps:fraud:notifyClient', source, 'Cash Checking', 'Cash check failed! Police have been alerted.', 'error')
                    TriggerEvent('zaps:policeAlert', source)
                end
            else
                TriggerClientEvent('zaps:fraud:notifyClient', source, 'Cash Checking', 'You don\'t have a forged check to cash.', 'error')
            end
        end
    end)  
else
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('zaps:fraud:giveitem', function(cost, itemName, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        if cost <= 0 then
            DropPlayer(source, "[Zaps_Fraud]: Cheater Using Invalid Inputs on event 'zaps:giveitem'")
            return
        end
        if xPlayer.getMoney() >= cost then
            xPlayer.removeMoney(cost)
            xPlayer.addInventoryItem(itemName, count)
        end
    end)

    for i = 1, #Config.ScamItems do 
        local Item = Config.ScamItems[i]
        ESX.RegisterUsableItem(Item.itemName, function(playerId)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            xPlayer.removeInventoryItem(Item.itemName, 1)
            xPlayer.showNotification('You used ' .. Item)
            TriggerClientEvent('zaps:fraud:placelaptop', playerId)
        end)
    end

    RegisterNetEvent('zaps:check:cashcheck', function()
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local hasForgedCheck = xPlayer.getInventoryItem(Config.ScamItems[3].itemName).count > 0
            if hasForgedCheck then
                local success = math.random() <= 0.9 -- 80% success chance adjust as needed
                if success then
                    local dirtyMoneyAmount = 10000 
                    xPlayer.addAccountMoney('black_money', dirtyMoneyAmount)
                    xPlayer.removeInventoryItem(Config.ScamItems[3].itemName, 1)
                    TriggerClientEvent('zaps:fraud:notifyClient', source, 'Cash Checking', 'Cash check successful! You received $' .. dirtyMoneyAmount .. ' dirty money.', 'success')
                else
                    TriggerClientEvent('zaps:fraud:notifyClient', source, 'Cash Checking', 'Cash check successful! You received $' .. dirtyMoneyAmount .. ' dirty money.', 'success')
                    TriggerEvent('zaps:policeAlert', source) 
                end
            else
                TriggerClientEvent('zaps:fraud:notifyClient', source, 'Cash Checking', 'You don\'t have a forged check to cash.', 'success')
            end
        end
    end)
end

RegisterNetEvent('zaps:checkjobb', function(jobToCheck)
    local source = source
    local xPlayer = not QBCore and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('zaps:jobCheckResult', source, xPlayer and (not QBCore and xPlayer.job.name) or (QBCore and xPlayer.PlayerData.job.name) == jobToCheck)
end)

RegisterNetEvent('zaps:fraud:policeAlert', function()
    if not QBCore then
        local players = ESX.GetExtendedPlayers('job', 'police')
        for i = 1, #players do
            local xPlayer = players[i]
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('zaps:fraud:notifyClient', xPlayer.source, 'Fraud Alert!', 'Fraud alert! Respond to the location marked on map.', 'info')
                TriggerClientEvent('zaps:fraud:policeBlip', xPlayer.source)
            end
        end
    else 
        local players = QBCore.Functions.GetQBPlayers()
        for source, xPlayer in pairs(players) do 
            if xPlayer.PlayerData.job.name == 'police' then
                TriggerClientEvent('zaps:fraud:notifyClient', source, 'Fraud Alert!', 'Fraud alert! Respond to the location marked on map.', 'info')
                TriggerClientEvent('zaps:fraud:policeBlip', source)
            end
        end
    end
end)

function zapsupdatee()
    local githubRawUrl = "https://raw.githubusercontent.com/Zaps6000/base/main/api.json"
    local resourceName = "fraud" 
    
    PerformHttpRequest(githubRawUrl, function(statusCode, responseText, headers)
        if statusCode == 200 then
            local responseData = json.decode(responseText)
    
            if responseData[resourceName] then
                local remoteVersion = responseData[resourceName].version
                local description = responseData[resourceName].description
                local changelog = responseData[resourceName].changelog
    
                local manifestVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    
                print("Resource: " .. resourceName)
                print("Manifest Version: " .. manifestVersion)
                print("Remote Version: " .. remoteVersion)
                print("Description: " .. description)
    
                if manifestVersion ~= remoteVersion then
                    print("Status: Out of Date (New Version: " .. remoteVersion .. ")")
                    print("Changelog:")
                    for _, change in ipairs(changelog) do
                        print("- " .. change)
                    end
                    print("Link to Updates: https://discord.gg/cfxdev")
                else
                    print("Status: Up to Date")
                end
            else
                print("Resource name not found in the response.")
            end
        else
            print("HTTP request failed with status code: " .. statusCode)
        end
    end, "GET", nil, json.encode({}), {})
    end
    onstart = function()
        zapsupdatee()
        print([[^3
        ·▄▄▄▄• ▄▄▄·  ▄▄▄·.▄▄ ·     ·▄▄▄▄▄▄   ▄▄▄· ▄• ▄▌·▄▄▄▄  
        ▪▀·.█▌▐█ ▀█ ▐█ ▄█▐█ ▀.     ▐▄▄·▀▄ █·▐█ ▀█ █▪██▌██▪ ██ 
        ▄█▀▀▀•▄█▀▀█  ██▀·▄▀▀▀█▄    ██▪ ▐▀▀▄ ▄█▀▀█ █▌▐█▌▐█· ▐█▌
        █▌▪▄█▀▐█ ▪▐▌▐█▪·•▐█▄▪▐█    ██▌.▐█•█▌▐█ ▪▐▌▐█▄█▌██. ██ 
        ·▀▀▀ • ▀  ▀ .▀    ▀▀▀▀     ▀▀▀ .▀  ▀ ▀  ▀  ▀▀▀ ▀▀▀▀▀•    
        ]])
    end
    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            if resource == 'zaps_fraud' then
            onstart()
            else 
                print("[Zaps Fraud]: Change Resource Name to Zaps_Fraud")
        end
    end
    end)
