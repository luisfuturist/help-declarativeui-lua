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
    
    parent.props.padding = {
        t = parent.props.padding[1] or 0,
        r = parent.props.padding[2] or 0,
        b = parent.props.padding[3] or 0,
        l = parent.props.padding[4] or 0,
    }
    local parentProps = parent.parent and parent.props or nil

    for _, child in ipairs(children) do
        local childProps = child.props

        local parentAbsW = parentProps and parentProps.absW or (childProps.width or 0)
        local parentAbsH = parentProps and parentProps.absH or (childProps.height or 0)
        local paddingR = parentProps and parentProps.padding[2] or 0
        local paddingB = parentProps and parentProps.padding[3] or 0

        child.parent = parent
        child.props.absX = (childProps.x or 0) + (parentProps and parentProps.absX or 0)
        child.props.absY = (childProps.y or 0) + (parentProps and parentProps.absY or 0)
        child.props.absW = parentAbsW * normalizePercent(childProps.width, 0) + ((not isPercent(childProps.width)) and childProps.width or 0) - paddingR
        child.props.absH = parentAbsH * normalizePercent(childProps.height, 0) + ((not isPercent(childProps.height)) and childProps.height or 0) - paddingB
        child.props.absMaxW = isPercent(childProps.maxWidth) and parentAbsW * normalizePercent(childProps.maxWidth) or childProps.maxWidth
        child.props.absMaxH = isPercent(childProps.maxHeight) and parentAbsH * normalizePercent(childProps.maxHeight) or childProps.maxHeight
        child.props.absMinW = isPercent(childProps.minWidth) and parentAbsW * normalizePercent(childProps.minWidth) or childProps.minWidth
        child.props.absMinH = isPercent(childProps.minHeight) and parentAbsH * normalizePercent(childProps.minHeight) or childProps.minHeight
        child.props.padding =  {
            t = childProps.padding[1] or 0,
            r = childProps.padding[2] or 0,
            b = childProps.padding[3] or 0,
            l = childProps.padding[4] or 0
        }
        child.props.margin = {
            t = childProps.margin[1] or 0,
            r = childProps.margin[2] or 0,
            b = childProps.margin[3] or 0,
            l = childProps.margin[4] or 0
        }

        updateTree(child, child.children)
    end
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end