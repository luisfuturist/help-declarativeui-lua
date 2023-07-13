-- local _root = getScreen()

-- local function CounterClicks()
--     local count = signal(0)
--     local color = signal({ 255, 255, 255 })
--     return Text({
--         x = _root.props.width / 2,
--         y = _root.props.height / 2,
--         color = color,
--         on = {
--             mouseReleased = function()
--                 count.set(count.get() + 1)
--             end,

--             hover = function(e)
--                 color.set(e.data.state == 'in' and { 255, 0, 0 } or { 255, 255, 255 })
--             end
--         },
--     }, function() return 'You clicked ' .. count.get() .. ' times' end)
-- end

-- render(_root, { CounterClicks() })