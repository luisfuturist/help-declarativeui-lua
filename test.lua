local _root = getScreen()

render(_root, {
    Button({
        x = 960,
        y = 280,
        width = 200,
        height = 200,
        color = { 0, 0, 0, 1 },
        padding = 20,
    }, {
        Rect({
            x = 0,
            y = 0,
            width = '150%',
            height = '150%',
            color = { 255, 0, 0, 0.2 },
            overflow = { 'visible', 'hidden' },
            -- top, right, bottom, left
            -- inset = { 0, 0, 'auto', 'auto' }
        }),
    })
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