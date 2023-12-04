if GetResourceState('qb-core') ~= 'missing' then
	local UseQB = nil
	QBCore = exports['qb-core']:GetCoreObject()
    	UseQB = true
else
    ESX = exports["es_extended"]:getSharedObject()
end
RegisterNetEvent('zaps:checkjobb')
AddEventHandler('zaps:checkjobb', function(jobToCheck)
    local source = source
    if not UseQB then
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.job.name == jobToCheck then
        TriggerClientEvent('zaps:jobCheckResult', source, true)
    else
        TriggerClientEvent('zaps:jobCheckResult', source, false)
    end
else 
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer and xPlayer.PlayerData.job.name == jobToCheck then
        TriggerClientEvent('zaps:jobCheckResult', source, true)
    else
        TriggerClientEvent('zaps:jobCheckResult', source, false)
    end
end
end)
RegisterNetEvent('zaps:fraud:policeAlert')
AddEventHandler('zaps:fraud:policeAlert', function()
    local players = GetPlayers()
    if not UseQB then
    for i = 1, #players do
        local playerId = players[i]
local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job.name == 'police' then
            TriggerClientEvent('zaps:fraud:notifyClient', playerId, 'Fraud Alert!', 'Fraud alert! Respond to the location marked on map.', 'info')
            TriggerClientEvent('zaps:fraud:policeBlip')
        end
    end
else 
    for i = 1, #players do
        local playerId = players[i]
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer and xPlayer.PlayerData.job.name == 'police' then
        TriggerClientEvent('zaps:fraud:notifyClient', playerId, 'Fraud Alert!', 'Fraud alert! Respond to the location marked on map.', 'info')
        TriggerClientEvent('zaps:fraud:policeBlip')
        end
    end
end
end)
RegisterNetEvent('zaps:fraud:giveitem')
AddEventHandler('zaps:fraud:giveitem', function(cost, itemName, count)
    if UseQB then return  end 
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
if UseQB then
    RegisterNetEvent('zaps:fraud:giveitem')
    AddEventHandler('zaps:fraud:giveitem', function(cost, itemName, count)
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
    end
if not UseQB then
RegisterNetEvent('zaps:check:cashcheck')
AddEventHandler('zaps:check:cashcheck', function()
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
if UseQB then 
    RegisterNetEvent('zaps:check:cashcheck')
    AddEventHandler('zaps:check:cashcheck', function()
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
end
if not UseQB then
ESX.RegisterUsableItem(Config.ScamItems[1].itemName, function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem(Config.ScamItems[1].itemName, 1)
    xPlayer.showNotification('You used ' .. Config.ScamItems[1])
        TriggerClientEvent('zaps:fraud:placelaptop', playerId)
end)
end

if UseQB then 
    QBCore.Functions.CreateUseableItem(Config.ScamItems[1].itemName, function(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            xPlayer.removeInventoryItem(Config.ScamItems[1].itemName, 1)
            xPlayer.showNotification('You used ' .. Config.ScamItems[1].itemName)
            TriggerClientEvent('zaps:fraud:placelaptop')
        end
    end)
end
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
