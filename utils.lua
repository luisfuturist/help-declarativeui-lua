local screenWidth, screenHeight = guiGetScreenSize()

local function isSignal(value)
    return type(value) == 'table' and type(value.get) == 'function'
end

local function unwrap(value, default)
    default = default or 0
    return (value and (isSignal(value) and value.get() or value) or default)
end

drawers = {
    ['rect'] = function(element)
        local color = unwrap(element.props.color)
        local alpha = unwrap(element.props.alpha, 1)

        dxDrawRectangle(
            unwrap(element.props.x),
            unwrap(element.props.y),
            unwrap(element.props.width),
            unwrap(element.props.height),
            rgba(
                color[1],
                color[2],
                color[3],
                color[4] or alpha
            )
        )
    end
}

function isMouseInPosition(x, y, w, h)
    if (not isCursorShowing()) then return false end
    local cx, cy = getCursorPosition()
    local mx, my = cx * screenWidth, cy * screenHeight
    return ((mx >= x and mx <= x + w) and (my >= y and my <= y + h))
end

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