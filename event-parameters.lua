eventParameters =  {
    ['onClientClick'] = function(...)
        local parameters = {...}
        return {
            button = parameters[1],
            state = parameters[2],
            absoluteX = parameters[3],
            absoluteY = parameters[4],
            worldX = parameters[5],
            worldY = parameters[6],
            worldZ = parameters[7],
            clickedWorld = parameters[8],
        }
    end,
    ['onClientCharacter'] = function(...)
        local parameters = {...}
        return {
            character = parameters[1],
        }
    end,
    ['onClientCursorMove'] = function(...)
        local parameters = {...}
        return {
            cursorX = parameters[1],
            cursorY = parameters[2],
            absoluteX = parameters[3],
            absoluteY = parameters[4],
            worldX = parameters[5],
            worldY = parameters[6],
            worldZ = parameters[7],
        }
    end,
    ['onClientDoubleClick'] = function(...)
        local parameters = {...}
        return {
            button = parameters[1],
            absoluteX = parameters[2],
            absoluteY = parameters[3],
            worldX = parameters[4],
            worldY = parameters[5],
            worldZ = parameters[6],
            clickedWorld = parameters[7],
        }
    end,
    ['onClientKey'] = function(...)
        local parameters = {...}
        return {
            button = parameters[1],
            pressOrRelease = parameters[2],
        }
    end,
    ['onClientPaste'] = function(...)
        local parameters = {...}
        return {
            clipboardText = parameters[1]
        }
    end,
}