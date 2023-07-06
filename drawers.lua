-- local x = parent and attb.absX + parent.padding[4] or attb.x
-- local y = parent and attb.absY + parent.padding[1] or attb.y

-- local newX = x + inset_[4] + (-inset_[2] + (type(attb.inset[2]) ~= 'string' and (maxW - attb.absW) or 0))
-- local newY = y + inset_[1] + (-inset_[3] + (type(attb.inset[3]) ~= 'string' and (maxH - attb.absH) or 0))

local function getBox(element)
    local parent = element.parent
    local props = element.props
    local x = parent and props.absX + parent.props.padding[4] or props.x
    local y = parent and props.absY + parent.props.padding[1] or props.y

    return x, y
end

drawers = {
    ['rect'] = function(element)
        local color = unwrap(element.props.color)
        local alpha = unwrap(element.props.alpha, 1)

        if (isMouseInPosition(
            unwrap(element.props.x),
            unwrap(element.props.y),
            unwrap(element.props.width),
            unwrap(element.props.height)
        )) then
            if (element.props.on and element.props.on.mouseIn) then
                element.props.on.mouseIn({ target = element })
            end
        else
            if (element.props.on and element.props.on.mouseOut) then
                element.props.on.mouseOut({ target = element })
            end
        end
        local x, y = getBox(element)

        dxDrawRectangle(
            x,
            y,
            unwrap(element.props.width),
            unwrap(element.props.height),
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
        local x, y = getBox(element)
        iprint(element)
        dxDrawText(
            element.children,
            x,
            y,
            unwrap(element.props.width),
            unwrap(element.props.height),
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
