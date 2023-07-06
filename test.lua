local _root = getScreen()

local function useHover(ref)
    local isHovered = signal(false)

    effect(function()
        local element = ref.get()
        if (element) then
            element.addEventListener('mouseIn', function(e)
                isHovered.set(true)
            end)
        
            element.addEventListener('mouseOut', function(e)
                isHovered.set(false)
            end)
        end
    end)

    return isHovered
end

local function MyButton()
    local ref = signal(nil)
    local isHovered = useHover(ref)

    return Button({
        x = signal(700),
        y = 280,
        width = 200,
        height = 200,
        color = function()
            return isHovered.get() and { 255, 255, 0, 1 } or { 255, 255, 255, 1 }
        end,
        ref = ref,
        on = {
            click = function(e)
                if (e[2] == 'down') then
                    local props = e.target.props
                    props.x.set(props.x.get() + 20)
                end
            end
        }
    })
end

local function component(...)
    return Fragment({
        MyButton(),
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