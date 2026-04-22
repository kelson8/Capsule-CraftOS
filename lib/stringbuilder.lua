local table = table;

-- Source for file
-- https://pastebin.com/KUjYeHfm

local stringBuilder = {}

setmetatable(stringBuilder, {
    __call = function (self, ...)
        return self:create(...)
    end, })

local stringBuilder_mt = {
    __index = stringBuilder,

    __add = function (self, ...)
        return self:append(...)
    end,

    __concat = function (self, ...)
        return self:append(...)
    end,

    __tostring = function (self)
        return self:toString()
    end
}

function stringBuilder:init(...)
    local obj = {
        accumulator = {}
    }
    setmetatable(obj, stringBuilder_mt)
    return obj
end

function stringBuilder:create(...)
    return self:init(...)
end

function stringBuilder:is_empty()
    return #self.accumulator == 0;
end

function stringBuilder:clear()
    self.accumulator = {}
    return self
end

function stringBuilder:append(other)
    if type(other) == "string" then
        table.insert(self.accumulator, other)

    elseif type(other) == "table" then
        if other.accumulator == nil then
            return self
        end

        for _, v in ipairs(self.accumulator) do
            table.insert(self.accumulator, v)
        end
    end

    return self
end

function stringBuilder:toString(sep)
    sep = sep or ""
    return table.concat(self.accumulator, sep)
end

function stringBuilder:str()
    return table.concat(self.accumulator)
end

return stringBuilder