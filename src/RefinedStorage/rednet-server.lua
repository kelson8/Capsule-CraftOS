-- https://web.archive.org/web/20230211142745/https://computercraft.info/forums2/index.php?/topic/746-simple-rednet-message-board-monitor/

-- This file goes on a computer that has a wireless/wired modem, with a monitor.
-- This also can display the time in the text if enabled, it cuts the
-- text off of a monitor though.

-- Set the values to the system here, the monitor side, modem side, and if redstone output should be enabled

local monside = "top" -- Define the side of your monitor
local mdmside = "left" -- Define the side of your modem
local montextsize = 2 -- Define the size of the text on your monitor
local header = "Message Board" -- Type the header of your board
local rson = false -- true is use redstone output, false don't uses the output
local rsoutput = "right" -- Define the redstone output towards a bell of light or something (only needed when rson is set to true)
local rstime = 1 -- The time the redstone output is open

-- List of keys from here, use the capital letter ones
-- https://www.ascii-code.com/
-- Q key
local keyToQuit = 81

-- If the time should be displayed in the messages.
local displayTime = false

mon = peripheral.wrap(monside)
mon.setCursorBlink(false)
mon.setTextScale(montextsize)

local monwidth, monheight = mon.getSize()
local messages = {}
local num = 0
local messageBegin = 0
local messageEnd = 0
local maxMessagesOS = monheight - 3

-- Print text on the monitor
function monprint(text)
    local cX, cY = mon.getCursorPos()
    mon.write(text)
    mon.setCursorPos(1, cY + 1)
end

-- Clear the screen
function clearscreen()
    mon.clear()
    mon.setCursorPos(1, 1)
    monprint(header)
    mon.setCursorPos(1, 3)
end

-- Add a new message to the screen
function addmessage(text)
    if #messages > maxMessagesOS then
        messageBegin = (#messages - maxMessagesOS)
        messageEnd = #messages
    elseif #messages <= maxMessagesOS then
        messageEnd = #messages
    end
    clearscreen()
    for b = messageBegin, messageEnd do
        monprint(messages[b])
    end
end


-- Clear the screen and set to running.
function init()
    clearscreen()
    running = true
end

init()
term.clear()
term.setCursorPos(1, 1)
print("Refined Storage SERVER")
-- https://stackoverflow.com/questions/30789573/how-can-i-convert-a-character-code-to-a-string-character-in-lua
print("Press " .. string.char(keyToQuit) .. " to quit")
rednet.open(mdmside)

while running do
    event, id, receivedmessage = os.pullEventRaw()
    if event == "rednet_message" then
        -- local nTime = os.time()
        -- https://www.reddit.com/r/ComputerCraft/comments/18oji91/real_time_clock/

        local nTime = os.time("local")

        -- Added a time toggle for this.
        if displayTime then
            messages[num] = (textutils.formatTime(nTime, false) .. " - " .. receivedmessage)
        else
            messages[num] = (receivedmessage)
        end
        num = num + 1
        addmessage()
        if rson then
            rs.setOutput(rsoutput, true)
            sleep(rstime)
            rs.setOutput(rsoutput, false)
        end
        sleep(0.1)
    elseif event == "key" and id == keyToQuit then
        mon.clear()
        running = false
    end
end
