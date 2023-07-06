local _root = getScreen()

local function component(...)
    return Fragment({
        Button({
            x = signal(200),
            y = 20,
            width = 60,
            height = 60,
            color = color,
            on = {
                click = function(e)
                    if (e.state == 'down') then
                        -- iprint('clicked')
                    end
                end
            }
        }),
        -- Rect({
        --     x = 100,
        --     y = 10,
        --     width = 80,
        --     height = 80,
        --     color = { 
        --         math.random(0, 255),
        --         math.random(0, 255),
        --         math.random(0, 255)
        --     }
        -- })
    })
end

render(_root, {
    component()
})

-- local s = signal(0)
-- local dispose = effect(function()
--     print('first: ', s.get())
-- end)
-- s.set(1)
-- dispose()
-- s.set(2)

-- local m = memo(function()
--     print('memoized', s.get())
--     return math.random(0, 100)
-- end)
-- print(m())
-- s.set(10)
-- print(m())