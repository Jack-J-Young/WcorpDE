local updateUrl = "https://raw.githubusercontent.com/Jack-J-Young/WcorpDE/master/boot/update.lua"
local updatePath = "/boot/update.lua"
local updateCurrentPath = "/boot/update_current.lua"

-- Function to copy the contents of one file to another using force write
local function copyFileForce(sourcePath, destinationPath)
    local sourceFile = fs.open(sourcePath, "r")
    local destinationFile = fs.open(destinationPath, "a") -- Use "a" mode for force write

    if sourceFile and destinationFile then
        local content = sourceFile.readAll()
        destinationFile.write(content)

        sourceFile.close()
        destinationFile.close()

        print("Forced copied " .. sourcePath .. " to " .. destinationPath)
    else
        print("Failed to force copy " .. sourcePath .. " to " .. destinationPath)
    end
end

-- Download update script
local response = http.get(updateUrl)
if response then
    local content = response.readAll()
    response.close()

    local file = fs.open(updatePath, "w")
    file.write(content)
    file.close()

    print("Downloaded " .. updatePath)
else
    print("Failed to download update script from " .. updateUrl)
end

-- Copy update.lua to update_current.lua using force write
copyFileForce(updatePath, updateCurrentPath)

-- Run the downloaded update script
shell.run(updatePath)
