function normalizePercent(str, defaultValue)
    if (not (type(str) == 'string')) then
        if (not defaultValue) then
            return str
        else
            return defaultValue
        end
    end

    local value = tonumber(str)
    if (not value) then
        value = select(3, str:find('([%d%.]+)%%'))
        if (not value) then
            return 0
        end
        return tonumber(value) / 100
    end
    return value
end

function isPercent(str)
    if (not (type(str) == 'string')) then return false end
    return str:find('([%d%.]+)%%') ~= nil
end