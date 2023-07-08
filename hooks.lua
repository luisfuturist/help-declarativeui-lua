function useHover(ref)
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