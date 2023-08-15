local Pixel = require("pixel")

Sprite = {}

function Sprite:new(width, height)
    local newSprite = {
        width = width,
        height = height,
        pixels = {}
    }

    for y = 1, height do
        newSprite.pixels[y] = {}
        for x = 1, width do
            print(colors.black)
            newSprite.pixels[y][x] = Pixel:new(2, 3, " ")
        end
    end

    setmetatable(newSprite, self)
    self.__index = self
    return newSprite
end

function Sprite:setPixel(x, y, bgColor, fgColor, char)
    self.pixels[y][x] = Pixel:new(bgColor, fgColor, char)
end

function Sprite:getPixel(x, y)
    return self.pixels[y][x]
end

function Sprite:fillWithPixelString(pixelString)
    local bgColor = tonumber(pixelString:sub(1, 1))
    local fgColor = tonumber(pixelString:sub(2, 2))
    local char = pixelString:sub(3, 3)

    for y = 1, self.height do
        for x = 1, self.width do
            self.pixels[y][x] = Pixel:new(bgColor, fgColor, char)
        end
    end
end


function Sprite:toImageString()
    local imageString = ""
    
    for y = 1, self.height do
        for x = 1, self.width do
            local pixel = self.pixels[y][x]
            local bgColorCode = string.format("%x", pixel.bgColor)
            local fgColorCode = string.format("%x", pixel.fgColor)
            local char = pixel.char
            
            imageString = imageString .. bgColorCode .. fgColorCode .. char
        end
        
        imageString = imageString .. "\n"
    end
    
    return imageString
end

-- Return the Sprite class
return Sprite
