-- The path to the floppy disk to check the space for.
local floppyDiskToCheckSpace = "/disk"
-- The side where the disk drive is.
local floppySide = "bottom"

--- Get the free space in the drive, convert bytes to Kb
--- @param drive The drive to check, such as '/' or '/disk'
function getFreeSpaceKb(drive)
    return fs.getFreeSpace(drive) / 1000
end

print("Computer Free Space: " .. getFreeSpaceKb("/") .. "Kb")

-- Make sure a floppy is present before checking the free space.
if disk.isPresent(floppySide) and disk.hasData(floppySide) then
    print("Floppy disk Free Space: " .. getFreeSpaceKb(floppyDiskToCheckSpace) .. "Kb")
end
-- 