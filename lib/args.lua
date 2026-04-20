local parser = {}

function parser:new()
    local obj = {
        flags = {},
        options = {},
        parsed = {flags = {}, options = {}, args = {}}
    }
    self.__index = self
    return setmetatable(obj, self)
end

function parser:addFlag(canonical, ...)
    local variants = {...}
    self.flags[canonical] = {false, variants}
    for _, variant in ipairs(variants) do
        self.flags[variant] = {false, {canonical}}
    end
end

function parser:addOption(canonical, ...)
    local variants = {...}
    self.options[canonical] = {nil, variants}
    for _, variant in ipairs(variants) do
        self.options[variant] = {nil, {canonical}}
    end
end

function parser:parse(args)
    local i = 1
    while i <= #args do
        local arg = args[i]
        if self.flags[arg] then
            for _, variant in ipairs(self.flags[arg][2]) do
                self.parsed.flags[variant] = true
            end
            self.parsed.flags[arg] = true
        elseif self.options[arg] then
            if i + 1 <= #args then
                local value = args[i + 1]
                for _, variant in ipairs(self.options[arg][2]) do
                    self.parsed.options[variant] = value
                end
                self.parsed.options[arg] = value
                i = i + 1
            else
                error("Option " .. arg .. " expects a value")
            end
        else
            table.insert(self.parsed.args, arg)
        end
        i = i + 1
    end
end

function parser:getFlags()
    local result = {}
    for flag, _ in pairs(self.flags) do
        if self.parsed.flags[flag] then
            result[flag] = true
        end
    end
    return result
end

function parser:getOptions()
    local result = {}
    for option, _ in pairs(self.options) do
        if self.parsed.options[option] then
            result[option] = self.parsed.options[option]
        end
    end
    return result
end

function parser:getArgs()
    return self.parsed.args
end

return parser