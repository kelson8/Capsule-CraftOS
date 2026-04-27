
-- Requires json from my lib folder on the GitHub
local json = require("/lib/json")


-----

-- This file goes on a computer that has a wireless/wired modem, and is connected to a Refined Storage setup.
-- This file sends data from the Advanced Peripherals mod using the RS Bridge and Refined Storage.
-- https://docs.advanced-peripherals.de/0.7/peripherals/rs_bridge/
-- To a computer running the rednet-server.lua, which has to have a monitor

-- Using this json library
-- https://gist.github.com/tylerneylon/59f4bcf316be525b30ab

-- TODO Figure out how to replace the '"' and "[]" symbols
-- https://luascripts.com/lua-stringreplace

local mdmside = "left" -- Define the side of you modem

-- This below is the computer ID of the current running server.
local srvid = 7 -- Define the server ID

local side = "bottom"
local rsBridge = peripheral.wrap(side)
local itemName = "minecraft:stick"

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

-- Print the Refined Storage info.
local function printMessage(status)
    if status == itemRsStatus.TAGS then
        return "Item tags: " .. itemTags
    elseif status == itemRsStatus.COUNT then
        return "Item count: " .. itemCount
    elseif status == itemRsStatus.MAX_STACK_SIZE then
        return "Item max stack size: " .. itemMaxStackSize
    elseif status == itemRsStatus.FINGERPRINT then
        return "Item fingerprint: " .. itemFingerprint
    elseif status == itemRsStatus.IS_CRAFTABLE then
        return "Is Item craftable: " .. isItemCraftable
    elseif status == itemRsStatus.DISPLAYNAME then
        return "Item display name: " .. itemDisplayName
    elseif status == itemRsStatus.NAME then
        return "Item name: " .. itemName
    end
end

----

rednet.open(mdmside)
term.clear()
term.setCursorPos(1, 1)
print("Message Board Sender")
print("Type quit to stop")

while true do
    write("Enter text: ")
    message = io.read()
    if message == "quit" then
        break
    elseif message == "tags" then
        rednet.send(srvid, printMessage(itemRsStatus.TAGS))
    elseif message == "count" then
        rednet.send(srvid, printMessage(itemRsStatus.COUNT))
    elseif message == "max-stacks" then
        rednet.send(srvid, printMessage(itemRsStatus.MAX_STACK_SIZE))
    elseif message == "fingerprint" then
        rednet.send(srvid, printMessage(itemRsStatus.FINGERPRINT))
    elseif message == "iscraftable" then
        rednet.send(srvid, printMessage(itemRsStatus.IS_CRAFTABLE))
    elseif message == "item-name" then
        rednet.send(srvid, printMessage(itemRsStatus.DISPLAYNAME))
    elseif message == "item-ingame-name" then
        rednet.send(srvid, printMessage(status == itemRsStatus.NAME))
    else
        rednet.send(srvid, message)
    end
end
