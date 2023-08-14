local githubRepoUrl = "https://api.github.com/repos/Jack-J-Young/WcorpDE/contents/"
local localDir = "/"

-- Function to download a file from a URL
local function downloadFile(url, path)
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

                if fileType == "file" then
                    downloadFile(fileUrl, localFilePath)
                elseif fileType == "dir" then
                    fs.makeDir(localFilePath)
                    downloadRepositoryFiles(fileUrl, localFilePath)
                end
            end
        else
            print("Failed to parse repository contents JSON.")
        end
    else
        print("Failed to fetch repository contents from " .. repoUrl)
    end
end

-- Download the repository files
print("Downloading repository files from GitHub...")
downloadRepositoryFiles(githubRepoUrl, localDir)
print("Repository files downloaded to root.")
