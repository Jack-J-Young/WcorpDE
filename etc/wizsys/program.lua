Program = {}
Program.__index = Program

function Program:new(onRun)
    local self = setmetatable({}, Program)
    self.onRun = onRun
    return self
end

function Program:run()
    if self.onRun then
        self.onRun()
    end
end

return Program