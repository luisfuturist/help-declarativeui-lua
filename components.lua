local screenWidth, screenHeight = guiGetScreenSize()

function Screen(children)
    return h('screen', {
        x = 0,
        y = 0,
        width = screenWidth,
        height = screenHeight,
        path = ''
    }, children)
end

function Rect(props, children)
    props.color = props.color or { 255, 255, 255, 1 }
    props.border = props.border or 1

    return h('rect', props, children)
end

function Text(props, children)
    props.color = props.color or { 255, 255, 255, 1 }
    props.font = props.font or 'default'
    props.alignX = props.alignX or 'left'
    props.alignY = props.alignY or 'top'
    props.clip = props.clip or false
    props.wordBreak = props.wordBreak or false
    props.postGUI = props.postGUI or false
    props.colorCoded = props.colorCoded or false
    props.subPixelPositioning = props.subPixelPositioning or false
    props.fRotation = props.fRotation or 0
    props.fRotationCenterX = props.fRotationCenterX or 0
    props.fRotationCenterY = props.fRotationCenterY or 0

    local textWidth, textHeight = dxGetTextSize(children, 0, 1, props.font, props.wordBreak, props.colorCoded)
    props.width = props.width or textWidth
    props.height = props.height or textHeight

    return h('text', props, children)
end

function Image(props, children)
    if (children) then error('Image cannot have children', 2) end
    if (not props.path) then error('Image path is required', 2) end

    props.color = props.color or { 255, 255, 255, 1 }
    props.rotation = props.rotation or 0
    props.rotationCenterOffsetX = props.rotationCenterOffsetX or 0
    props.rotationCenterOffsetY = props.rotationCenterOffsetY or 0
    props.postGUI = props.postGUI or false

    return h('image', props, children)
end

function Button(props, children)
    return Rect(props, children)
end

function Fragment(children)
    return h('fragment', {}, children)
end