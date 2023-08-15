-- Import the necessary libraries
local Program = require("wizsys.program")
local Sprite = require("sprite")
local graphicsLib = require("graphics")

-- Create a subclass that extends Program
local Graphical = setmetatable({}, {
    __index = function(self, key)
        return rawget(Graphical, key) or rawget(Program, key)
    end
})

-- Override the onDraw method
function Graphical:onDraw()
    -- Implement your custom drawing logic here
    -- Example: Filling the sprite with a specific pixel type "123"
    local pixelType = "123"
    for y = 1, self.sprite.height do
        for x = 1, self.sprite.width do
            self.sprite:setPixel(x, y, pixelType)
        end
    end
end

-- Initialize the sprite variable
function Graphical:new()
    local instance = Program:new()
    instance.sprite = Sprite:new(0, 0)
    return setmetatable(instance, { __index = Graphical })
end

return Graphical
