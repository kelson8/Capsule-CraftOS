local hash_util = {}

-- This is a hash util file that I will use for writing encrypted strings to text files.
-- This won't be used for the encryption but I will mostly use chacha20 for it.

---
-- Bytes to hex and hex to bytes
---

-- https://mojoauth.com/binary-encoding-decoding/base16-hexadecimal-with-lua/#encoding-data-to-base16-in-lua
--- Convert bytes to hex for storage
--- @param data The bytes to convert to hex.
function hash_util:bytes_to_hex(data)
    return (data:gsub(
        ".",
        function(c)
            return string.format("%02x", string.byte(c))
        end
    ))
end

--- Convert hex back to bytes
--- @param data The hex data to convert back to bytes
function hash_util:hex_to_bytes(hex_string)
    local data = ''
    for i = 1, #hex_string, 2 do
        local byte_str = hex_string:sub(i, i + 1)
        local byte_val = tonumber(byte_str, 16)
        if byte_val then
            data = data .. string.char(byte_val)
        else
            -- Handle invalid hex characters
            return nil, "Invalid hex character at position " .. i
        end
    end
    return data
end

return hash_util
