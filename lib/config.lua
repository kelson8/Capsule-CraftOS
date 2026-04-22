-- Config library
-- 

-- Original source
-- https://pastebin.com/v5XWn99E

-- Save a value in a the package.list file
function save(tbl, name)
    local file = fs.open(name, "w")
    file.write(textutils.serialize(tbl))
    file.close()
end

-- Create a file if it doesn't exist
-- @param name The name of the file to create.
function createIfNotExists(name)
    if not fs.exists(name) then
        local file = fs.open(name, "w")
        file.close()
        return true
    end
    return false
end

-- Load a package.list parameter
-- @param name
-- @return All values from the package.list file.
function load(name)
    local file = fs.open(name, "r")
    local tbl = textutils.unserialize(file.readAll())
    file.close()
    return tbl
end

return {save = save, createIfNotExists = createIfNotExists, load = load}