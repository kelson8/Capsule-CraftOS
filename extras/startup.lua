-- This is the startup.lua that I use for Capsule-CraftOS on the Computers.
-- Place it on the root of the computer.

-- Check if a monitor exists, if so clear the screen
local mon = peripheral.find("monitor")
if mon then
   mon.clear()
end

-- This is mostly for the capsule programs from the package manager.
if fs.exists("/usr/bin") then
    shell.setPath(shell.path() .. ":/usr/bin")
end
