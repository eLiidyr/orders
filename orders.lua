_addon.name     = 'orders'
_addon.author   = 'Elidyr'
_addon.version  = '0.20220312'
_addon.command  = 'ord'

require('luau')

local calls = {}
local helpers = {}
local accounts = T{'Eliidyr','Lordpotato','Duhpeter','Clapmycheeks','Mutant','Daxxed','Turdle','Reported','Hqonly'}
local stagger = 0.75

windower.register_event('addon command', function(...)
    local commands = T{...}
    local command = table.remove(commands, 1)

    if command then
        local command = command:lower()

        if S{'war','mnk','whm','blm','rdm','thf','pld','drk','bst','brd','rng','smn','sam','nin','drg','blu','cor','pup','dnc','sch','geo','run'}:contains(command:sub(1, 3)) then
            
            if #command > 3 and command:sub(4, 4) == '*' then
                calls['jj'](table.concat(commands, ' '):sub(1, #table.concat(commands, ' ')), command:lower())

            else
                calls['j'](table.concat(commands, ' '):sub(1, #table.concat(commands, ' ')), command:lower())

            end

        elseif command and calls[command] then
            calls[command](table.concat(commands, ' '):sub(1, #table.concat(commands, ' ')))

        end

    end

end)

windower.register_event('ipc message', function(message)
    local player = windower.ffxi.get_player()

    if player and message then

        for order in T(message:split('||')):it() do

            if order:sub(1, (#player.name)) == player.name then

                if order:sub((#player.name) + 1, (#player.name) + 1) == ':' then
                    local job = order:sub((#player.name) + 2, (#player.name) + 4)

                    if player.main_job:lower() == job then                        
                        windower.send_command(order:sub((#player.name) + 4, #order))
                    end

                else
                    windower.send_command(order:sub((#player.name) + 2, #order))

                end

            end

        end

    end

end)

-- All Accounts.
calls['@'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)

        else
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))

        end

    end
    helpers.deliver(order)

end

calls['@@'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)
            delay = (delay + stagger)

        else
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

calls['@*'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account ~= player.name then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
        end

    end
    helpers.deliver(order)

end

calls['@@*'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account ~= player.name then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

-- Accounts in range. (25 yalms.)
calls['r'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do
        local target = windower.ffxi.get_mob_by_name(account)

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)

        elseif target and target and (target.distance):sqrt() < 25 then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))

        end

    end
    helpers.deliver(order)

end

calls['rr'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do
        local target = windower.ffxi.get_mob_by_name(account)

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)
            delay = (delay + stagger)

        elseif target and target and (target.distance):sqrt() < 25 then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

calls['r*'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do
        local target = windower.ffxi.get_mob_by_name(account)

        if account ~= player.name and target and target and (target.distance):sqrt() < 25 then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
        end

    end
    helpers.deliver(order)

end

calls['rr*'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do
        local target = windower.ffxi.get_mob_by_name(account)

        if account ~= player.name and target and target and (target.distance):sqrt() < 25 then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

-- Accounts in party.
calls['p'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)

        elseif helpers.isMember(account) then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))

        end

    end
    helpers.deliver(order)

end

calls['pp'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)
            delay = (delay + stagger)


        elseif helpers.isMember(account) then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

calls['p*'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account ~= player.name and helpers.isMember(account) then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
        end

    end
    helpers.deliver(order)

end

calls['pp*'] = function(orders)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account ~= player.name and helpers.isMember(account) then
            table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

-- Accounts in the current zone.
calls['z'] = function(orders)
    local zone = windower.ffxi.get_info().zone
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)

        elseif account ~= player.name then
            local member = helpers.getMember(account)

            if member and member.mob and member.zone == zone then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            end

        end

    end
    helpers.deliver(order)

end

calls['zz'] = function(orders)
    local zone = windower.ffxi.get_info().zone
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account == player.name then
            order.player = string.format('wait %s; %s', delay, orders)
            delay = (delay + stagger)

        elseif account ~= player.name then
            local member = helpers.getMember(account)

            if member and member.mob and member.zone == zone then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)

            end

        end

    end
    helpers.deliver(order)

end

calls['z*'] = function(orders)
    local zone = windower.ffxi.get_info().zone
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account ~= player.name then
            local member = helpers.getMember(account)

            if member and member.mob and member.zone == zone then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            end

        end

    end
    helpers.deliver(order)

end

calls['zz*'] = function(orders)
    local zone = windower.ffxi.get_info().zone
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do

        if account ~= player.name then
            local member = helpers.getMember(account)

            if member and member.mob and member.zone == zone then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
            
            end

        end

    end
    helpers.deliver(order)

end

-- Accounts in range with a specific job.
calls['j'] = function(orders, job)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0
    
    for account in accounts:it() do
        local target = windower.ffxi.get_mob_by_name(account)

        if account == player.name and player.main_job:lower() == job then
            order.player = string.format('wait %s; %s', delay, orders)

        elseif account ~= player.name and target and target and (target.distance):sqrt() < 25 then
            table.insert(order.others, string.format('||%s:%s wait %s; %s', account, job, delay, orders))

        end

    end
    helpers.deliver(order)

end

calls['jj'] = function(orders, job)
    local player = windower.ffxi.get_player()
    local order = {player=false, others={}}
    local delay = 0

    for account in accounts:it() do
        local target = windower.ffxi.get_mob_by_name(account)

        if account == player.name and player.main_job:lower() == job then
            order.player = string.format('wait %s; %s', delay, orders)
            delay = (delay + stagger)

        elseif account ~= player.name and target and target and (target.distance):sqrt() < 25 then
            table.insert(order.others, string.format('||%s:%s wait %s; %s', account, job, delay, orders))
            delay = (delay + stagger)

        end

    end
    helpers.deliver(order)

end

helpers.deliver = function(order)

    if order and order.others and #order.others > 0 then
        windower.send_ipc_message(windower.convert_auto_trans(table.concat(order.others, ' ')))
    end

    if order and order.player then
        windower.send_command(windower.convert_auto_trans(order.player))
    end

end

helpers.getMember = function(player)

    if player then

        for i,v in pairs(windower.ffxi.get_party()) do

            if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and v.mob and v.name:lower() == player:lower() then
                return v
            end

        end
    
    end
    return false

end

helpers.isMember = function(player)

    if player then

        for i,v in pairs(windower.ffxi.get_party()) do

            if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and v.name and v.name:lower() == player:lower() then
                return true
            end

        end
    
    end
    return false

end