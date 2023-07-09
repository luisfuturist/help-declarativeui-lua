local _root = getScreen()

local function Counter()
    local count = signal(0)
    local color = signal({ 255, 255, 255 })
    
    setTimer(function()
        count.set(count.get() + 1)
    end, 1000, 0)

    return Rect({
        x = 20,
        y = 20,
        width = 100,
        height = 100,
        color = { 0, 0, 0 }
    }, {
        Rect({
            x = 10,
            y = 10,
            width = 20,
            height = 20,
            color = { 255, 0, 255 }
        }),
        function()
            if (count.get() > 2) then
                return Text({
                    color = color,
                    on = {
                        created = function()
                        end
                    },
                }, function() return 'You clicked ' .. count.get() .. ' times' end)
            else
                return Text({
                    color = { 255, 0, 0 },
                    on = {
                        mouseReleased = function(e)
                            count.set(count.get() + 1)
                        end,
                    },
                }, function() return 'Click me' end)
            end
        end
    })
end

render(_root, { Counter() })

