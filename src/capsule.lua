-- Credit to zimavi for this package manager, I did not create it.
-- Here is a link to their project:
-- https://forums.computercraft.cc/index.php?topic=652.0

-- code here is just in case capsule downloaded and ran on non diamondos machine
-- this part will check if libs exists, if not, download them

-- Now this is setup to download the files from my Github.
local local_repo = "https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main"

-- Download capsule to the root of the system.so it doesn't require another command.
if not fs.exists("/capsule.lua") then
    shell.run("wget " .. local_repo .. "/capsule.lua" .. "/capsule.lua")
end

-- These below get added when running this
-- wget run https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main/capsule.lua
-- Download source format (from the Github repo): local_repo/lib/file
-- Computer destination format (Path this gets set to in the computer): /lib/

if not fs.exists("/lib/stringbuilder.lua") then
    shell.run("wget "  .. local_repo .. "/lib/" .. "/stringbuilder.lua" .. " /lib/stringbuilder.lua")
end

if not fs.exists("/lib/print-utils.lua") then
    shell.run("wget " .. local_repo .. "/lib/" .. "/print-utils.lua" .. " /lib/print-utils.lua")
end

if not fs.exists("/lib/crypto/sha2.lua") then
    shell.run("wget " .. local_repo .. "/lib/" .. "/crypto/sha2.lua" .. " /lib/crypto/sha2.lua")
end

if not fs.exists("/lib/config.lua") then
    shell.run("wget "  .. local_repo .. "/lib/" .. "/config.lua"  .. " /lib/config.lua")
end

if not fs.exists("/lib/args.lua") then
    shell.run("wget " .. local_repo .. "/lib/" .. "/args.lua" .. " /lib/args.lua")
end

if not fs.exists("/lib/logger.lua") then
    shell.run("wget " .. local_repo .. "/lib/" .. "/logger.lua" .. " /lib/logger.lua")
end

-- New, created by kelson8
-- Monitor util
if not fs.exists("/lib/util/monitor_util.lua") then
    shell.run("wget " .. local_repo .. "/lib" .. "/util/monitor_util.lua" .. " /lib/util/monitor_util.lua")
end

-- Text file util
if not fs.exists("/lib/util/text_util.lua") then
    shell.run("wget " .. local_repo .. "/lib" .. "/util/text_util.lua" .. " /lib/util/text_util.lua")
end

-- Hash util
if not fs.exists("/lib/util/hash_util.lua") then
    shell.run("wget " .. local_repo .. "/lib" .. "/util/hash_util.lua" .. " /lib/util/hash_util.lua")
end
--

-- program itself

local stringBuilder = require("/lib/stringbuilder")
local lib_print = require("/lib/print-utils")
local lib_sha = require("/lib/crypto/sha2")
local lib_config = require("/lib/config")
local lib_args = require("/lib/args")
local logs = require("/lib/logger")

-- here you can check repo structure if you want to repo yourself
--local DEFAULT_REPOSITORY = "https://github.com/zimavi/cc_pacman_api/raw/main/repo.json"
local DEFAULT_REPOSITORY = "https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main/repo.json"

local repo_path = "/etc/capsule/repository.json"
local packages_path = "/etc/capsule/package.list"
local install_path = "/usr/bin/"

-- define version struct
-- Was originally 1.0.0
local version = {
    major = 1,
    minor = 1,
    patch = 0,
}

-- version to string function
local tmp_toString = function (t)
    return string.format("v%s.%s.%s", t.major, t.minor, t.patch)
end

-- Check if the version of software installed is update to date
-- @param repo_ver string? The remote repository version to check for updates from.
-- @param installed_ver string? The installed version to check.
local function isRepoVerNewer(repo_ver, installed_ver)
    if repo_ver.major > installed_ver.major then
        return true
    elseif repo_ver.minor > installed_ver.minor then
        return true
    elseif repo_ver.patch > installed_ver.patch then
        return true
    end

    return false
end

-- Show a list of all available packages from the Capsule repository.
local function showAvailableList()
    if not fs.exists(repo_path) then
        logs.critical("Cannot load repository. (Perhaps time to 'update'?)")
        error("", 0)
    end

    local handle = fs.open(repo_path, "r")
    if not handle then
        logs.critical("Cannot open repository file.")
        error("", 0)
    end

    local text = handle.readAll()

    local repo_table = textutils.unserializeJSON(text, {parse_empty_array = true})
    handle.close()

    if not repo_table then
        logs.critical("Cannot read JSON from repository.")
        error("", 0)
    end

    local sb = stringBuilder()

    for _, v in ipairs(repo_table) do
        local sb2 = stringBuilder()
        local version = v.version.major .. "." .. v.version.minor .. "." .. v.version.patch
        sb:append("- Name: " .. v.name)
        sb:append("  Installed Version: None")
        sb:append("  Repository Version: " .. version)
        sb:append("  Status: Available")
        sb:append(sb2:toString("\n"))
    end

    return sb:toString("\n")
end

-- Show the list of currently installed packages.
local function showInstalledList()
    if not fs.exists(repo_path) then
        logs.critical("Cannot load repository. (Perhaps time to 'update'?)")
        error("", 0)
    end

    local handle = fs.open(repo_path, "r")
    if not handle then
        logs.critical("Cannot open repository file.")
        error("", 0)
    end

    local text = handle.readAll()

    local repo_table = textutils.unserializeJSON(text, {parse_empty_array = true})
    handle.close()

    if not repo_table then
        logs.critical("Cannot read JSON from repository.")
        error("", 0)
    end

    handle = fs.open(packages_path, "r")
    if not handle then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local packages = textutils.unserialize(handle.readAll())

    if not packages then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local sb = stringBuilder()

    for key, package in pairs(packages) do
        for _, v in ipairs(repo_table) do
            if key == v.name then
                local sb2 = stringBuilder()
                local repo_version_str = v.version.major .. "." .. v.version.minor .. "." .. v.version.patch
                local local_version_str = package.version.major .. "." .. package.version.minor .. "." .. package.version.patch
                sb:append("- Name: " .. v.name)
                sb:append("  Installed Version: " .. local_version_str)
                sb:append("  Repository Version: " .. repo_version_str)
                sb:append("  Status: " .. (isRepoVerNewer(v.version, package.version) and "Outdated" or "Up-to-date"))
                sb:append(sb2:toString("\n"))
                break
            end
        end
    end

    return sb:toString("\n")
end

-- Show all packages in the repository.
local function showAllPackages()
    if not fs.exists(repo_path) then
        logs.critical("Cannot load repository. (Perhaps time to 'update'?)")
        error("", 0)
    end

    local handle = fs.open(repo_path, "r")
    if not handle then
        logs.critical("Cannot open repository file.")
        error("", 0)
    end

    local text = handle.readAll()

    local repo_table = textutils.unserializeJSON(text, {parse_empty_array = true})
    handle.close()

    if not repo_table then
        logs.critical("Cannot read JSON from repository.")
        error("", 0)
    end

    handle = fs.open(packages_path, "r")
    if not handle then
        return showAvailableList()
    end
    local packages = textutils.unserialize(handle.readAll())
    handle.close()

    if not packages then            -- return just available if no installed found
        return showAvailableList()
    end

    local sb = stringBuilder()
    local found

    for _, v in ipairs(repo_table) do
        found = false
        for key, package in pairs(packages) do
            if key == v.name then
                found = true
                local sb2 = stringBuilder()
                local repo_version_str = v.version.major .. "." .. v.version.minor .. "." .. v.version.patch
                local local_version_str = package.version.major .. "." .. package.version.minor .. "." .. package.version.patch
                sb:append("- Name: " .. v.name)
                sb:append("  Installed Version: " .. local_version_str)
                sb:append("  Repository Version: " .. repo_version_str)
                sb:append("  Status: " .. (isRepoVerNewer(v.version, package.version) and "Outdated" or "Up-to-date"))
                sb:append(sb2:toString("\n"))
                break
            end
        end

        if not found then
            local sb2 = stringBuilder()
            local repo_version_str = v.version.major .. "." .. v.version.minor .. "." .. v.version.patch
            sb:append("- Name: " .. v.name)
            sb:append("  Installed Version: None")
            sb:append("  Repository Version: " .. repo_version_str)
            sb:append("  Status: Available")
            sb:append(sb2:toString("\n"))
        end
    end

    return sb:toString("\n")
end

-- Display the list with command arguments.
-- Usage: getRepositoryList(--installed, --available, --all)
-- @param params string The package list to check.
local function getRepositoryList(params)
    local installedOnly = params[1]
    local availableOnly = params[2]
    local all = params[3]

    if not installedOnly and not availableOnly and not all then
        availableOnly = true
    end


    if all then
        return showAllPackages()
    elseif availableOnly then
        return showAvailableList()
    elseif installedOnly then
        return showInstalledList()
    end
end

-- Display a list of items in the repository
-- @param repoList string List of repos to display.
local function displayRepositoryList(repoList)
    lib_print.scrollText(repoList, 15)
end

-- Display the help message for Capsule.
local function displayHelpMessage()
    local sb = stringBuilder()
    sb:append("Capsule - CC:Tweaked package manager used by DiamondOS")
    sb:append("Usage: capsule [flags] [options]")
    sb:append("Flags:")
    sb:append("  -h, --help         Display current message")
    sb:append("  -v, --verbose      Show debug messages")
    sb:append("  version            Display current version")
    sb:append("  update             Fetches remote repository")
    sb:append("  list               List through packages available")
    sb:append("  --installed        List only installed packages")
    sb:append("  --available        List only packages from repo (default)")
    sb:append("  --all              List both installed and available")
    sb:append("Options:")
    sb:append("  -r, --repository   Specify repository (used with update)")
    sb:append("  install            Install package from current repository")
    sb:append("  checksum           Write file's checksum to checksum.txt")
    sb:append("  validate           Validates installed package")
    sb:append("  remove             Removes package from system")
    sb:append("  upgrade            Upgrades all out-of-date packages")

    local str = sb:toString("\n")

    lib_print.scrollText(str, 11)
end

-- Update the repository
-- @param repository string The repository to update.
local function updateRepository(repository)
    -- check if no provided repository
    if repository == nil then
        logs.debug("No repository passed, using default.")
        repository = DEFAULT_REPOSITORY
    end

    -- send GET http request
    logs.info("Fetching with " .. repository)
    local request = http.get(repository)
    
    -- if not valid request arrived
    if not request then
        logs.critical("Cannot get response from repository server.")
        return
    end

    -- save repository to memory
    local handle = fs.open(repo_path, "w")

    if not handle then
        logs.error("Cannot save repository.")
    end

    handle.write(request.readAll())

    logs.info("Fetched repository successfully.")
end

-- Install a package
-- @param package_name string The name of the package to install.
local function installPackage(package_name)

    local handle = fs.open(repo_path, "r")
    if not handle then
        logs.critical("Cannot open repository file.")
        error("", 0)
    end
    
    local repo = textutils.unserializeJSON(handle.readAll())
    if not repo then
        logs.critical("Cannot read repository file.")
        error("", 0)
    end

    logs.info("Searching for " .. package_name:lower() .. "...")

    local package = {}

    for i, v in ipairs(repo) do
        if v.name:lower() == package_name:lower() then
            package = v
            logs.info("Found package, downloading...")
            break
        end
    end

    local attempts = 1

    ::redownload::

    if attempts > 4 then
        logs.critical("Unable to download valid file. Try again later.")
        error("", 0)
    end

    local request, error = http.get(package.dwn_lnk)
    if not request then
        logs.critical("Cannot download package.")
        logs.critical(error)
        error("", 0)
    end

    logs.info("Downloaded data, saving...")

    local data = request.readAll()

    local name = package_name:sub(-4) == ".lua" and package_name or package_name .. ".lua"

    logs.info("Validation file integrity...")

    local checksum = lib_sha.sha256(data)

    if checksum ~= package.checksum then
        logs.error("File checksum validation failed: Missmatch")
        logs.info("Going to attempt " .. attempts .. "/3")
        attempts = attempts + 1
        goto redownload
    end

    logs.info("File validated, saving...")

    if lib_config.createIfNotExists(packages_path) then
        local list = {
            [package.name] = {
                version = package.version,
                path = fs.combine(install_path, name),
                author = package.author,
                desc = package.desc,
                dwn_lnk = package.dwn_lnk,
                checksum = package.checksum
            }
        }

        lib_config.save(list, packages_path)
    else
        local list = lib_config.load(packages_path)
        list[package.name] = {
            version = package.version,
            path = fs.combine(install_path, name),
            author = package.author,
            desc = package.desc,
            dwn_lnk = package.dwn_lnk,
            checksum = package.checksum
        }
        lib_config.save(list, packages_path)
    end

    logs.debug("package.list updated")

    local handle = fs.open(fs.combine(install_path, name), "w")
    handle.write(data)
    handle.close()

    logs.info("Package " .. package_name .. " installed successfully")

end

-- Calculate a file checksum.
-- @param path string The file to get the SHA256 checksum for.
-- @return string The SHA256 checksum for the file.
local function calculateChecksum(path)
    if not fs.exists(path) then
        logs.critical("File not found.")
        error("", 0)
    end

    logs.debug("Opening " .. path .. "...")

    local handle = fs.open(path, "r")
    if not handle then
        logs.critical("Cannot open the file.")
        error("", 0)
    end

    local data = handle.readAll()
    handle.close()

    logs.debug("Computing checksum...")

    local checksum = lib_sha.sha256(data)

    logs.info("Done.")
    logs.info("Checksum: " .. checksum)

    logs.debug("Saving...")

    handle = fs.open("checksum.txt", "w")
    handle.write(checksum)
    handle.close()
    
end

-- Redownload a file
-- @param package_url The url of the file.
-- @param package_checksum The SHA256 checksum of the file.
local function redownloadFile(package_url, package_checksum)

    local attempts = 1

    ::redownload1::

    if attempts > 4 then
        logs.critical("Unable to download valid file. Try again later.")
        error("", 0)
    end

    local request, error = http.get(package_url)
    if not request then
        logs.critical("Cannot download package.")
        logs.critical(error)
        error("", 0)
    end

    logs.info("Downloaded data, saving...")

    local data = request.readAll()

    logs.info("Validation file integrity...")

    local checksum = lib_sha.sha256(data)

    if checksum ~= package_checksum then
        logs.error("File checksum validation failed: Missmatch")
        logs.info("Going to attempt " .. attempts .. "/3")
        attempts = attempts + 1
        goto redownload1
    end

    logs.info("File validated, saving...")

    return data
end

-- Validate a package and its SHA256 checksum with the one from the remote repo.json.
-- @param package_name The name of the package to validate.
local function validatePackage(package_name)
    if not fs.exists(packages_path) then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local package_list = lib_config.load(packages_path)

    if not package_list then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local package = package_list[package_name]

    if not package then
        logs.critical("Package is not installed.")
        error("", 0)
    end

    local path = package.path
    local handle = fs.open(path, "r")
    if not handle then
        logs.error("Cannot open file, redownloading it...")
        local data = redownloadFile(package.lnk, package.checksum)
        handle = fs.open(path, "w")
        handle.write(data)
        handle.close()
        logs.info("Done.")
        return
    end

    local data = handle.readAll()
    handle.close()

    local checksum = lib_sha.sha256(data)

    if checksum ~= package.checksum then
        logs.error("File checksum validation failed: Missmatch")
        logs.info("File will be redownload")
        data = redownloadFile(package.lnk, package.checksum)
        handle = fs.open(package.path, "w")
        handle.write(data)
        handle.close()
    else
        logs.info("File checksum validation passed.")
        logs.info("Package is validated.")
    end
end

-- Remove a package from Capsule, removes it from /usr/bin
-- @param package_name The package to remove.
local function removePackage(package_name)
    if not fs.exists(packages_path) then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local package_list = lib_config.load(packages_path)

    if not package_list then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local package = package_list[package_name]

    if not package then
        logs.critical("Package is not installed.")
        error("", 0)
    end

    logs.info("Deleting file...")
    fs.delete(package.path)
    logs.info("Done. Cleaning up...")
    package_list[package_name] = nil
    lib_config.save(package_list, packages_path)
    logs.info("Done.")
end

-- Uprade all Capsule packages.
local function upgradePackages()
    if not fs.exists(packages_path) then
        logs.critical("No packages installed.")
        error("", 0)
    end

    local package_list = lib_config.load(packages_path)

    if not package_list then
        logs.critical("No packages installed.")
        error("", 0)
    end

    if not fs.exists(repo_path) then
        logs.critical("No repository found. (Perhaps 'update'?)")
        error("", 0)
    end

    local handle = fs.open(repo_path, "r")
    if not handle then
        logs.critical("Unable to read repository.")
        error("", 0)
    end

    local repo = textutils.unserializeJSON(handle.readAll())
    if not repo then
        logs.critical("Unable to read repository")
        error("", 0)
    end

    logs.info("Going through installed packages...")

    local looked_for = 0
    local upgraded = 0

    for key, v in pairs(package_list) do
        logs.info("Looking for " .. key)
        looked_for = looked_for + 1
        for _, p in ipairs(repo) do
            if p.name == key then
                logs.info("Found corresponding package")
                if isRepoVerNewer(p.version, v.version) then
                    logs.info("Current version is outdated")
                    logs.info("Newer version will be downloaded...")

                    local attempts = 1

                    ::redownload1::

                    if attempts > 4 then
                        logs.critical("Unable to download valid file. Try again later.")
                        error("", 0)
                    end

                    local request, error = http.get(p.dwn_lnk)
                    if not request then
                        logs.critical("Cannot download package.")
                        logs.critical(error)
                        error("", 0)
                    end

                    logs.info("Downloaded data, saving...")

                    local data = request.readAll()

                    logs.info("Validation file integrity...")

                    local checksum = lib_sha.sha256(data)

                    if checksum ~= p.checksum then
                        logs.error("File checksum validation failed: Missmatch")
                        logs.info("Going to attempt " .. attempts .. "/3")
                        attempts = attempts + 1
                        goto redownload1
                    end

                    logs.info("File validated, saving...")

                    local handle = fs.open(v.path, "w")
                    handle.write(data)
                    handle.close()

                    package_list[key] = {
                        version = p.version,
                        path = v.path,
                        author = p.author,
                        desc = p.desc,
                        dwn_lnk = p.dwn_lnk,
                        checksum = p.checksum
                    }

                    lib_config.save(package_list, packages_path)
                    
                    logs.info("Package " .. key .. " has been upgraded.")

                    upgraded = upgraded + 1
                else
                    logs.info("Package " .. key .. " is up-to-date.")
                end
            end
        end
    end
    logs.info("Done. (" .. upgraded .. "/" .. looked_for .. " upgraded)")
end

-- Init code
setmetatable(version, {__tostring = tmp_toString})

-- Argument parsers
local args_parser = lib_args:new()

args_parser:addFlag("version")
args_parser:addFlag("--help", "-h")
args_parser:addFlag("--verbose", "-v")
args_parser:addFlag("update")
args_parser:addFlag("list")
args_parser:addFlag("--installed")
args_parser:addFlag("--available")
args_parser:addFlag("--all")
args_parser:addFlag("upgrade")

args_parser:addOption("--repository", "-r")
args_parser:addOption("install")
args_parser:addOption("checksum")
args_parser:addOption("validate")
args_parser:addOption("remove")

logs.configure({
    logToFile = false,              -- whether to write logs to file
    stampScreen = false,            -- whether to show timestamps on screen
    filePath = "/tmp/capsule.log",  -- path where to store logs if first parameter is true
    logLevel = logs.levels.INFO     -- level threshold (overriden by verbose flag) 
})

-- End of init code

args_parser:parse({ ... })

local flags = args_parser:getFlags()
local options = args_parser:getOptions()

---
-- Command Arguments
---

if flags["version"] then
    print("Capsule "..tostring(version))
    return
end

if flags["--help"] then
    displayHelpMessage()
    return
end

if flags["--verbose"] then
    logs.configure({logLevel = logs.levels.DEBUG})
    logs.debug("Starting in verbose.")
end

if flags["list"] then
    logs.debug("Listing repository")
    displayRepositoryList(getRepositoryList({flags["--installed"], flags["--available"], flags["--all"]}))
    return
end

if flags["update"] then
    logs.debug("update command executed.")
    updateRepository(options["--repository"])
    return
end

if flags["upgrade"] then
    logs.info("Upgrading packages, this may take a while")
    upgradePackages()
    return
end

if options["checksum"] then
    calculateChecksum(options["checksum"])
    return
end

if options["validate"] then
    validatePackage(options["validate"]:lower())
    return
end

if options["install"] then
    logs.info("Installing " .. options["install"])
    installPackage(options["install"]:lower())
    return
end

if options["remove"] then
    logs.info("Removing " .. options["remove"]:lower())
    removePackage(options["remove"]:lower())
    return
end

-- Always display the help message
-- TODO Add a toggle for this later.
displayHelpMessage()