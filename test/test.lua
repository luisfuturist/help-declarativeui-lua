local _root = getScreen()

local function comp()
    local s = signal(1)

    -- setTimer(function()
    --     s.set(s.get() + 1)
    -- end, 1000, 0)

    return Rect({
        x = function()
            return _root.props.width / 2 - (s.get() * 10)
        end,
        y = _root.props.height / 2,
        width = 200,
        height = 400,
        color = function()
            return s.get() > 1 and { 255, 0, 0 } or { 0, 0, 0 }
        end,
        padding = function ()
            return s.get() > 1 and s.get() * 10 or 0
        end,
        test = s,
    }, {
        Rect({
            x = 0,
            y = 100,
            width = 350,
            height = 20,
        })
    })
end

render(_root, {
    comp()
})