Program = {}
Program.__index = Program

function Program:new()
    local instance = {}
    setmetatable(instance, {__index = self})
    return instance
end

function Program:run()
    print('uninp')
end

return Program