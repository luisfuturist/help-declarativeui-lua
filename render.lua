function flushRender(els)
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

local function updateTree(parent, children)
    if (not children) then return end
    if (type(children) == 'string') then return end
    
    -- local parent = parent.parent and parent.props or nil

    for _, child in ipairs(children) do
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

        -- child.props.absY = (unwrap(childProps.y) or 0) + (parent and parent.absY or 0)
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
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end