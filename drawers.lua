drawers = {
    ['rect'] = function(element)
        local color = element.props.color
        local opacity = element.props.opacity or 1
        local alpha = color[4] and color[4] * opacity or opacity

        dxDrawRectangle(
            element.absX, element.absY, element.absW, element.absH,
            rgba(
                color[1],
                color[2],
                color[3],
                alpha
            )
        )
    end,
    ['text'] = function(element)
        local color = element.props.color
        local opacity = element.props.opacity or 1
        local alpha = color[4] and color[4] * opacity or opacity

        dxDrawText(
            element.children[1],
            element.absX, element.absY, element.absW, element.absH,
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
        local opacity = element.props.opacity or 1
        local alpha = color[4] and color[4] * opacity or opacity

        dxDrawImage(
            element.absX,
            element.absY,
            element.absW,
            element.absH,
            element.props.path,
            element.props.rotation,
            element.props.rotationCenterOffsetX,
            element.props.rotationCenterOffsetY,
            rgba(
                color[1],
                color[2],
                color[3],
                alpha
            ),
            element.props.postGUI
        )
    end
}