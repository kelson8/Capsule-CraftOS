local monitor_util = {}

-- https://tweaked.cc/guide/using_require.html

-- Get a reference to the monitor, set the side here
-- local monitor = peripheral.wrap("right")
local monitor = peripheral.find("monitor")

--- Reset the monitor screen.
function monitor_util:reset()
-- function reset_monitor()
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

--- Write text to the center of the monitor.
--- This writes text to the bottom center, I'm not sure how to put it in the middle just yet.
--- @param text The text to write.
function monitor_util:write_to_center(text)
-- function monitor_write_to_center(text)
    local x, y = monitor.getCursorPos()
    local width, height = monitor.getSize()
    -- monitor.setCursorPos(math.floor((width - #text) / 2) + 1, y)
    monitor.setCursorPos(math.floor((width - #text) / 2) + 1, height)
    monitor.write(text)
end

--- Write text to a specific position on a monitor.
--- @param text The text to write.
--- @param x The x for the cursor position.
--- @param y The y for the cursor position.
function monitor_util:write(text, x, y)
    monitor.setCursorPos(x, y)
    monitor.write(text)
end

--- Set the monitor background color
--- @param color The color to set, list of colors: https://tweaked.cc/module/colors.html
function monitor_util:setBackgroundColor(color)
    monitor.setBackgroundColor(color)
end

-- This is required for the 'require' lua function to work.
return monitor_util
