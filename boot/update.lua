local githubRepoUrl = "https://api.github.com/repos/Jack-J-Young/WcorpDE/contents/"
local localDir = "/"

local function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        print("Downloaded: " .. path)
    else
        print("Failed to download file from " .. url)
    end
end

local function downloadRepositoryFiles(repoUrl, localDir)
    local response = http.get(repoUrl)
    if response then
        local contents = response.readAll()
        response.close()
        local fileList = textutils.unserializeJSON(contents)
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

print("Downloading repository files from GitHub...")
downloadRepositoryFiles(githubRepoUrl, localDir)
print("Repository files downloaded to root.")