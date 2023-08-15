local Graphical = require("graphical")  -- Update the path accordingly

local TestApp = setmetatable({}, {
    __index = function(self, key)
        local value = rawget(TestApp, key) or rawget(Graphical, key)
        if value == nil and self._parent then
            return self._parent[key]
        end
        return value
    end
})

function TestApp:new()
    local instance = Graphical:new()
    setmetatable(instance, { __index = TestApp })  -- Apply the TestApp metatable
    instance.sprite = Sprite:new(10, 10)  -- Initialize sprite with size 10x10
    return instance
end

-- Override the run method
function TestApp:run()
    print("TestApp is running")
end

-- Override the onDraw method
function TestApp:onDraw()
    print("TestApp is drawing")
    print(self)
    self:fillSprite("123")
    -- You can implement your custom drawing logic here
end

return TestApp
