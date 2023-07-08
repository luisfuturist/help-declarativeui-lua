local _root = getScreen()

local function myButton()
    return Button({
        x = 960,
        y = 280,
        width = 200,
        height = 200,
        color = { 0, 0, 0, 1 },
        padding = { 10, 0, 10, 0 },
    }, {
        Rect({
            x = 0,
            y = 0,
            width = 200,
            height = 200,
            color = { 255, 255, 0, 0.2 },
            overflow = 'hidden',
            -- top, right, bottom, left
            -- inset = { 0, 0, 'auto', 'auto' }
        }),
    })
end

render(_root, { myButton() })