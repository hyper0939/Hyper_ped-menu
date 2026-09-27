local ESX = exports['es_extended']:getSharedObject()

-- ══════════════════════════════════════════════════════════════
--  Server-seitige Berechtigungsprüfung (optional für Commands)
-- ══════════════════════════════════════════════════════════════

ESX.RegisterServerCallback('hyper_ped-menu:checkPermission', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end

    for _, group in ipairs(Config.AllowedGroups) do
        if xPlayer.getGroup() == group then
            cb(true)
            return
        end
    end

    cb(false)
end)

-- ══════════════════════════════════════════════════════════════
--  Logging (optional)
-- ══════════════════════════════════════════════════════════════

RegisterNetEvent('hyper_ped-menu:logPedChange', function(pedName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        print(('[hyper_ped-menu] %s (%s) hat sein Ped zu "%s" geändert.'):format(
            xPlayer.getName(),
            src,
            pedName
        ))
    end
end)
