function CreateThread(callback)
    local thread = coroutine.create(callback)
    local function resume()
        local status, result = coroutine.resume(thread)
        if (not status) then error(result, 2) end
        if (coroutine.status(thread) ~= 'dead') then
            setTimer(resume, 0, 1)
        end
    end
    resume()
end

function rgba(r, g, b, a)
    a = a or 1
    return tocolor(r, g, b, a * 255)
end

function isUnderline(str)
    return str:sub(1,1) == "_"
end

function dxDrawLinedRectangle(x, y, width, height, color, _width, postGUI )
	_width = _width or 1
	dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
	dxDrawLine ( x, y, x, y+height, color, _width, postGUI )
	dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
	return dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end

_dxDrawText = dxDrawText
function dxDrawText(t, x, y, r, b, ...)
    return _dxDrawText(t, x, y, r + x, b + y, ...)
end

function normalizePercent(str, defaultValue)
    if (not (type(str) == 'string')) then return (not defaultValue) and str or defaultValue end
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

function normalizeInset(_inset)
    local inset = { _inset[1], _inset[2], _inset[3], _inset[4] }
    return {
        t = type(inset[1]) == 'string' and 0 or inset[1] or 0,
        r = type(inset[2]) == 'string' and 0 or inset[2] or 0,
        b = type(inset[3]) == 'string' and 0 or inset[3] or 0,
        l = type(inset[4]) == 'string' and 0 or inset[4] or 0
    }
end