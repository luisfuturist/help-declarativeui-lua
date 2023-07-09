local function getBox(element)
    local parent = element.parent
    local props = element.props
    local parentProps = parent and parent.props or nil
    local parentElement = parent and parent or nil
    local display = parent and parentProps.display
    
    local m = normalizeDirectionalProp(props.margin, 0)
    local p = normalizeDirectionalProp(parentProps.padding, 0)
    local propsInset = normalizeProp(props.inset, 4, 'auto')
    local inset = normalizeInset(propsInset)
    local parentContent = {
        w = (parent and parent.absW or 0),
        h = (parent and parent.absH or 0),
    }
    local box = {
        w = element.absW,
        h = element.absH,
        minW = element.absMinW,
        minH = element.absMinH,
        maxW = element.absMaxW,
        maxH = element.absMaxH,
    }

    local overflow = normalizeDirectionalProp(props.overflow, 2, 'visible')
    if (overflow[1] == 'hidden') then
        box.w = parentElement.absW - p.l - p.r
    end
    
    if (overflow[2] == 'hidden') then
        box.h = parentElement.absH - p.t - p.b
    end

    box.x = props.x + parentElement.absX + p.l + m.l + inset.l - inset.r + (type(propsInset[2]) == 'number' and parentContent.w - box.w or 0)
    box.y = props.y + parentElement.absY + p.t + m.t + inset.t - inset.b + (type(propsInset[3]) == 'number' and parentContent.h - box.h or 0)

    if (display == 'block') then
        if (parentProps.wrap == 'nowrap') then
            if (parentProps.direction == 'column') then
                box.y = parentElement.absY + element.blockBoxY
            elseif (parentProps.direction == 'row') then
                box.x = parentElement.absX + element.blockBoxX
            end
        elseif (parentProps.wrap == 'wrap') then
            if (parentProps.direction == 'row') then
                if (parentElement.absX + element.blockBoxX >= parentElement.absX + parentContent.w) then
                    box.y = box.y + parent.highestChildHeight
                else
                    box.x = parentElement.absX + element.blockBoxX
                end
            end
        end
    end

    return box.x, box.y, box.w, box.h
end

drawers = {
    ['rect'] = function(element)
        local x, y, w, h = getBox(element)
        local color = element.props.color
        local opacity = element.props.opacity or 1
        local alpha = color[4] and color[4] * opacity or opacity

        dxDrawRectangle(
            x, y, w, h,
            rgba(
                color[1],
                color[2],
                color[3],
                alpha
            )
        )
    end,
    ['text'] = function(element)
        local x, y, w, h = getBox(element)
        local color = element.props.color
        local opacity = element.props.opacity or 1
        local alpha = color[4] and color[4] * opacity or opacity

        dxDrawText(
            element.children[1],
            x, y, w, h,
            rgba(
                color[1],
                color[2],
                color[3],
                alpha
            ),
            1, element.props.font, element.props.alignX, element.props.alignY,
            element.props.clip, element.props.wordBreak, element.props.postGUI,
            element.props.colorCoded, element.props.subPixelPositioning,
            element.props.fRotation, element.props.fRotationCenterX, element.props.fRotationCenterY
        )
    end,
    ['image'] = function(element)
        local color = element.props.color
        local alpha = element.props.alpha or 1

        dxDrawImage(
            element.props.x,
            element.props.y,
            element.props.width,
            element.props.height,
            element.props.path,
            element.props.rotation,
            element.props.rotationCenterOffsetX,
            element.props.rotationCenterOffsetY,
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