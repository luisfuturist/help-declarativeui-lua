function rgba(r, g, b, a)
    a = a or 1
    return tocolor(r, g, b, a * 255)
end

function dxDrawLinedRectangle(x, y, width, height, color, _width, postGUI)
    _width = _width or 1
    dxDrawLine(x, y, x + width, y, color, _width, postGUI)                   -- Top
    dxDrawLine(x, y, x, y + height, color, _width, postGUI)
    dxDrawLine(x, y + height, x + width, y + height, color, _width, postGUI) -- Bottom
    return dxDrawLine(x + width, y, x + width, y + height, color, _width, postGUI) -- Right
end

_dxDrawText = dxDrawText
function dxDrawText(t, x, y, r, b, ...)
    return _dxDrawText(t, x, y, r + x, b + y, ...)
end