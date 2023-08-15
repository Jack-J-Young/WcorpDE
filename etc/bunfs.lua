-- Load the http API
if not http then
    print("The http API is not available.")
    return
end

-- Define the TypeScript API URL
local apiBaseUrl = "http://localhost:3000"; -- Replace with the actual API base URL

-- Function to explore the directories and save files
local function exploreDirectoriesAndSaveFiles(node, currentPath)
    if not node then
        return
    end

    for _, childNode in ipairs(node.children or {}) do
        local newPath = currentPath .. "/" .. childNode.name
        if childNode.isDirectory then
            exploreDirectoriesAndSaveFiles(childNode, newPath)
        elseif string.sub(childNode.name, 1, 1) == "f" then
            local fileContentResponse = http.get(apiBaseUrl .. newPath)
            if fileContentResponse then
                local fileContent = fileContentResponse.readAll()
                fileContentResponse.close()

                local file = fs.open(childNode.name, "w")
                file.write(fileContent)
                file.close()

                print("Saved file: " .. childNode.name)
            else
                print("Failed to fetch file content from " .. newPath)
            end
        end
    end
end

-- Initialize the exploration from the root
local rootNode = {}  -- Replace with your actual root node
local rootPath = ""  -- Replace with your actual root path
exploreDirectoriesAndSaveFiles(rootNode, rootPath)
