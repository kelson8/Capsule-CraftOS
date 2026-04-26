
-- New json library required, install it from this repo.
local json = require("/lib/json")

local side = "bottom"
local rsBridge = peripheral.wrap(side)
local itemName = "minecraft:stick"
-- rs_bridge.getItem({name = "minecraft:stick"})

if not fs.exists("lib/json") then
    print("Error, json library required for this! Install it from my Capsule package repo.")
end

-- This is testing with ComputerCraft, Refined Storage and the Advanced Peripherals.
-- https://docs.advanced-peripherals.de/0.7/peripherals/rs_bridge/

-- Using this json library
-- https://gist.github.com/tylerneylon/59f4bcf316be525b30ab

-- I pretty much got this to output to the terminal.

-- TODO Figure out how to replace the '"' and "[]" symbols
-- https://luascripts.com/lua-stringreplace

-- Refined storage values for the getItem function
-- In json they are like 'displayName, isCraftable...'
-- This is my enum used for printing the texts or writing them to a file.
local itemRsStatus = {
    TAGS = 1,
    COUNT = 2,
    MAX_STACK_SIZE = 3,
    FINGERPRINT = 4,
    IS_CRAFTABLE = 5,
    -- Name and displayname
    DISPLAYNAME = 6,
    NAME = 7
}

-- Get the item in storage, TODO Make this get user input.
-- TODO Make this output how much of a certain item I have onto a monitor, it should be possible to do a few.
local itemInStorage = rsBridge.getItem({name = "minecraft:iron_ingot"})

-- This doesn't seem to exist on the latest version.
-- local energyInStorage = rsBridge.getEnergyStorage()

-- Make sure the item exists in the storage, I'm not sure if this will work.
if not itemInStorage then
    print("Error, item doesn't exist in storage")
    return
end

-- Well I can use this json library.
-- print(json.stringify(itemInStorage))

local rsStatusFile = "/RefinedStorage/RS-Storage-Log.txt"

-- Create the status file.
local function createStatusFile()
    -- Create the status file if it doesn't exist, default to blank text.
    if not fs.exists(rsStatusFile) then
        -- fs.open(rsStatusFile, "w")
        -- local file = io.open(rsStatusFile, "w")
        -- file:close()

        local file = fs.open(rsStatusFile, "w")
        file.write("...")
        file.close()
    end
end

-- Create the status file if it doesn't already exist
createStatusFile()

-- Write text to the status file, overwriting the previous text.
local function writeToStatusFile(text)
    local file = fs.open(rsStatusFile, "w")
    file.write(text)
    file.close()
end

-- Json names

-- All the item tags
local itemTags = json.stringify(itemInStorage.tags)
-- The count of items
local itemCount = json.stringify(itemInStorage.count)

-- The max stack size for this item
local itemMaxStackSize = json.stringify(itemInStorage.maxStackSize)
-- The fingerprint, not sure what this is for.
local itemFingerprint = json.stringify(itemInStorage.fingerprint)

-- Seems to be some kind of auto crafting thing, it says false.
local isItemCraftable = json.stringify(itemInStorage.isCraftable)

-- Display the items display name, such as "[Iron Ingot]"
local itemDisplayName = json.stringify(itemInStorage.displayName)
-- Display the minecraft item name, could be useful for something.
-- Format: "minecraft:iron_ingot"
local itemName = json.stringify(itemInStorage.name)

-- Write to the Refined storage status file.
-- @param status Value from my itemRsStatus enum.
local function writeRsToFile(status)
    if status == itemRsStatus.TAGS then
        writeToStatusFile("Item tags: " .. itemTags)
    elseif status == itemRsStatus.COUNT then
        writeToStatusFile("Item count: " .. itemCount)
    elseif status == itemRsStatus.MAX_STACK_SIZE then
        writeToStatusFile("Item max stack size: " .. itemMaxStackSize)
    elseif status == itemRsStatus.FINGERPRINT then
        writeToStatusFile("Item fingerprint: " .. itemFingerprint)
    elseif status == itemRsStatus.IS_CRAFTABLE then
        writeToStatusFile("Is Item craftable: " .. isItemCraftable)
    elseif status == itemRsStatus.DISPLAYNAME then
        writeToStatusFile("Item display name: " .. itemDisplayName)
    elseif status == itemRsStatus.NAME then
        writeToStatusFile("Item name: " .. itemName)
    end

    -- writeToStatusFile(itemCount)
    -- local file = fs.open(rsStatusFile)
    -- file.write("Item in storage: " .. itemInStorage)
    -- file.write("Item "  .. in storage: " .. json.stringify(itemInStorage.count))
    -- file.write("Item "  .. itemName .. " amount in storage: " .. itemCount)
end

-- Print the Refined Storage info.
local function printRsInfo(status)
    -- print(energyInStorage)
    -- print("Item in storage: " .. itemInStorage)
    -- I figured out how to get values from these!!
    -- print(json.stringify(itemInStorage))
    -- print(json.stringify(itemInStorage.count))

    -- print("Item " .. itemDisplayName .. " amount in storage: " .. itemCount)

    if status == itemRsStatus.TAGS then
        print("Item tags: " .. itemTags)
    elseif status == itemRsStatus.COUNT then
        print("Item count: " .. itemCount)
    elseif status == itemRsStatus.MAX_STACK_SIZE then
        print("Item max stack size: " .. itemMaxStackSize)
    elseif status == itemRsStatus.FINGERPRINT then
        print("Item fingerprint: " .. itemFingerprint)
    elseif status == itemRsStatus.IS_CRAFTABLE then
        print("Is Item craftable: " .. isItemCraftable)
    elseif status == itemRsStatus.DISPLAYNAME then
        print("Item display name: " .. itemDisplayName)
    elseif status == itemRsStatus.NAME then
        print("Item name: " .. itemName)
    end
end

-- Usages:
-- printRsInfo(itemRsStatus.COUNT)
-- writeRsToFile(itemRsStatus.COUNT)
-- writeRsToFile(itemRsStatus.MAX_STACK_SIZE)
-- writeRsToFile(itemRsStatus.DISPLAYNAME)
