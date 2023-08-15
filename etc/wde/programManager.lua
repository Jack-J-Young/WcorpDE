ProgramManager = {}
ProgramManager.__index = ProgramManager

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
    for _, program in ipairs(self.programs) do
        program:run()

        if program.onDraw then
            program.onDraw()
            program:drawSprite(monitor)  -- Assuming 'monitor' is available
        end
    end
end

return ProgramManager
