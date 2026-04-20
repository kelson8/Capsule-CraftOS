local text_util = {}

------
-- Text file handling
------

-- Read lines from a text file
-- https://stackoverflow.com/questions/64792750/read-one-line-and-just-one-line-in-lua-how
-- @param f, File to get the string from
-- @param line The line to grab the string from.
function text_util:readLines(f, line)
    local i = 1 -- Line counter
    -- for x in f:lines() do -- Lines iterator, "x returns the line"
    for x in io.lines(f) do
        if i == line then return x end -- We found this line return it.
        i = i + 1 -- Counting lines
    end
    return new_string
    -- return "" -- Doesn't have that line
end

-- https://stackoverflow.com/questions/50396678/lua-match-everything-after-character-in-string

-- 
-- Return the string after the semicolon in a text file.
-- This is useful for config files, so if you have a door_config.txt file this can read the text
--  after the semicolon such as this 'door_status:open', just reads 'open'.
-- You cannot have a space after the colon, I may need to change that later.
-- @param f, File to get the string from
-- @param line The line to grab the string from.
function text_util:returnString(f, line)
    readTest = text_util:readLines(f, line)
    _, final = string.find(readTest, ":")
    new_string = string.sub(readTest, final + 1)

    return new_string
end


-- Convert a string to boolean
-- https://stackoverflow.com/questions/69405331/how-to-convert-string-to-boolean-in-lua
-- @param str The string to convert to boolean.
function text_util:toBoolean(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end

return text_util