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
            newSprite.pixels[y][x] = Pixel:new("2", "3", " ")
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
    local bgColor = pixelString:sub(1, 1)
    local fgColor = pixelString:sub(2, 2)
    local char = pixelString:sub(3, 3)

    for y = 1, self.height do
        for x = 1, self.width do
            self:setPixel(y, x, bgColor, fgColor, char)
        end
    end
end

function Sprite:addString(x, y, str, bgColor, fgColor)
    for i = 1, #str do
        local char = str:sub(i, i)
        self:setPixel(x + i - 1, y, bgColor, fgColor, char)
    end
end

function Sprite:drawLine(x, y, length, bgColor, fgColor, char)
    for i = 1, length do
        self:setPixel(x + i - 1, y, bgColor, fgColor, char)
    end
end

function Sprite:toImageString()
    local imageString = ""
    
    for y = 1, self.height do
        for x = 1, self.width do
            local pixel = self.pixels[y][x]
            local bgColorCode = pixel.bgColor
            local fgColorCode = pixel.fgColor
            local char = pixel.char
            
            imageString = imageString .. bgColorCode .. fgColorCode .. char
        end
        
        imageString = imageString .. "\n"
    end
    
    return imageString
end

-- Stack multiple sprites at specific positions
function Sprite.stackSprites(spritePositionList)
    local maxWidth = 0
    local maxHeight = 0

    -- Calculate the dimensions of the combined sprite
    for _, entry in ipairs(spritePositionList) do
        local sprite = entry[1]
        local x, y = entry[2], entry[3]
        maxWidth = math.max(maxWidth, sprite.width + x - 1)
        maxHeight = math.max(maxHeight, sprite.height + y - 1)
    end

    -- Create a new sprite to hold the combined result
    local combinedSprite = Sprite:new(maxWidth, maxHeight)

    -- Copy the pixels from each sprite into the combined sprite at their respective positions
    for _, entry in ipairs(spritePositionList) do
        local sprite = entry[1]
        local x, y = entry[2], entry[3]

        for j = 1, sprite.height do
            for k = 1, sprite.width do
                local pixel = sprite:getPixel(k, j)
                local bgColor, fgColor, char = pixel.bgColor, pixel.fgColor, pixel.char
                combinedSprite:setPixel(k + x - 1, (j + y - 1), bgColor, fgColor, char)
            end
        end
    end

    return combinedSprite
end

return Sprite
