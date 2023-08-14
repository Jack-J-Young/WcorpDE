local updateUrl = "https://raw.githubusercontent.com/Jack-J-Young/WcorpDE/master/boot/update.lua"
local updatePath = "/boot/update.lua"
local startupPath = "/boot/startup"
local updateScriptLine = 'shell.run("/boot/update.lua")'

-- Delete existing update script
if fs.exists(updatePath) then
    fs.delete(updatePath)
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

-- Read the existing startup content
local existingContent = ""
if fs.exists(startupPath) then
    local file = fs.open(startupPath, "r")
    existingContent = file.readAll()
    file.close()
end

-- Add the update script line to the startup content
local newContent = existingContent .. "\n" .. updateScriptLine

-- Write the updated content back to the startup file
local file = fs.open(startupPath, "w")
file.write(newContent)
file.close()

print("Added update script to startup.")

-- Run the downloaded update script
shell.run(updatePath)