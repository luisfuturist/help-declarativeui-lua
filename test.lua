local _root = getScreen()

local function Grid()
    return Rect({
        x = _root.props.width / 2,
        y = _root.props.height / 2,
        width = 300,
        height = 300,
        color = { 0, 0, 0 },
        minWidth = 400,
        -- display = 'block',
        -- direction = 'column',
        -- wrap = 'nowrap',
        padding = 10
    }, {
        Rect({
            width = 200,
            height = '100%',
            color = { 255, 0, 0, 0.2 }
        }),
        -- Rect({
        --     width = 150,
        --     height = 35,
        --     color = { 255, 0, 255 }
        -- }),
        -- Rect({
        --     width = 150,
        --     height = 75,
        --     color = { 255, 0, 0 }
        -- }),
        -- Rect({
        --     width = 150,
        --     height = 50,
        --     color = { 0, 255, 0 }
        -- }),
    })
end

render(_root, { Grid() })

