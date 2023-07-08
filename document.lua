elements = {}

local screenWidth, screenHeight = guiGetScreenSize()

local function normalizeProp(props, key, amount, defaultValue)
    local value = props[key] or {}
    if (not props[key]) then
        props[key] = {}
    end
    if (type(value) == 'number' or type(value) == 'string') then
        props[key] = {}
        for i = 1, amount do
            props[key][i] = value
        end
    else
        for i = 1, amount do
            props[key][i] = value[i] or defaultValue
        end
    end
end

function h(tag, props, children)
    if (not tag) then error('Element tag is required', 2) end
    if (not props) then error('Element props is required', 2) end -- __DEV__
    
    children = children or {}
    props.postGUI = props.postGUI or false
    props.absX = 0
    props.absY = 0
    props.absW = props.width
    props.absH = props.height
    props.minWidth = props.minWidth or 0
    props.minHeight = props.minHeight or 0
    props.maxWidth = props.maxWidth or props.absW
    props.maxHeight = props.maxHeight or props.absH

    local newProps = {}
    for k, v in pairs(props) do
        if (type(v) == 'function') then
            newProps[k] = memo(v)
        else
            newProps[k] = v
        end
    end

    normalizeProp(newProps, 'padding', 4, 0)
    normalizeProp(newProps, 'overflow', 2, 'visible')
    normalizeProp(newProps, 'inset', 4, 'auto')
    normalizeProp(newProps, 'margin', 4, 0)

    local element = {
        tag = tag,
        props = newProps,
        children = children,
        parent = nil,
        events = props.on or {}
    }

    local ref = props.ref
    if (ref) then
        ref.set({ addEventListener = function(event, callback)
            element.events[event] = callback
        end })
    end

    for k, v in pairs(element.events) do
        if (isUnderline(k)) then
            addEventHandler(k, root, function(...)
                local data = eventsParameters[k:gsub('_', '')](...)
                v({  target = element, data = data })
            end)
        else
            if (k == 'click') then
                addEventHandler('onClientClick', root, function(...)
                    if (not (isMouseInPosition(
                        unwrap(element.props.x),
                        unwrap(element.props.y),
                        unwrap(element.props.width),
                        unwrap(element.props.height)
                    ))) then
                        return
                    end
                    v({  target = element, data = eventsParameters['onClientClick'](...) })
                end)
            end
        end
    end

    return element
end

function getElementByKey(key, value, els)
    els = els or elements

    for i = 1, #els do
        local element = els[i]
        if (element[key] == value) then
            return element
        else
            if (element.children and #element.children > 0) then
                return getElementByKey(key, value, element.children)
            end
        end
    end

    return nil
end

function getElementByProp(prop, value, els)
    els = els or elements

    for i = 1, #els do
        local element = els[i]
        if (element) then
            if (element.props[prop] == value) then
                return element
            else
                if (element.children and #element.children > 0) then
                    return getElementByProp(prop, value, element.children)
                end
            end
        end
    end

    return nil
end

function getScreen()
    return getElementByKey('tag', 'screen')
end

local screen = Screen({})
elements[#elements + 1] = screen

local mouse = {}

function updateMouse()
    mouse.state = isCursorShowing()
    if (mouse.state) then
        local cx, cy = getCursorPosition()
        mouse.x, mouse.y = cx * screenWidth, cy * screenHeight
    end
end

function isMouseInPosition(x, y, w, h)
    if (not mouse.state) then return end
    local mx, my = mouse.x, mouse.y
    return ((mx >= x and mx <= x + w) and (my >= y and my <= y + h))
end

local function updateUI()
    CreateThread(function()
        while (true) do
            updateMouse()
            flushRender()
            coroutine.yield()
        end
    end)
end
addEventHandler('onClientResourceStart', resourceRoot, updateUI)