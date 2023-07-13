local function updateEvents(element)
    local x, y, w, h = element.absX, element.absY, element.absW, element.absH
    
    if (element.events.mouseIn) then
        if (isMouseInPosition(x, y, w, h)) then
            element.events.mouseIn({ target = element })
        else
            if (element.events.mouseOut) then
                element.events.mouseOut({ target = element })
            end
        end
    end

    -- if (element.events.lifeUpdate) then
    --     local life = signal(0)
    --     life.set(getElementHealth(localPlayer))
    --     memo(function()
    --         element.events.lifeUpdate({ target = element, data = { value = life.get() } })
    --         return life.get()
    --     end)
    -- end

    if (element.events.render) then
        element.events.render({ target = element })
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

    -- local x = wrap(childProps._x)
    -- local parentX = wrap(parent and parent.absX or 0)
    -- effect(function()
    --     child.absX = x.get() + parentX.get()
    -- end)

    -- local y = wrap(childProps._y)
    -- local parentY = wrap((parent and parent.absY or 0))
    -- effect(function()
    --     child.absY = y.get() + parentY.get()
    -- end)

    -- local w = wrap(childProps._width)
    -- effect(function()
    --     child.absW = w.get()
    -- end)

function updateNode(parent, child)
    child.parent = parent
    
    -- reactivity
    local x = wrap(child.props._x)
    local y = wrap(child.props._y)
    local width = wrap(child.props._width)
    local height = wrap(child.props._height)
    local parentX = wrap(parent.props._x)
    local parentY = wrap(parent.props._y)
    local parentW = wrap(parent.props._width)
    local parentH = wrap(parent.props._height)
    effect(function()
        local gap = parent and normalizeProp(parent.props.gap, 2, 0) or { 0, 0 }
        local m = normalizeDirectionalProp(child.props.margin, 0)
        local propsInset = normalizeProp(child.props.inset, 4, 'auto')
        local inset = normalizeInset(propsInset)
        local p = normalizeDirectionalProp(parent.props.padding, 0)
        local px = p.l + p.r
        local py = p.t + p.b
    
        -- box
        child.absX = parent.absX + child.props.x
        child.absY = parent.absY + child.props.y
        child.absW = normalizeSize('absW', child, 'width', px, 0)
        child.absH = normalizeSize('absH', child, 'height', py, 0)
        child.absMaxW = normalizeSize('absW', child, 'maxWidth', px)
        child.absMaxH = normalizeSize('absH', child, 'maxHeight', py)
        child.absMinW = normalizeSize('absW', child, 'minWidth', px)
        child.absMinH = normalizeSize('absH', child, 'minHeight', py)
        
        child.absX = parent.absX + p.l + m.l + inset.l - inset.r + (type(propsInset[2]) == 'number' and parent.absW - child.absW - p.l - p.r or 0) 
        child.absY = parent.absY + p.t + m.t + inset.t - inset.b + (type(propsInset[3]) == 'number' and parent.absH - child.absH - p.t - p.b or 0)
    
        -- overflow
        local overflow = normalizeProp(parent.props.overflow, 2, 'visible')
        if (overflow[1] == 'hidden') then
            child.absW = math.min(parent.absW - p.l - p.r, child.absW)
        end
        
        if (overflow[2] == 'hidden') then
            child.absH = math.min(parent.absH - p.t - p.b, child.absH)
        end
    
        -- layout
        parent.highestChildWidth = math.max(parent.highestChildWidth, child.absW)
        parent.highestChildHeight = math.max(parent.highestChildHeight, child.absH)
    
        if (parent.props.width == 'auto' and isPercent(child.props.width)) then
            child.absW = 0
        end
    
        if (parent.props.height == 'auto' and isPercent(child.props.height)) then
            child.absH = 0
        end
    
        if (parent.props.direction == 'row') then
            child.blockBoxX = parent.blockBoxX
            parent.blockBoxX = parent.blockBoxX + child.absW + gap[1]
    
            if (parent.props.width == 'auto') then
                parent.absW = parent.blockBoxX + p.l + p.r - gap[1]
            end
    
            if (parent.props.height == 'auto') then
                parent.absH = parent.highestChildHeight + p.t + p.b
            end
        elseif (parent.props.direction == 'column') then
            child.blockBoxY = parent.blockBoxY
            parent.blockBoxY = parent.blockBoxY + child.absH + gap[2]
            
            if (parent.props.height == 'auto') then
                parent.absH = parent.blockBoxY + p.t + p.b - gap[2]
            end
    
            if (parent.props.width == 'auto') then
                parent.absW = parent.highestChildWidth + p.l + p.r
            end
        end
    
        -- 
         if (parent.props.display == 'block') then
            if (parent.props.wrap == 'nowrap') then
                if (parent.props.direction == 'column') then
                    child.absY = child.absY + child.blockBoxY
                elseif (parent.props.direction == 'row') then
                    child.absX = child.absX + child.blockBoxX
                end
            -- elseif (parentProps.wrap == 'wrap') then
            --     if (parentProps.direction == 'row') then
            --         if (parentElement.absX + element.blockBoxX >= parentElement.absX + parentContent.w) then
            --             box.y = box.y + parent.highestChildHeight
            --         else
            --             box.x = parentElement.absX + element.blockBoxX
            --         end
            --     end
            end
        else
            -- box.x = box.x + props.x
            -- box.y = box.y + props.y
        end

        
    end)

    updateTree(child, child.children)
end

function updateTree(parent, children)
    if (not children) then return end
    if (type(children) == 'string') then return end

    -- local p = normalizeDirectionalProp(parent.props.padding, 0)
    -- parent.absW = parent.absW + p.l + p.r
    -- parent.absH = parent.absH + p.t + p.b
    -- parent.absMinW = parent.absMinW + p.l + p.r
    -- parent.absMinH = parent.absMinH + p.t + p.b

    for _, child in ipairs(children) do
        if (type(child) == 'table') then
            updateNode(parent, child)
        end
    end
end

function render(_root, children)
    _root.children = children
    updateTree(_root, _root.children)
end