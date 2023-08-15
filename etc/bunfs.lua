local function processUrl(url, directory)
    local fullUrl = url .. directory:gsub("/", "-")
    print("Processing URL: " .. fullUrl)
    local response = http.get(fullUrl)
    if not response then
        print("Failed to fetch URL: " .. fullUrl)
        return
    end

    local content = response.readAll()
    response.close()

    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line) -- Trim leading/trailing spaces
    end

    local firstLine = lines[1]
    print("First Line:", firstLine)

    if firstLine:sub(1, 1) == "d" then
        for i = 2, #lines do
            local nextDirectoryName = lines[i]
            local nextDirectory = fs.combine(directory, nextDirectoryName)
            print("Entering directory: " .. nextDirectory)
            processUrl(url, nextDirectory)
        end
    elseif firstLine:sub(1, 1) == "f" then
        local fileName = firstLine:sub(3):gsub("/", "-")
        local filePath = fs.combine(directory, fileName)
        local fileContents = table.concat(lines, "\n", 2)
        print("File Name:", fileName)
        print("File Path:", filePath)
        print("File Contents:", fileContents)

        local file = io.open(filePath, "w")
        if file then
            file:write(fileContents)
            file:close()
            print("Downloaded file: " .. filePath)
        else
            print("Failed to write file: " .. filePath)
        end
    end
end

local rootUrl = "http://95.44.132.48:3000/"
processUrl(rootUrl, "")
