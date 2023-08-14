local updateUrl = "https://raw.githubusercontent.com/Jack-J-Young/WcorpDE/master/boot/update.lua"
local updatePath = "/boot/update.lua"

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

-- Run the downloaded update script
shell.run(updatePath)
