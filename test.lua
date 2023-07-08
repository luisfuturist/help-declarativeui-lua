local _root = getScreen()

local function App()
    local ref = signal(nil)
    local isHovered = useHover(ref)
    local y = signal(_root.props.height / 2)

    local x = memo(function()
        return isHovered.get() and _root.props.width / 2 - 50 or _root.props.width / 2
    end)

    return Rect({
        x = x,
        y = function()
            return isHovered.get() and y.get() or _root.props.height / 2 - 50
        end,
        width = 300,
        height = 300,
        color = function()
            return isHovered.get() and { 255, 0, 0 } or { 0, 0, 0 }
        end,
        opacity = function()
            return isHovered.get() and 0.5 or 1
        end,
        ref = ref,
        display = 'block',
        -- gap = 0,
        direction = 'row',
        wrap = 'wrap',
        padding = function()
            return isHovered.get() and 20 or 50
        end,
    }, {
        Rect({
            x = function()
                return 0
            end,
            y = function()
                return 0
            end,
            width = 100,
            height = 50,
            color = { 255, 255, 0 }
        }),
        Rect({
                        x = function()
                return 0
            end,
            y = function()
                return 0
            end,
            width = 150,
            height = 25,
            color = { 255, 0, 0, 0.5 }
        }),
        Rect({
                        x = function()
                return 0
            end,
            y = function()
                return 0
            end,
            width = 150,
            height = 75,
            color = { 255, 0, 255, 0.5 }
        }),
        Rect({
                        x = function()
                return 0
            end,
            y = function()
                return 0
            end,
            width = 150,
            height = 34,
            color = { 20, 58, 255, 0.5 }
        }),
    })
end

render(_root, {
    App()
})