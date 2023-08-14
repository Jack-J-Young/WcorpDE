local githubRepoUrl = "https://api.github.com/repos/Jack-J-Young/WcorpDE/contents/"
local localPath = "/path/to/local/folder/"

-- Function to download a file from a URL
local function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        return true
    else
        print("Failed to download file from " .. url)
        return false
    end
end

-- Function to download all files from a GitHub repository
local function downloadRepositoryFiles(repoUrl, localDir)
    local response = http.get(repoUrl)
    if response then
        local contents = response.readAll()
        response.close()

        local fileList = textutils.unserializeJSON(contents)
        if fileList and type(fileList) == "table" then
            for _, fileData in ipairs(fileList) do
                local fileType = fileData.type
                local fileName = fileData.name
                local fileUrl = fileData.download_url

                local localFilePath = fs.combine(localDir, fileName)
                downloadFile(fileUrl, localFilePath)
                print("Downloaded: " .. fileName)
            end
            return true
        end
    end
    return false
end

-- Download the repository files
print("Downloading repository files from GitHub...")
if downloadRepositoryFiles(githubRepoUrl, localPath) then
    print("Repository files downloaded successfully!")
else
    print("Failed to download repository files.")
end
