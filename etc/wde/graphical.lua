-- Import the necessary libraries
local Program = require("wizsys.program")
local Sprite = require("sprite")
local graphicsLib = require("graphics")

Graphical = setmetatable({}, {
    __index = function(self, key)
        return rawget(Graphical, key) or rawget(Program, key)
    end
})

function Graphical:new(onRun, onDraw)
    local instance = Program:new(onRun)
    instance.onDraw = onDraw
    instance.sprite = Sprite:new(0, 0)  -- Initialize an empty sprite
    return setmetatable(instance, { __index = Graphical })
end

function Graphical:drawSprite(monitor)
    if self.sprite then
        self.sprite:draw(monitor)
    end
end

return Graphical
