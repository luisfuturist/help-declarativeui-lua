function isMouseInPosition(x, y, w, h)
    if (not mouse.state) then return end
    local mx, my = mouse.x, mouse.y
    return ((mx >= x and mx <= x + w) and (my >= y and my <= y + h))
end
