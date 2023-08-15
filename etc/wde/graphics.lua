local colorMap = {
    ["0"] = colors.black,
    ["1"] = colors.blue,
    ["2"] = colors.green,
    ["3"] = colors.cyan,
    ["4"] = colors.red,
    ["5"] = colors.purple,
    ["6"] = colors.orange,
    ["7"] = colors.lightGray,
    ["8"] = colors.gray,
    ["9"] = colors.lightBlue,
    ["a"] = colors.lime,
    ["b"] = colors.lightBlue,
    ["c"] = colors.red,
    ["d"] = colors.magenta,
    ["e"] = colors.orange,
    ["f"] = colors.white,
}

local graphics = {}

function graphics.writePixelsToMonitor(monitor, pixelData)
    local width, height = monitor.getSize()
    local yPos = 1

    for line in pixelData:gmatch("[^\r\n]+") do
        if yPos > height then
            break
        end

        local xPos = 1
        for i = 1, math.min(#line, width * 3), 3 do
            local bgColor = line:sub(i, i)
            local fgColor = line:sub(i + 1, i + 1)
            local char = line:sub(i + 2, i + 2)

            monitor.setBackgroundColor(colorMap[bgColor] or colors.black)
            monitor.setTextColor(colorMap[fgColor] or colors.white)
            monitor.setCursorPos(xPos, yPos)
            monitor.write(char)

            xPos = xPos + 1
        end

        yPos = yPos + 1
    end
end

return graphics
