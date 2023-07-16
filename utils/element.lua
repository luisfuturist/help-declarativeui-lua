function normalizeProp(value, amount, defaultValue)
    value = value or {}

    if (type(value) == 'number' or type(value) == 'string') then
        local newValue = {}
        for i = 1, amount do
            newValue[i] = value
        end
        return newValue
    else
        for i = 1, amount do
            value[i] = value[i] or defaultValue
        end
    end
    return value
end

function isMouseOverElement(element)
    return isMouseInPosition(
        element.absX,
        element.absY,
        element.absW,
        element.absH
    )
end

function getSafeProp(element, key, defaultValue)
    return (element.signals[key] and element.signals[key].get() or element.props[key]) or defaultValue
end

function normalizeInset(_inset)
    local inset = { _inset[1], _inset[2], _inset[3], _inset[4] }
    return {
        t = type(inset[1]) == 'string' and 0 or inset[1] or 0,
        r = type(inset[2]) == 'string' and 0 or inset[2] or 0,
        b = type(inset[3]) == 'string' and 0 or inset[3] or 0,
        l = type(inset[4]) == 'string' and 0 or inset[4] or 0
    }
end

function normalizeSize(parentKey, child, childKey, paddingA, defaultValue)
    local parent = child.parent
    local value = child.props[childKey]

    if (value == 'auto') then
        return defaultValue or 0
    end

    if (not parent) then return value end

    if (isPercent(value)) then
        local parentSizeValue = parent[parentKey]
        local parentContentSizeValue = parentSizeValue - paddingA
        return parentContentSizeValue * normalizePercent(value)
    end
    return value
end

function _normalizeSize(_parentSignal, child, childSignal, paddingA, defaultValue)
    local parent = child.parent
    local value = childSignal.get()

    if (value == 'auto') then
        return defaultValue or 0
    end

    if (not parent) then return value end

    if (isPercent(value)) then
        local parentSizeValue = _parentSignal.get() or 0
        local parentContentSizeValue = parentSizeValue - paddingA
        return parentContentSizeValue * normalizePercent(value)
    end
    return value
end

function normalizeDirectionalProp(value, defaultValue)
    value = value or {}

    if (type(value) == 'number' or type(value) == 'string') then
        local newValue = {}
        newValue.t = value
        newValue.r = value
        newValue.b = value
        newValue.l = value
        return newValue
    else
        value.t = value[1] or defaultValue
        value.r = value[2] or defaultValue
        value.b = value[3] or defaultValue
        value.l = value[4] or defaultValue
    end
    return value
end