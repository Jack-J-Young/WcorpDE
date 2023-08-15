package.path = package.path .. ";../?.lua"

local Program = require("wizsys.program")
local Graphical = require("graphical")
local ProgramManager = require("programManager")

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
local graphical = Graphical:new(onRunProgram, onDrawGraphical)

-- Create an instance of ProgramManager and add programs to it
local programManager = ProgramManager:new()
programManager:addProgram(program)
programManager:addProgram(graphical)

-- Run the ProgramManager in a loop
while true do
    programManager:run()
    sleep(1)  -- Adjust the delay as needed
end
