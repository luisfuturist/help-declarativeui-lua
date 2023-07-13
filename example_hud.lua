local _root = getScreen()

local hp = signal(0)
local sd = signal(0)

local function Bar(props)
    return Fragment({

    })
end
-- Rect({
--     x = 50,
--     y = 50,
--     width = 'auto',
--     height = 'auto',
--     color = { 255, 255, 255 },
--     padding = 10,
--     display = 'block',
--     direction = 'column',
--     wrap = 'nowrap',
-- }, {
--     Rect({
--         width = 150,
--         height = 20,
--         color = { 255, 0, 0 },
--     }),
--     Rect({
--         width = 150,
--         height = 50,
--         color = { 0, 255, 0 },
--     }),
--     Rect({
--         width = 150,
--         height = 75,
--         color = { 0, 0, 255 },
--     }),
--     Rect({
--         width = 150,
--         height = 35,
--         color = { 255, 255, 0 },
--     }),
-- })
render(_root, {
    Rect({
        x = 50,
        y = 50,
        width = 'auto',
        height = 'auto',
        opacity = 0,
        padding = 10,
        display = 'block',
        direction = 'column',
        wrap = 'nowrap',
    }, {
        -- Bar({
        --     signal = hp,
        --     color = { 0, 0, 255, 0.5 },
        --     onRender = function()
        --         hp.set(getElementHealth(localPlayer))
        --     end
        -- }),
        -- Bar({
        --     signal = sd,
        --     color = { 255, 0, 0, 0.5 },
        --     onRender = function()
        --         sd.set(getPedArmor(localPlayer))
        --     end 
        -- })
        Rect({
            width = 200,
            height = 20,
            color = { 0, 0, 0, 0.5 },
        }),
        Rect({
            width = function()
                return (200 / 100) * hp.get()
            end,
            height = 20,
            color = { 0, 0, 255, 0.5 },
            on = {
                render = function(e)
                    hp.set(getElementHealth(localPlayer))
                end
            }
        }),
        Rect({
            width = 200,
            height = 20,
            color = { 0, 0, 0, 0.5 },
        }),
        Rect({
            width = function()
                return (200 / 100) * hp.get()
            end,
            height = 20,
            color = { 0, 0, 255, 0.5 },
            on = {
                render = function(e)
                    hp.set(getElementHealth(localPlayer))
                end
            }
        })
    })
})