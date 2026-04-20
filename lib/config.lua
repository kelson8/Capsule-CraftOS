function save(tbl, name)
    local file = fs.open(name, "w")
    file.write(textutils.serialize(tbl))
    file.close()    
end

function createIfNotExists(name)
    if not fs.exists(name) then
        local file = fs.open(name, "w")
        file.close()
        return true
    end
    return false
end

function load(name)
    local file = fs.open(name, "r")
    local tbl = textutils.unserialize(file.readAll())
    file.close()
    return tbl
end

return {save = save, createIfNotExists = createIfNotExists, load = load}