local function getBox(element)
    local parent = element.parent
    local props = element.props
    local parentProps = parent and parent.props or nil
    
    local m = props.margin
    local p = parentProps.padding
    local inset = normalizeInset(props.inset)
    local parentContent = {
        w = (parent and parentProps.absW - p.l - p.r or 0),
        h = (parent and parentProps.absH - p.t - p.b or 0),
    }
    local box = {}
    box.minW = props.absMinW
    box.minH = props.absMinH
    box.maxW = props.absMaxW
    box.maxH = props.absMaxH
    box.w = math.max(math.min(props.absW, box.maxW), box.minW)
    box.h = math.max(math.min(props.absH, box.maxH), box.minH)    
    box.x = props.x + parentProps.absX + p.l + m.l + inset.l - inset.r + (type(props.inset[2]) == 'number' and parentContent.w - box.w or 0)
    box.y = props.y + parentProps.absY + p.t + m.t + inset.t - inset.b + (type(props.inset[3]) == 'number' and parentContent.h - box.h or 0)

    if (props.overflow[1] == 'hidden') then
        box.w = parentProps.absW - p.l
    end
    
    if (props.overflow[2] == 'hidden') then
        box.h = parentProps.absH - p.t
    end
    
    -- local maxW = parent and parent.props.absW - parent.props.padding[2] - parent.props.padding[4] or props.width
    -- local maxH = parent and parent.props.absH - parent.props.padding[1] - parent.props.padding[3] or props.height
    -- local w = (props.overflow[1] == 'visible') and (props.absW - (props.absW > maxW and paddingR or 0)) or ((props.absW > maxW and maxW ~= nil) and maxW or props.absW)
    -- local h = (props.overflow[2] == 'visible') and (props.absH - (props.absH > maxH and paddingB or 0)) or ((props.absH > maxH and maxH ~= nil) and maxH or props.absH)

    -- overflow: visible, hidden, scroll

    return box.x, box.y, box.w, box.h
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