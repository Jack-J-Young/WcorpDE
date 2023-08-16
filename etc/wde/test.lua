package.path = package.path .. ";../?.lua"

local Program = require("wizsys.program")
local Graphical = require("graphical")
local ProgramManager = require("programManager")
local TestApp = require("testapp")

-- Define your program functions
function onRunProgram()
    print("Running the program...")
end

function onDrawGraphical()
    print("Drawing the graphical program...")
    -- Modify the sprite as needed
end

-- Create instances of Program and Graphical
local program = Program:new(onRunProgram)
--local graphical = Graphical:new(onRunProgram, onDrawGraphical)

-- Create an instance of ProgramManager and add programs to it
local monitor = peripheral.find("monitor", function(name, object)
    return object.isRight
end)

local programManager = ProgramManager:new(monitor)
programManager:addProgram(TestApp:new())
--programManager:addProgram(graphical)

-- Run the ProgramManager in a loop

for i = 1, 20 do
    programManager:run()
    sleep(1)  -- Adjust the delay as needed
end

