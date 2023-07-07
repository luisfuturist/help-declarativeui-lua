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

local function updateTree(parent, children)
    if (not children) then return end
    if (type(children) == 'string') then return end
    
    for _, child in ipairs(children) do
        local absW = parent.parent and parent.props.absW or (child.props.width or 0)
        local absH = parent.parent and parent.props.absH or (child.props.height or 0)
        local paddingR = parent.parent and parent.props.padding[2] or 0
        local paddingB = parent.parent and parent.props.padding[3] or 0
        child.parent = parent
        child.props.absX = (child.props.x or 0) + (parent.parent and parent.props.absX or 0)
        child.props.absY = (child.props.y or 0) + (parent.parent and parent.props.absY or 0)
        child.props.absW = absW * toABS(child.props.width) + ((not isPercent(child.props.width)) and child.props.width or 0) - paddingR
        child.props.absH = absH * toABS(child.props.height) + ((not isPercent(child.props.height)) and child.props.height or 0) - paddingB
        updateTree(child, child.children)
    end
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end