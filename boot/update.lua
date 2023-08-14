-- Define the GitHub repository URL and local directory
local githubRepoUrl = "https://api.github.com/repos/owner/repo/contents/"  -- Replace with the repository URL
local localDir = "/"  -- Replace with the desired local directory

-- Load the http API
if not http then
    print("The http API is not available.")
    return
end

-- Function to download a file from a URL
local function downloadFile(url, path)
    print("Downloading file from " .. url .. " to " .. path)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()

        local file = fs.open(path, "w")
        file.write(content)
        file.close()

        print("Downloaded: " .. path)
    else
        print("Failed to download file from " .. url)
    end
end

-- Function to download repository files recursively
local function downloadRepositoryFiles(repoUrl, localDir)
    print("Fetching repository contents from " .. repoUrl)
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

                print("fileType:", fileType)
                print("fileName:", fileName)
                print("fileUrl:", fileUrl)
                print("localFilePath:", localFilePath)

                if fileType == "file" then
                    downloadFile(githubRepoUrl .. fileData.path, localFilePath)
                elseif fileType == "dir" then
                    print("Creating directory: " .. localFilePath)
                    fs.makeDir(localFilePath)
                    downloadRepositoryFiles(githubRepoUrl .. fileData.path, localFilePath)
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
