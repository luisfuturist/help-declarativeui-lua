local function normalizeInset(_inset)
    local inset = { _inset[1], _inset[2], _inset[3], _inset[4] }
    inset[1] = type(_inset[1]) == 'string' and 0 or _inset[1]
    inset[2] = type(_inset[2]) == 'string' and 0 or _inset[2]
    inset[3] = type(_inset[3]) == 'string' and 0 or _inset[3]
    inset[4] = type(_inset[4]) == 'string' and 0 or _inset[4]
    return inset
end

local function getBox(element)
    local parent = element.parent
    local props = element.props
    
    local paddingR = parent and parent.props.padding[2] or 0
    local paddingB = parent and parent.props.padding[3] or 0
    local x = parent and props.absX + parent.props.padding[4] or props.x
    local y = parent and props.absY + parent.props.padding[1] or props.y
    local maxW = parent and parent.props.absW - parent.props.padding[2] - parent.props.padding[4] or props.width
    local maxH = parent and parent.props.absH - parent.props.padding[1] - parent.props.padding[3] or props.height
    local w = (props.overflow[1] == 'visible') and (props.absW - (props.absW > maxW and paddingR or 0)) or ((props.absW > maxW and maxW ~= nil) and maxW or props.absW)
    local h = (props.overflow[2] == 'visible') and (props.absH - (props.absH > maxH and paddingB or 0)) or ((props.absH > maxH and maxH ~= nil) and maxH or props.absH)
    local inset_ = normalizeInset(props.inset)
    local newX = x + inset_[4] + (-inset_[2] + (type(props.inset[2]) ~= 'string' and maxW - w or 0))
    local newY = y + inset_[1] + (-inset_[3] + (type(props.inset[3]) ~= 'string' and maxH - h or 0))

    return newX, newY, w, h
end

drawers = {
    ['rect'] = function(element)
        local color = unwrap(element.props.color)
        local alpha = unwrap(element.props.alpha, 1)
        local x, y, w, h = getBox(element)

        if (element.events and element.events.mouseIn) then
            if (isMouseInPosition(x, y, w, h)) then
                element.events.mouseIn({ target = element })
            else
                if (element.events and element.events.mouseOut) then
                    element.events.mouseOut({ target = element })
                end
            end
        end

        dxDrawRectangle(
            x, y, w, h,
            rgba(
                color[1],
                color[2],
                color[3],
                color[4] or alpha
            )
        )
    end,
    ['text'] = function(element)
        local color = unwrap(element.props.color)
        local alpha = unwrap(element.props.alpha, 1)
        local x, y, w, h = getBox(element)

        dxDrawText(
            element.children,
            x, y, w, h,
            rgba(
                color[1],
                color[2],
                color[3],
                color[4] or alpha
            ),
            1, element.props.font, element.props.alignX, element.props.alignY,
            element.props.clip, element.props.wordBreak, element.props.postGUI,
            element.props.colorCoded, element.props.subPixelPositioning,
            element.props.fRotation, element.props.fRotationCenterX, element.props.fRotationCenterY
        )
    end,
    ['image'] = function(element)
        local color = unwrap(element.props.color)
        local alpha = unwrap(element.props.alpha, 1)

        dxDrawImage(
            unwrap(element.props.x),
            unwrap(element.props.y),
            unwrap(element.props.width),
            unwrap(element.props.height),
            element.props.path,
            unwrap(element.props.rotation),
            unwrap(element.props.rotationCenterOffsetX),
            unwrap(element.props.rotationCenterOffsetY),
            rgba(
                color[1],
                color[2],
                color[3],
                color[4] or alpha
            ),
            element.props.postGUI
        )
    end
}
