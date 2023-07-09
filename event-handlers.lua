eventHandlers = {
    mousePressed = function(element, callback)
        addEventHandler('onClientClick', root, function(...)
            local parameters = {...}
            if (isMouseInPosition(
                element.props.x,
                element.props.y,
                element.props.width,
                element.props.height
            ) and parameters[2] == 'down') then
                callback({ target = element, data = eventParameters['onClientClick'](...) })
            end
        end)
    end,

    mouseReleased = function(element, callback)
        addEventHandler('onClientClick', root, function(...)
            local parameters = {...}
            if (isMouseInPosition(
                element.props.x,
                element.props.y,
                element.props.width,
                element.props.height
            ) and parameters[2] == 'up') then
                callback({ target = element, data = eventParameters['onClientClick'](...) })
            end
        end)
    end,

    created = function(element, callback)
        callback({ target = element })
    end,
}