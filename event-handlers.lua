eventHandlers = {
    mousePressed = function(element, callback)
        addEventHandler('onClientClick', root, function(...)
            local parameters = { ... }
            if (isMouseOverElement(element) and parameters[2] == 'down') then
                callback({ target = element, data = eventParameters['onClientClick'](...) })
            end
        end)
    end,

    mouseReleased = function(element, callback)
        addEventHandler('onClientClick', root, function(...)
            local parameters = { ... }
            if (isMouseOverElement(element) and parameters[2] == 'up') then
                callback({ target = element, data = eventParameters['onClientClick'](...) })
            end
        end)
    end,

    created = function(element, callback)
        callback({ target = element })
    end,

    playerDamage = function(element, callback)
        addEventHandler('onClientPedDamage', root, function(...)
            local parameters = { ... }
            local updatedLife = getElementHealth(source) - parameters[4]
            iprint(updatedLife)
            -- callback({ target = element , data = { newLife =  }})
        end)
    end
}
