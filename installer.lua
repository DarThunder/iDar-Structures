local idarStructuresUrl = "https://raw.githubusercontent.com/DarThunder/iDar-Structures/refs/heads/main/src/"
local rootInstallDir = "idar-st/"

local function checkInternet()
    local testUrl = "http://www.google.com"
    local response = http.get(testUrl)
    if response then
        response.close()
        print("Internet connection checked.")
        return true
    else
        print("Could not establish internet connection.")
        return false
    end
end

local function ensureDirectory(dir)
    if not fs.exists(dir) then
        fs.makeDir(dir)
        print(string.format("Directory '%s' created.", dir))
    end
end

local function createSubdirectories(path)
    local dirs = {}
    local currentPath = ""

    for dir in string.gmatch(path, "[^/]+") do
        currentPath = currentPath .. dir .. "/"
        if not fs.exists(currentPath) then
            fs.makeDir(currentPath)
            table.insert(dirs, currentPath)
            print(string.format("Directory '%s' created.", currentPath))
        end
    end

    return dirs
end

if not checkInternet() then
    return
end

local modules = {
    "b_tree/init",
    "b_tree/b_tree",
    "b_tree/b_tree_node",
    "heap/init",
    "heap/binary_heap",
}

ensureDirectory(rootInstallDir)

local success = true

print("Downloading iDar-Structures modules...")
for _, currentModule in ipairs(modules) do
    local moduleName = currentModule .. ".lua"
    print(string.format("Trying to install module '%s'", moduleName))
    local url = idarStructuresUrl .. moduleName

    local fullPath = rootInstallDir .. currentModule

    local pathWithoutFile = string.match(fullPath, "(.+)/[^/]+$")

    createSubdirectories(pathWithoutFile)

    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()

        local file = fs.open(fullPath .. ".lua", "w")
        if file then
            file.write(content)
            file.close()
            print(string.format("Module '%s' installed successfully.", moduleName))
        else
            print(string.format("Failed to write module '%s'.", moduleName))
            success = false
        end
    else
        print(string.format("Failed to download '%s'.", moduleName))
        success = false
    end
end

if success then shell.run("rm", "installer.lua") else shell.run("rm", rootInstallDir) end
print(success and "iDar Structures installed correctly" or "Could not install iDar Structures, check your internet connection and try again.")