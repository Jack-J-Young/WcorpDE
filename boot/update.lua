-- Define the GitHub repository URL and local directory
local githubRepoUrl = "https://api.github.com/repos/Jack-J-Young/WcorpDE/contents/"
local localDir = "/"  -- Replace with the desired local directory

-- Check for verbose and debug arguments
local verbose = false
local debug = false
for _, arg in ipairs({...}) do
    if arg == "-v" then
        verbose = true
    elseif arg == "-d" then
        debug = true
    end
end

-- Load the http API
if not http then
    print("The http API is not available.")
    return
end

-- Function to copy the contents of one file to another using force write
local function copyFileForce(sourcePath, destinationPath)
    local sourceFile = fs.open(sourcePath, "r")
    local destinationFile = fs.open(destinationPath, "a") -- Use "a" mode for force write

    if sourceFile and destinationFile then
        local content = sourceFile.readAll()
        destinationFile.write(content)

        sourceFile.close()
        destinationFile.close()

        if verbose then
            print("Forced copied " .. sourcePath .. " to " .. destinationPath)
        end
    else
        print("Failed to force copy " .. sourcePath .. " to " .. destinationPath)
    end
end

-- Function to download a file from a URL
local function downloadFile(url, path)
    if verbose then
        print("Downloading file from " .. url .. " to " .. path)
    end

    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()

        local file = fs.open(path, "w")
        file.write(content)
        file.close()

        if verbose then
            print("Downloaded: " .. path)
        end
    else
        print("Failed to download file from " .. url)
    end
end

-- Function to download repository files recursively
local function downloadRepositoryFiles(repoUrl, localDir)
    if verbose then
        print("Fetching repository contents from " .. repoUrl)
    end

    local response = http.get(repoUrl)
    if response then
        local content = response.readAll()
        response.close()

        local fileList = textutils.unserializeJSON(content)
        if fileList then
            for _, fileData in ipairs(fileList) do
                local fileType = fileData.type
                local fileName = fileData.name
                local fileUrl = fileData.download_url
                local localFilePath = fs.combine(localDir, fileName)

                if debug then
                    print("fileType:", fileType)
                    print("fileName:", fileName)
                    print("fileUrl:", fileUrl)
                    print("localFilePath:", localFilePath)
                    print("fileData.path:", fileData.path)
                end

                if fileType == "file" then
                    downloadFile(fileUrl, localFilePath)
                elseif fileType == "dir" then
                    if verbose then
                        print("Creating directory: " .. localFilePath)
                    end
                    fs.makeDir(localFilePath)
                    local subRepoUrl = githubRepoUrl .. fileData.path .. "/"
                    downloadRepositoryFiles(subRepoUrl, localFilePath)
                end
            end
        else
            print("Failed to parse repository contents JSON.")
        end
    else
        print("Failed to fetch repository contents from " .. repoUrl)
    end
end

-- Installation process
print("Installing repository from GitHub...")

-- Create the local directory if it doesn't exist
if not fs.exists(localDir) then
    fs.makeDir(localDir)
end

-- Download and install repository files
downloadRepositoryFiles(githubRepoUrl, localDir)

print("Installation completed.")
