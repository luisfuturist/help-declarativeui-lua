local screenWidth, screenHeight = guiGetScreenSize()

local elements = {}


local context = {}
function signal(initialValue)
    local value = initialValue
    local listeners = {}

    local function unsub(callback)
        for i = 1, #listeners do
            if (listeners[i] == callback) then
                table.remove(listeners, i)
                break
            end
        end
    end

    local function get()
        local current = context[#context]
        if (current) then
            local exists = false
            for i = 1, #listeners do
                if (listeners[i] == current) then
                    exists = true
                    break
                end
            end
            if (not exists) then
                listeners[#listeners+1] = current
            end
        end
        return value
    end

    local function set(newValue)
        if (value == newValue) then return end
        value = newValue
        for i = 1, #listeners do
            listeners[i]()
        end
    end

    return {
        unsub = unsub,
        set = set,
        get = get,
    }
end

function effect(callback)
    local disposed = false
    
    local function execute()
        context[#context+1] = execute
        if (not disposed) then
            callback()
        end
        table.remove(context, #context)
    end

    local function dispose()
        disposed = true
    end

    execute()
    return dispose
end

function memo(callback)
    local cache = nil

    effect(function()
        if (cache) then
            cache.set(callback())
        else
            cache = signal(callback())
        end
    end)

    return cache.get
end

local function flushRender(els)
    els = els or elements

    for i = 1, #els do
        local element = els[i]
        if (element) then
            local tag = element.tag
            if (drawers[tag]) then
                drawers[tag](element)
            end

            if (element.children) then
                flushRender(element.children)
            end
        end
    end
end

local function renderUI()
    CreateThread(function()
        while (true) do
            flushRender()
            coroutine.yield()
        end
    end)
end
addEventHandler('onClientResourceStart', resourceRoot, renderUI)

function h(tag, props, children)
    if (not tag) then error('Element tag is required', 2) end
    if (not props) then error('Element props is required', 2) end
    
    children = children or {}
    props.postGUI = props.postGUI or false

    local element = {
        tag = tag,
        props = props,
        children = children,
        parent = nil,
        events = props.on or {}
    }
    return element
end

function Element(tag, props, children)
    return h(tag, props, children)
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

local function updateTree(parent, els)
    if (not els) then return end

    -- parent.props.path = signal(parent.props.path.get() or '')

    for elementIndex, element in ipairs(els) do
        element.parent = parent
        -- parent.props.path = signal(parent.props.path.get() .. '/' .. elementIndex)
        if (element.children) then
            for i = 1, #element.children do
                local child = element.children[i]
                child.parent = element
                -- child.props.path = signal(element.props.path.get() .. '/' .. i)
                updateTree(element, child)
            end
        end
    end
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end

local function Screen(children)
    return Element('screen', {
        x = 0,
        y = 0,
        width = screenWidth,
        height = screenHeight,
        path = ''
    }, children)
end

local screen = Screen({})
elements[#elements + 1] = screen

function Rect(props, children)
    props.color = props.color or { 255, 255, 255, 1 }
    return Element('rect', props, children)
end

function Button(props)
    if (props.on and props.on.click) then
        addEventHandler('onClientClick', root, function(button, state)
            if (isMouseInPosition(props.x.get(), props.y, props.width, props.height)) then
                props.on.click({
                    button = button,
                    state = state
                })
                props.x.set(props.x.get() + 20)
                props.color.set({ 255, 0, 0, 1 })
            end
        end)
    end

    return Rect(props)
end

function Fragment(children)
    return Element('fragment', {}, children)
end
