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
    
    local parentProps = parent.parent and parent.props

    for _, child in ipairs(children) do
        local childProps = child.props

        local absW = parentProps and parentProps.absW or (childProps.width or 0)
        local absH = parentProps and parentProps.absH or (childProps.height or 0)
        local paddingR = parentProps and parentProps.padding[2] or 0
        local paddingB = parentProps and parentProps.padding[3] or 0

        child.parent = parent
        child.props.absX = (childProps.x or 0) + (parentProps and parentProps.absX or 0)
        child.props.absY = (childProps.y or 0) + (parentProps and parentProps.absY or 0)
        child.props.absW = absW * toABS(childProps.width) + ((not isPercent(childProps.width)) and childProps.width or 0) - paddingR
        child.props.absH = absH * toABS(childProps.height) + ((not isPercent(childProps.height)) and childProps.height or 0) - paddingB
        
        updateTree(child, child.children)
    end
end

function render(_root, element)
    updateTree(_root, element)
    _root.children = element
end