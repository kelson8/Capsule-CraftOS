local basalt = require("../basalt")
local text_util = require("/lib/util/text_util")

local main = basalt.getMainFrame()

-- Redstone side for the redstone signal
local redstoneSide = "left"

-- Get a reference to the monitor
local monitor = peripheral.wrap("right")

-- Create a frame for the monitor
local monitorFrame = basalt.createFrame()
    :setTerm(monitor)
    :setBackground(colors.lightGray)

local redstoneStatus = redstone.getOutput(redstoneSide)

-- No longer in use
-- local generatorStatus = settings.get("generator.status")

local generatorStatusFile = "/disk/generator_status.txt"

-- Create the status file if it doesn't exist, default to false.
if not fs.exists(generatorStatusFile) then
    -- fs.open(generatorStatusFile, "w")
    -- local file = io.open(generatorStatusFile, "w")
    -- file:close()

    local file = fs.open(generatorStatusFile, "w")
    file.write("GeneratorStatus:false")
end

-- Set the current redstone state for later use.
-- @param state boolean The state to set, enabled or disabled.
local function updateRedstoneState(state)
    local file = fs.open(generatorStatusFile, "w")
    file.write("GeneratorStatus:" .. tostring(state))
end

-- updateRedstoneState(false)

------
-- Generator status
------
local storedGeneratorStatus = text_util:returnString(generatorStatusFile, 1)

-- This sets the redstone state to the previous, so if the generator is offline it'll stay offline
-- When this computer reboots.
-- Get the redstone state from the text file
local previousRedstoneStatus = text_util:toBoolean(storedGeneratorStatus)
--

-- The reason for that is if a redstone signal is being output, the generator shuts down.
-- https://stackoverflow.com/questions/5525817/inline-conditions-in-lua-a-b-yes-no
-- local generatorStatusText = (redstoneStatus and "Offline" or "Online" )
local generatorStatusText = (previousRedstoneStatus and "Offline" or "Online")

-- Get the current redstone state
-- @return The status of the redstone state stored in the text file.
local function getRedstoneState()
    return storedGeneratorStatus
end

-- Set the redstone status depending on if it was on or off.
redstone.setOutput("left", previousRedstoneStatus)

---------
-- Buttons
---------
local onButton = monitorFrame:addButton()
    :setText("On")
    :setSize(12, 3)
    :setPosition(2, 8)

-- monitorFrame:addButton()
local offButton = monitorFrame
    :addButton()
    :setText("Off")
    :setSize(12, 3)
    :setPosition(2, 4)

---------
-- Labels
---------

local statusLabel = monitorFrame
    :addLabel()
    :setPosition(0, 2)
    :setText("Status")

local statusToggleLabel = monitorFrame
    :addLabel()
    :setPosition(10, 2):-- :setText("Offline")
    setText(generatorStatusText)

---------
-- Button functions
---------

local function turnOnGenerator()
    statusToggleLabel:setText("Online")
    redstone.setOutput(redstoneSide, false)
    updateRedstoneState(false)
end

local function turnOffGenerator()
    statusToggleLabel:setText("Offline")
    redstone.setOutput(redstoneSide, true)

    updateRedstoneState(true)
end

onButton:onClick(
    function(self, event, button, x, y)
        -- if event == "mouse_click" then
        turnOnGenerator()
        -- end
    end
)

offButton:onClick(
    function(self, event, button, x, y)
        -- if event == "mouse_click" then
        turnOffGenerator()
        -- end
    end
)

-- Start Basalt (handles all frames automatically)
basalt.run()

-- Clear the monitor at the end
monitor.clear()
