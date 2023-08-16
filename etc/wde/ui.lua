-- ui.lua

local UI = {}

function UI.addButton(sprite, x, y, label, bgColor, fgColor)
    -- Implement the addButton logic here
    sprite:addString(x, y, label, bgColor, fgColor)
    -- Add any additional logic
end

function UI.fillWithPixelString(sprite, str)
    -- Implement the addButton logic here
    sprite:fillWithPixelString(str)
    -- Add any additional logic
end

-- Add more UI methods here

return UI
