local graphicsLib = require("graphics")
local Graphical = require("graphical")

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
    return self
end

function ProgramManager:addProgram(program)
    table.insert(self.programs, program)
end

function ProgramManager:run()


    local monitor = peripheral.find("monitor")

    for a, program in ipairs(self.programs) do
        if type(program.run) == "function" then
            program:run()
        end

        
        
        if type(program.onDraw) == "function" then
            program:onDraw()
            -- Convert the sprite to an image string
            local imageString = program.sprite:toImageString()

            -- Use the graphics library to draw the imageString on the monitor
            
            graphicsLib.writePixelsToMonitor({}, monitor, imageString)
        end
    end
end

return ProgramManager