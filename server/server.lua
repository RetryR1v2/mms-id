-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-id/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end
local VORPcore = exports.vorp_core:GetCore()


exports.vorp_inventory:registerUsableItem('idcard', function(data)
    local src = data.source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    MySQL.query('SELECT * FROM `mms_id` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            local firstname = result[1].firstname
            local lastname = result[1].lastname
            local nickname = result[1].nickname
            local job = result[1].job
            local age = result[1].age
            local gender = result[1].gender
            local date = result[1].date
            local picture = result[1].picture
            Citizen.Wait(500)
            TriggerClientEvent('mms-id:client:openid',src,firstname,lastname,nickname,job,age,gender,date,picture)
        end
    end)
end)

exports.vorp_inventory:registerUsableItem('jagtlizenz', function(data)
    local src = data.source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            local firstname = result[1].firstname
            local lastname = result[1].lastname
            local age = result[1].age
            local date = result[1].date
            local picture = result[1].picture
            local days = result[1].days
            Citizen.Wait(500)
            TriggerClientEvent('mms-id:client:openhuntingid',src,firstname,lastname,age,date,picture,days)
        end
    end)
end)
--https://i.postimg.cc/GmVktCg9/bild.png https://i.postimg.cc/FHJTD709/ausweisbild.png
RegisterServerEvent('mms-id:server:createid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    local firstname = Character.firstname
    local lastname = Character.lastname
    local nickname = Character.nickname
    local job = Character.jobLabel
    local age = Character.age
    local gender = Character.gender
    local year = os.date('%Y')
    local month = os.date('%m')
    local day = os.date('%d')
    local hour = os.date('%H')
    local min = os.date('%M')
    local date = day ..':'..  month .. ':' .. year .. _U('AT') .. hour .. ':' ..min.. _U('Clock')
    local picture = 'https://i.postimg.cc/7hT8KpcW/nophoto.jpg'
    MySQL.query('SELECT * FROM `mms_id` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            VORPcore.NotifyTip(src, _U('AlreadyGotID'), 5000)
        else
            if Money >= Config.AusweisVerlorenPreis then
            local cancarry = exports.vorp_inventory:canCarryItems(src, 1, nil)
            local cancarryitem = exports.vorp_inventory:canCarryItem(src, 'idcard', 1, nil)
                if cancarry and cancarryitem then
                    MySQL.insert('INSERT INTO `mms_id` (identifier,charidentifier,firstname,lastname,nickname,job,age,gender,date,picture) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                    {identifier,charidentifier,firstname,lastname,nickname,job,age,gender,date,picture}, function()end)
                    Character.removeCurrency(0,Config.AusweisPreis)
                    VORPcore.NotifyTip(src, _U('BoughtID').. Config.AusweisPreis ..'$', 5000)
                    exports.vorp_inventory:addItem(src, 'idcard', 1,nil,nil)
                else
                    VORPcore.NotifyTip(src, _U('PocketFull'), 5000)
                end
            else
                VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
            end
        end
    end)
end)

RegisterServerEvent('mms-id:server:updateownid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    local firstname = Character.firstname
    local lastname = Character.lastname
    local nickname = Character.nickname
    local job = Character.jobLabel
    MySQL.query('SELECT * FROM `mms_id` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            if Money >= Config.UpdateIdPrice then
                MySQL.update('UPDATE `mms_id` SET firstname = ? WHERE charidentifier = ?',{firstname, charidentifier})
                MySQL.update('UPDATE `mms_id` SET lastname = ? WHERE charidentifier = ?',{lastname, charidentifier})
                MySQL.update('UPDATE `mms_id` SET nickname = ? WHERE charidentifier = ?',{nickname, charidentifier})
                MySQL.update('UPDATE `mms_id` SET job = ? WHERE charidentifier = ?',{job, charidentifier})
                Character.removeCurrency(0,Config.UpdateIdPrice)
                VORPcore.NotifyTip(src, _U('UpdatedID').. Config.UpdateIdPrice ..'$', 5000)
            else
                VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
            end
        else
            VORPcore.NotifyTip(src, _U('HaveNoID'), 5000)
        end
    end)
end)

RegisterServerEvent('mms-id:server:createhuntingid',function (days)
    local calculatedays = tonumber(days)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    local firstname = Character.firstname
    local lastname = Character.lastname
    local age = Character.age
    local year = os.date('%Y')
    local month = os.date('%m')
    local day = os.date('%d')
    local hour = os.date('%H')
    local min = os.date('%M')
    local date = day ..':'..  month .. ':' .. year .. _U('AT') .. hour .. ':' ..min.. _U('Clock')
    local picture = Config.HuntingIdPicture
    MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            VORPcore.NotifyTip(src, _U('AlreadyGotHuntingLicense'), 5000)
        else
            if Money >= Config.HuntingLicensePrice * calculatedays then
            local cancarry = exports.vorp_inventory:canCarryItems(src, 1, nil)
            local cancarryitem = exports.vorp_inventory:canCarryItem(src, 'jagtlizenz', 1, nil)
                if cancarry and cancarryitem then
                    MySQL.insert('INSERT INTO `mms_huntingid` (identifier,charidentifier,firstname,lastname,age,date,picture,days) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                    {identifier,charidentifier,firstname,lastname,age,date,picture,days}, function()end)
                    Character.removeCurrency(0,Config.HuntingLicensePrice * calculatedays)
                    VORPcore.NotifyTip(src, _U('BoughtHuntingID').. Config.HuntingLicensePrice * calculatedays ..'$', 5000)
                    exports.vorp_inventory:addItem(src, 'jagtlizenz', 1,nil,nil)
                else
                    VORPcore.NotifyTip(src, _U('PocketFull'), 5000)
                end
            else
                VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
            end
        end
    end)
end)

RegisterServerEvent('mms-id:server:createmyownhuntingid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local age = Character.age
    local year = os.date('%Y')
    local month = os.date('%m')
    local day = os.date('%d')
    local hour = os.date('%H')
    local min = os.date('%M')
    local date = day ..':'..  month .. ':' .. year .. _U('AT') .. hour .. ':' ..min.. _U('Clock')
    local picture = Config.HuntingIdPicture
    local days = 9999
    MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            VORPcore.NotifyTip(src, _U('AlreadyGotHuntingLicense'), 5000)
        else
            local cancarry = exports.vorp_inventory:canCarryItems(src, 1, nil)
            local cancarryitem = exports.vorp_inventory:canCarryItem(src, 'jagtlizenz', 1, nil)
                if cancarry and cancarryitem then
                    MySQL.insert('INSERT INTO `mms_huntingid` (identifier,charidentifier,firstname,lastname,age,date,picture,days) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                    {identifier,charidentifier,firstname,lastname,age,date,picture,days}, function()end)
                    VORPcore.NotifyTip(src, _U('YouGaveYourself'), 5000)
                    exports.vorp_inventory:addItem(src, 'jagtlizenz', 1,nil,nil)
                else
                    VORPcore.NotifyTip(src, _U('PocketFull'), 5000)
                end
        end
    end)
end)


RegisterServerEvent('mms-id:server:regiveid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    MySQL.query('SELECT * FROM `mms_id` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            if Money >= Config.AusweisVerlorenPreis then
                local cancarry = exports.vorp_inventory:canCarryItems(src, 1, nil)
                local cancarryitem = exports.vorp_inventory:canCarryItem(src, 'idcard', 1, nil)
                exports.vorp_inventory:addItem(src, 'idcard', 1,nil,nil)
                Character.removeCurrency(0,Config.AusweisVerlorenPreis)
                VORPcore.NotifyTip(src, _U('GotNewID').. Config.AusweisVerlorenPreis ..'$', 5000)
            else
                VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
            end
        else
            VORPcore.NotifyTip(src, _U('GotNoID'), 5000)
        end
    end)
end)

RegisterServerEvent('mms-id:server:regivehuntingid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            if Money >= Config.HuntingLicenseVerlorenPrice then
                local cancarry = exports.vorp_inventory:canCarryItems(src, 1, nil)
                local cancarryitem = exports.vorp_inventory:canCarryItem(src, 'jagtlizenz', 1, nil)
                exports.vorp_inventory:addItem(src, 'jagtlizenz', 1,nil,nil)
                Character.removeCurrency(0,Config.HuntingLicenseVerlorenPrice)
                VORPcore.NotifyTip(src, _U('GotNewHuntingID').. Config.HuntingLicenseVerlorenPrice ..'$', 5000)
            else
                VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
            end
        else
            VORPcore.NotifyTip(src, _U('GotNoHuntingID'), 5000)
        end
    end)
end)

RegisterServerEvent('mms-id:server:changephoto',function (photolink)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local Money = Character.money
        MySQL.query('SELECT * FROM `mms_id` WHERE charidentifier = ?', {charidentifier}, function(result)
            if result[1] ~= nil then
                if Money >= Config.ChangeFotoPreis then
                    Character.removeCurrency(0,Config.ChangeFotoPreis)
                    VORPcore.NotifyTip(src, _U('ChangedPicture').. Config.ChangeFotoPreis ..'$', 5000)
                    MySQL.update('UPDATE `mms_id` SET picture = ? WHERE charidentifier = ?',{photolink, charidentifier})
                else
                    VORPcore.NotifyTip(src, _U('NotEnoghMoney'), 5000)
                end
            end
        end)
end)

RegisterServerEvent('mms-id:server:deltehuntingid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            MySQL.execute('DELETE FROM mms_huntingid WHERE charidentifier = ?', { charidentifier }, function() end)
            VORPcore.NotifyTip(src, _U('BurnedHuntingLicense'), 5000)
            exports.vorp_inventory:subItem(src, 'jagtlizenz', 1, nil, nil)
        end
    end)
end)


 ---- SHOW ID CLOSEST PLAYER

RegisterServerEvent('mms-id:server:showidclosestplayer',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local MyPedId = GetPlayerPed(src)
    local MyCoords =  GetEntityCoords(MyPedId)
    MySQL.query('SELECT * FROM `mms_id` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            local firstname = result[1].firstname
            local lastname = result[1].lastname
            local nickname = result[1].nickname
            local job = result[1].job
            local age = result[1].age
            local gender = result[1].gender
            local date = result[1].date
            local picture = result[1].picture
            for _, player in ipairs(GetPlayers()) do
                local ClosestCharacter = VORPcore.getUser(player).getUsedCharacter
                local PlayerPedId = GetPlayerPed(player)
                local PlayerCoords =  GetEntityCoords(PlayerPedId)
                local Dist = #(MyCoords - PlayerCoords)
                local closestfirstname = ClosestCharacter.firstname
                local closestlastname = ClosestCharacter.lastname
                if Dist > 0.3 and Dist < 3.0 then
                    VORPcore.NotifyTip(src, _U('YouShowID') .. closestfirstname .. ' ' .. closestlastname .. '!',  5000)
                    TriggerClientEvent('mms-id:client:getid',player,firstname,lastname,nickname,job,age,gender,date,picture)
                elseif Dist > 3.0 then
                    VORPcore.NotifyTip(src, _U('NoNearbyPlayer'),  5000)
                end
            end
        end
    end)
 end)

 RegisterServerEvent('mms-id:server:showhuntingidclosestplayer',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local MyPedId = GetPlayerPed(src)
    local MyCoords =  GetEntityCoords(MyPedId)
    MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {charidentifier}, function(result)
        if result[1] ~= nil then
            local firstname = result[1].firstname
            local lastname = result[1].lastname
            local age = result[1].age
            local date = result[1].date
            local picture = result[1].picture
            local days = result[1].days
            for _, player in ipairs(GetPlayers()) do
                local ClosestCharacter = VORPcore.getUser(player).getUsedCharacter
                local PlayerPedId = GetPlayerPed(player)
                local PlayerCoords =  GetEntityCoords(PlayerPedId)
                local Dist = #(MyCoords - PlayerCoords)
                local closestfirstname = ClosestCharacter.firstname
                local closestlastname = ClosestCharacter.lastname
                if Dist > 0.3 and Dist < 3.0 then
                    VORPcore.NotifyTip(src, _U('YouShowHuntingID') .. closestfirstname .. ' ' .. closestlastname .. '!',  5000)
                    TriggerClientEvent('mms-id:client:gethuntingid',player,firstname,lastname,age,date,picture,days)
                elseif Dist > 3.0 then
                    VORPcore.NotifyTip(src, _U('NoNearbyPlayer'),  5000)
                end
            end
        end
    end)
 end)


 VORPcore.Callback.Register('mms-id:callback:getplayerjob', function(source,cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local playerjob = Character.job
    cb (playerjob)
end)


RegisterServerEvent('mms-id:server:createjobhuntingid',function (days)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local MyPedId = GetPlayerPed(src)
    local MyCoords =  GetEntityCoords(MyPedId)
    local year = os.date('%Y')
    local month = os.date('%m')
    local day = os.date('%d')
    local hour = os.date('%H')
    local min = os.date('%M')
    local date = day ..':'..  month .. ':' .. year .. _U('AT') .. hour .. ':' ..min.. _U('Clock')
    local picture = Config.HuntingIdPicture
    for _, player in ipairs(GetPlayers()) do
        local ClosestCharacter = VORPcore.getUser(player).getUsedCharacter
        local PlayerPedId = GetPlayerPed(player)
        local PlayerCoords =  GetEntityCoords(PlayerPedId)
        local Dist = #(MyCoords - PlayerCoords)
        local closestidentifier = ClosestCharacter.identifier
        local closestcharidentifier = ClosestCharacter.charIdentifier
        local closestfirstname = ClosestCharacter.firstname
        local closestlastname = ClosestCharacter.lastname
        local closestage = ClosestCharacter.age
        if Dist > 0.3 and Dist < 3.0 then
            MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {closestcharidentifier}, function(result)
                if result[1] ~= nil then
                    local cancarry = exports.vorp_inventory:canCarryItems(player , 1, nil)
                    local cancarryitem = exports.vorp_inventory:canCarryItem(player , 'jagtlizenz', 1, nil)
                        if cancarry and cancarryitem then
                            MySQL.execute('DELETE FROM mms_huntingid WHERE charidentifier = ?', {closestcharidentifier}, function() end)
                            Citizen.Wait(500)
                            MySQL.insert('INSERT INTO `mms_huntingid` (identifier,charidentifier,firstname,lastname,age,date,picture,days) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                            {closestidentifier,closestcharidentifier,closestfirstname,closestlastname,closestage,date,picture,days}, function()end)
                            VORPcore.NotifyTip(src, _U('YouGaveID') .. closestfirstname .. ' ' .. closestlastname, 5000)
                            exports.vorp_inventory:addItem(player, 'jagtlizenz', 1,nil,nil)
                        else
                            VORPcore.NotifyTip(src, _U('AlreadyHasHuntingID'), 5000)
                            VORPcore.NotifyTip(player, _U('YouAlreadyHasHuntingID'), 5000)
                        end
                else
                    local cancarry = exports.vorp_inventory:canCarryItems(player , 1, nil)
                    local cancarryitem = exports.vorp_inventory:canCarryItem(player , 'jagtlizenz', 1, nil)
                        if cancarry and cancarryitem then
                            MySQL.insert('INSERT INTO `mms_huntingid` (identifier,charidentifier,firstname,lastname,age,date,picture,days) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                            {closestidentifier,closestcharidentifier,closestfirstname,closestlastname,closestage,date,picture,days}, function()end)
                            VORPcore.NotifyTip(src, _U('YouGaveID') .. closestfirstname .. ' ' .. closestlastname, 5000)
                            exports.vorp_inventory:addItem(player, 'jagtlizenz', 1,nil,nil)
                            
                        else
                            VORPcore.NotifyTip(src, _U('PocketFull'), 5000)
                            VORPcore.NotifyTip(player, _U('PocketFull'), 5000)
                        end
                end

            end)
        elseif Dist > 3.0 then
            VORPcore.NotifyTip(src, _U('NoNearbyPlayer'),  5000)
            
        end
    end
end)

RegisterServerEvent('mms-id:server:revokehuntingid',function ()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local MyPedId = GetPlayerPed(src)
    local MyCoords =  GetEntityCoords(MyPedId)
    for _, player in ipairs(GetPlayers()) do
        local ClosestCharacter = VORPcore.getUser(player).getUsedCharacter
        local PlayerPedId = GetPlayerPed(player)
        local PlayerCoords =  GetEntityCoords(PlayerPedId)
        local Dist = #(MyCoords - PlayerCoords)
        local closestidentifier = ClosestCharacter.identifier
        local closestcharidentifier = ClosestCharacter.charIdentifier
        if Dist > 0.3 and Dist < 3.0 then
            MySQL.query('SELECT * FROM `mms_huntingid` WHERE charidentifier = ?', {closestcharidentifier}, function(result)
                if result[1] ~= nil then
                    MySQL.execute('DELETE FROM mms_huntingid WHERE charidentifier = ?', {closestcharidentifier}, function() end)
                    local hasitem = exports.vorp_inventory:getItemCount(player, nil, 'jagtlizenz',nil)
                    if hasitem > 0 then
                    exports.vorp_inventory:subItem(player, 'jagtlizenz', 1,nil,nil)
                    end
                    VORPcore.NotifyTip(src, _U('YouRevokedHuntingID'), 5000)
                    VORPcore.NotifyTip(player, _U('RevokedHuntingID'), 5000)
                else
                    VORPcore.NotifyTip(src, _U('PlayerGotNoHuntingID'), 5000)
                end
            end)
        elseif Dist > 3.0 then
            VORPcore.NotifyTip(src, _U('NoNearbyPlayer'),  5000)
        end
    end
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()