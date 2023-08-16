local graphicsLib = require("graphics")
local Graphical = require("graphical")
local Sprite = require("sprite")

ProgramManager = {}
ProgramManager.__index = ProgramManager

function printObjectFunctions(obj)
    local mt = getmetatable(obj)
    
    if mt and type(mt) == "table" then
        for key, value in pairs(mt) do
            if type(value) == "function" then
                print(key)
            end
        end
    end
end

function ProgramManager:new(monitor)
    local self = setmetatable({}, ProgramManager)
    self.programs = {}
    
    self.monitor = monitor  -- Set the default monitor object
    self.backgroundSprite = Sprite:new(monitor.getSize())
    --self.backgroundSprite:fillWithPixelString('0f-')
    return self
end

function ProgramManager:addProgram(program, x, y)
    table.insert(self.programs, { program = program, x = x, y = y })
end

function ProgramManager:run()
    --local monitor = peripheral.find("monitor")
    local threads = {}  -- Table to store the threads
    local spriteList = {}  -- Table to store individual sprites

    table.insert(spriteList, {self.backgroundSprite, 1, 1})
    for _, entry in ipairs(self.programs) do
        local program = entry.program
        local x = entry.x
        local y = entry.y

        if type(program.run) == "function" then
            local thread = coroutine.create(function()
                program:run()
            end)
            table.insert(threads, thread)
        end

        if type(program.onDraw) == "function" then
            local thread = coroutine.create(function()
                program:onDraw()

                -- Create a single-pixel row sprite and add it to the sprite list
                local barSprite = Sprite:new(program.sprite.width, 1)
                barSprite:setPixel(1, 1, "4", "0", "x")  -- Set a single-pixel at position 1, 1
                barSprite:setPixel(2, 1, "6", "0", "-")  -- Set a single-pixel at position 2, 1
                barSprite:drawLine(3, 1, program.sprite.width - 2, "8", "0", " ")  -- Draw a line using custom color
                table.insert(spriteList, {barSprite, x, y})  -- Place it at the same position
                table.insert(spriteList, {program.sprite, x, y + 1})
            end)
            table.insert(threads, thread)
        end
    end

    -- Resume all the threads
    for _, thread in ipairs(threads) do
        coroutine.resume(thread)
    end

    -- Stack and combine all sprites in the sprite list
    local finalSprite = Sprite.stackSprites(spriteList)

    -- Convert the final sprite to an image string
    local imageString = finalSprite:toImageString()

    -- Use the graphics library to draw the imageString on the monitor
    graphicsLib.writePixelsToMonitor({}, self.monitor, imageString)
end



return ProgramManager
