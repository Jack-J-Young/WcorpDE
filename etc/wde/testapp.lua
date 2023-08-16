local Graphical = require("graphical")  -- Update the path accordingly

local TestApp = setmetatable({}, {
    __index = function(self, key)
        return rawget(TestApp, key) or rawget(Graphical, key)
    end
})

function TestApp:new()
    local instance = Graphical:new()
    setmetatable(instance, { __index = TestApp })
    instance.val = 't'
    instance.sprite = Sprite:new(10, 10)  -- Initialize sprite with size 10x10
    return instance
end

-- Override the run method
function TestApp:run()
    print("TestApp is running")
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+-=[]{}|;:,.<>?/\\\"'"
    -- Generate a random index within the range of the character string
    local randomIndex = math.random(1, #characters)

    -- Get the random character using the index
    self.val = characters:sub(randomIndex, randomIndex)
end

-- Override the onDraw method
function TestApp:onDraw()
    self.sprite:fillWithPixelString("12" .. self.val)
    -- You can implement your custom drawing logic here
end

return TestApp
