local _root = getScreen()

local function useHover(ref)
    local isHovered = signal(false)

    effect(function()
        local element = ref.get()
        if (element) then
            element.addEventListener('mouseIn', function()
                isHovered.set(true)
            end)
            element.addEventListener('mouseOut', function()
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
        x = 960,
        y = 280,
        width = 200,
        height = 200,
        color = function()
            return isHovered.get() and { 255, 0, 0, } or { 0, 0, 0 }
        end,
        padding = 10,
        ref = ref
    }, {
        Rect({
            x = 0,
            y = 0,
            width = '20%',
            height = '20%',
            maxWidth = 200,
            maxHeight = 200,
            overflow = 'hidden',
            color = { 255, 255, 0 },
            -- trbl
            inset = { 0, 0, 'auto', 'auto' }
        })
    })
end

local function component(...)
    return Fragment({
        MyButton(),
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