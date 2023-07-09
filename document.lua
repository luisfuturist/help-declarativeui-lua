elements = {}

local screenWidth, screenHeight = guiGetScreenSize()

function h(tag, props, children)
    if (not tag) then error('Element tag is required', 2) end
    if (not props) then error('Element props is required', 2) end -- __DEV__
    
    children = children or {}
    props.postGUI = props.postGUI or false
    props.x = props.x or 0
    props.y = props.y or 0
    props.minWidth = props.minWidth or 0
    props.minHeight = props.minHeight or 0
    props.maxWidth = props.maxWidth or props.width
    props.maxHeight = props.maxHeight or props.height
    props.display = props.display or 'static'
    props.direction = props.direction or 'column'
    props.wrap = props.wrap or 'nowrap'

    local newProps = {}
    for k, v in pairs(props) do
        local value = (type(v) == 'function') and memo(v) or v
        if (isReactive(value)) then
            newProps[k] = value.peek()
            newProps['_' .. k] = value
            effect(function()
                newProps[k] = value.get()
            end)
        else
            newProps[k] = value
            newProps['_' .. k] = value
        end
    end

    local element = {
        tag = tag,
        props = newProps,
        children = children,
        parent = nil,
        events = props.on or {},
        blockBoxX = 0,
        blockBoxY = 0,
        highestChildHeight = 0,
        absX = 0,
        absY = 0,
        absW = props.width,
        absH = props.height,
        absMaxW = props.maxWidth or 0,
        absMaxH = props.maxHeight or 0,
        absMinW = props.minWidth or 0,
        absMinH = props.minHeight or 0,
    }
    
    if (type(children) == 'function') then
        local cMemo = memo(children)
        effect(function()
            local c = { cMemo.get() }
            updateTree(element, c)
            element.children = c
        end)
    elseif (type(children) == 'table') then
        for i = 1, #children do
            local child = children[i]
            if (type(child) == 'function') then
                local cMemo = memo(child)
                effect(function()
                    local c = cMemo.get()
                    updateNode(element, c)
                    element.children[i] = c
                end)
            end
        end
    end

    local addEventListener = function(event, callback)
        element.events[event] = callback
    end

    local ref = props.ref
    if (ref) then
        ref.set({ addEventListener })
    end
    
    if (element.events.hover) then
        local callback = element.events.hover
        element.events.mouseIn = function()
            callback({ target = element, data = { state = 'in' } })
        end
        element.events.mouseOut = function()
            callback({ target = element, data = { state = 'out' } })
        end
    end

    for k, v in pairs(element.events) do
        if (isUnderline(k)) then
            addEventHandler(k, root, function(...)
                local data = eventParameters[k:gsub('_', '')](...)
                v({  target = element, data = data })
            end)
        else
            if (eventHandlers[k]) then
                eventHandlers[k](element, v, ref)
            end
        end
    end

    if (element.events.created) then
        eventHandlers.created(element, element.events.created)
    end
    return element
end

function lazy(elementGetter)
    return elementGetter
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
            update()
            coroutine.yield()
        end
    end)
end
addEventHandler('onClientResourceStart', resourceRoot, updateUI)