-- pixel.lua

Pixel = {}

function Pixel:new(bgColor, fgColor, char)
    local newPixel = {
        bgColor = bgColor,
        fgColor = fgColor,
        char = char
    }
    setmetatable(newPixel, self)
    self.__index = self
    return newPixel
end

return Pixel