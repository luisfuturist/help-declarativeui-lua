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

function registerBoxModel(child)
    local parent = child.parent

    local _m = memo(function()
        return normalizeDirectionalProp(getSafeProp(child, 'margin'), 0)
    end)
    local _propsInset = memo(function()
        return normalizeProp(getSafeProp(child, 'inset'), 4, 'auto')
    end)
    local _p = memo(function()
        return normalizeDirectionalProp(getSafeProp(parent, 'padding'), 0)
    end)
    local _parentAbsW = memo(function()
        return getSafeProp(parent, 'absW')
    end)
    local _parentAbsH = memo(function()
        return getSafeProp(parent, 'absH')
    end)
    local _overflow = memo(function()
        return normalizeProp(parent.props.overflow, 2, 'visible')
    end)

    effect(function()
        local m = _m.get()
        local inset = normalizeInset(_propsInset.get())
        local p = _p.get()

        child.absX = parent.absX + getSafeProp(child, 'x', 0)
        child.absX = child.absX + p.l + m.l + inset.l - inset.r + (type(_propsInset.get()[2]) == 'number' and _parentAbsW.get() - child.absW - p.l - p.r or 0)
    end)

    effect(function()
        local m = _m.get()
        local inset = normalizeInset(_propsInset.get())
        local p = _p.get()

        child.absY = parent.absY + getSafeProp(child, 'y', 0)
        child.absY = child.absY + p.t + m.t + inset.t - inset.b + (type(_propsInset.get()[3]) == 'number' and _parentAbsH.get() - child.absH - p.t - p.b or 0)
    end)

    effect(function()
        local p = _p.get()
        local px = p.l + p.r
        child.absW = _normalizeSize(_parentAbsW, child, safeWrap(getSafeProp(child, 'width')), px, 0)
        child.absMaxW = _normalizeSize(_parentAbsW, child, safeWrap(getSafeProp(child, 'maxWidth')), px, 0)
        child.absMinW = _normalizeSize(_parentAbsW, child, safeWrap(getSafeProp(child, 'minWidth')), px, 0)
    end)

    effect(function()
        local p = _p.get()
        local py = p.t + p.b
        child.absH = _normalizeSize(_parentAbsH, child, safeWrap(getSafeProp(child, 'height')), py, 0)
        child.absMaxH = _normalizeSize(_parentAbsH, child, safeWrap(getSafeProp(child, 'maxHeight')), py, 0)
        child.absMinH = _normalizeSize(_parentAbsH, child, safeWrap(getSafeProp(child, 'minHeight')), py, 0)
    end)
    
    effect(function()
        local gap = parent and normalizeProp(parent.props.gap, 2, 0) or { 0, 0 }
        local m = normalizeDirectionalProp(child.props.margin, 0)
        local propsInset = normalizeProp(child.props.inset, 4, 'auto')
        local inset = normalizeInset(propsInset)
        local p = normalizeDirectionalProp(parent.props.padding, 0)
    
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
    
        if (parent.props.display == 'block') then
            if (parent.props.safeWrap == 'nosafeWrap') then
                if (parent.props.direction == 'column') then
                    child.absY = child.absY + child.blockBoxY
                elseif (parent.props.direction == 'row') then
                    child.absX = child.absX + child.blockBoxX
                end
            -- elseif (parentProps.safeWrap == 'safeWrap') then
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
end

function updateNode(parent, child)
    child.parent = parent
    
    for k in pairs(child.signals) do
        local s = signal(child.signals[k])
        effect(function()
            child.props[k] = s.get()
        end)
    end
    
    registerBoxModel(child)
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