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

local function updateTree(parent, els)
    if (not els) then return end

    for _, element in ipairs(els) do
        element.parent = parent
        element.props.absX = element.props.x + parent.props.absX 
        element.props.absY = element.props.y + parent.props.absY
        if (element.children) then
            for i = 1, #element.children do
                local child = element.children[i]
                child.parent = element
                child.props.absX = child.props.x + element.props.absX
                child.props.absY = child.props.y + element.props.absY
                updateTree(element, child)
            end
        end
    end
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end