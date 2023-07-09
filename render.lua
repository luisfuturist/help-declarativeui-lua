local function updateEvents(element)
    local x, y, w, h = element.props.x, element.props.y, element.props.width, element.props.height
    
    if (element.events and element.events.mouseIn) then
        if (isMouseInPosition(x, y, w, h)) then
            element.events.mouseIn({ target = element })
        else
            if (element.events and element.events.mouseOut) then
                element.events.mouseOut({ target = element })
            end
        end
    end
end

function update(els)
    els = els or elements

    for i = 1, #els do
        local element = els[i]
        if (element and type(element) == 'table') then
            local tag = element.tag
            
            updateEvents(element)

            if (drawers[tag]) then
                drawers[tag](element)
            end

            if (element.children) then
                update(element.children)
            end
        end
    end
end

function updateNode(parent, child)
    child.parent = parent

    local childProps = child.props
    local parentAbsW = parent and parent.absW or (childProps.width or 0)
    local parentAbsH = parent and parent.absH or (childProps.height or 0)
    local padding = parent and normalizeProp(parent.props.padding, 4, 0) or { }
    local gap = parent and normalizeProp(parent.props.gap, 2, 0) or { 0, 0 }
    local paddingR = padding[2] or 0
    local paddingB = padding[3] or 0

    local x = wrap(childProps._x)
    local parentX = wrap(parent and parent.absX or 0)
    effect(function()
        child.absX = x.get() + parentX.get()
    end)

    local y = wrap(childProps._y)
    local parentY = wrap((parent and parent.absY or 0))
    effect(function()
        child.absY = y.get() + parentY.get()
    end)

    child.absW = parentAbsW * normalizePercent(childProps.width, 0) + ((not isPercent(childProps.width)) and childProps.width or 0) - paddingR
    child.absH = parentAbsH * normalizePercent(childProps.height, 0) + ((not isPercent(childProps.height)) and childProps.height or 0) - paddingB
    child.absMaxW = isPercent(childProps.maxWidth) and parentAbsW * normalizePercent(childProps.maxWidth) or childProps.maxWidth
    child.absMaxH = isPercent(childProps.maxHeight) and parentAbsH * normalizePercent(childProps.maxHeight) or childProps.maxHeight
    child.absMinW = isPercent(childProps.minWidth) and parentAbsW * normalizePercent(childProps.minWidth) or childProps.minWidth
    child.absMinH = isPercent(childProps.minHeight) and parentAbsH * normalizePercent(childProps.minHeight) or childProps.minHeight

    child.blockBoxX = parent.blockBoxX
    parent.blockBoxX = parent.blockBoxX + child.absW + gap[1]
    child.blockBoxY = parent.blockBoxY
    parent.blockBoxY = parent.blockBoxY + child.absH + gap[2]
    parent.highestChildHeight = math.max(parent.highestChildHeight, child.absH)

    updateTree(child, child.children)
end

function updateTree(parent, children)
    if (not children) then return end
    if (type(children) == 'string') then return end
    
    for _, child in ipairs(children) do
        if (type(child) == 'table') then
            updateNode(parent, child)
        end
    end
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end