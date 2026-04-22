local chacha = require("/iDar.CryptoLib.src.chacha20")

-- Download text_util and hash_util if they don't exist.

local local_repo = "https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main"

-- Minimum password length required for encryption password, this can be toggled below.
local password_min_length = 6

-- If the minimum password length is enabled
local minimum_password_enabled = false

-- TODO Move this into a separate utility file.
-- Text file util
-- TODO Make these require the SHA256 sum for the files.
if not fs.exists("/lib/util/text_util.lua") then
    print("Text util not found, installing it now")
    shell.run("wget " .. local_repo .. "/lib" .. "/util/text_util.lua" .. " /lib/util/text_util.lua")
end

-- Hash util
if not fs.exists("/lib/util/hash_util.lua") then
    print("Hash util not found, installing it now")
    shell.run("wget " .. local_repo .. "/lib" .. "/util/hash_util.lua" .. " /lib/util/hash_util.lua")
end

local text_util = require("/lib/util/text_util")
local hash_util = require("/lib/util/hash_util")

-- Contains the encrypted text.
local encryptedTextFile = "/apps/encrypted_string.txt"

local args = {...}

-- This project requires iDar-CryptoLib
-- https://github.com/DarThunder/iDar-CryptoLib/tree/main
-- This can be setup with iDar-pacman

-- I got this working by outputting the encrypted text, and nonce to the encrypted_string.txt file
-- This converts the values to hex for storage in the text file.
-- Then it converts back to bytes for the decryption.

-- First, make sure iDar-pacman is installed
if not fs.exists("/iDar/Pacman") then
    print("Error: iDar-pacman is required for this. ")
    return
end

-- Create the encrypted text file if it doesn't already exist.
local function createEncryptedTextFile()
    if not fs.exists(encryptedTextFile) then
        local file = fs.open(encryptedTextFile, "w")
        file.write("ChaCha20-hex:null\n")
        file.write("ChaCha20-nonce:null")
    end
end

------
-- Checking if characters are valid
------

-- Check if the character is an ansi character.
-- This should detect invalid characters in the decrypted output.
-- If they are invalid, it means the encryption password was incorrect.
local function is_ansi_char(text)
    -- return string.byte(text) <= 127
    -- https://luascripts.com/lua-regular-expression
    -- https://riptutorial.com/lua/example/20315/lua-pattern-matching
    -- Matches upper and lower case letters, punctuation characters
    local match = text:match("[%u%d%a%l%p]")
    print(match)

end

-- Check if the string is a normal ASCII string
local function is_all_ansi_bytes(s)
  for i = 1, #s do
    if s:byte(i) > 127 then return false end
  end
  return #s > 0  -- or allow empty string by returning true
end

-- Check if text is valid
-- local function looks_like_text(s, min_printable_ratio)
--   min_printable_ratio = min_printable_ratio or 0.7
--   if #s == 0 then return false end
--   local printable = 0
--   for i = 1, #s do
--     local b = s:byte(i)
--     if (b >= 32 and b <= 126) or b == 9 or b == 10 or b == 13 then
--       printable = printable + 1
--     end
--   end
--   return printable / #s >= min_printable_ratio
-- end

------
-- Writing encrypted text
------

--- Write the encrypted text to the file
--- First, this is converted to hex.
--- @param encrypted_text The encrypted text to write to the file.
--- @param nonce The nonce is required for decryption.
local function write_encrypted_text(encryptedText, nonce)
    local file = fs.open(encryptedTextFile, "w")
    file.write("ChaCha20-hex:" .. hash_util:bytes_to_hex(encryptedText) .. "\n")
    file.write("ChaCha20-nonce:" .. hash_util:bytes_to_hex(nonce))
end

------
-- Arguments
------

-- Encrypt a message encrypted with chacha20 from the computer
local function encryptArgument()
    print("What would you want to set the password to?: ")
    local password = read("*")

    if password == "" or password == " " then
        print("Invalid password to encrypt")
        return
    end

    -- Check if the minimum password is enabled, and if the password is less then the minimum characters.
    if minimum_password_enabled and string.len(password) < password_min_length then
        print("Error: The password is less then " .. password_min_length .. " characters.")
        return
    end

    print("What is the string you want to encrypt?: ")
    local messageToEncrypt = read()

    if messageToEncrypt == "" or messageToEncrypt == " " then
        print("Invalid message to encrypt")
        return
    end

    -- Generate nonce and encrypt
    local nonce = chacha.generateNonce()

    local encrypted = chacha.encrypt(messageToEncrypt, password, nonce)

    -- Create the encrypted text file if it doesn't already exist.
    createEncryptedTextFile()

    -- Write the encrypted text and nonce with the bytes_to_hex function.
    write_encrypted_text(encrypted, nonce)
end

-- Decrypt a message encrypted with chacha20 from the computer
-- If the encryption password is invalid, the text will not display and will show up as corrupted symbols.
local function decryptArgument()
    print("Enter a password to decrypt the message: ")
    local password = read("*")

    print("Attempting to decrypt message stored in " .. encryptedTextFile)
    if password == "" or password == " " then
        print("Invalid password to decrypt with")
        return
    end

    local encryptedString = text_util:returnString(encryptedTextFile, 1)
    local encryptionNonce = text_util:returnString(encryptedTextFile, 2)
    -- Attempt to decrypt the string
    local decryptedString =
        chacha.decrypt(hash_util:hex_to_bytes(encryptedString), password, hash_util:hex_to_bytes(encryptionNonce))

    -- Decrypted hex value to check if it is valid
    local decryptedToHex = hash_util:bytes_to_hex(decryptedString)

    print(decryptedString)

    -- Print the decrypted output.
    -- TODO Make this give an error if it isn't ANSI.
    -- Not sure how to do this just yet.
    -- if not is_ansi_char(decryptedString) then
    -- if not is_all_ansi_bytes(decryptedString) then
    -- if not looks_like_text(decryptedString) then
    --     print("Encryption password invalid.")
    --     return
    -- else
    --     print(decryptedString)
    -- end
end

if args[1] == "encrypt" then
    encryptArgument()
elseif args[1] == "decrypt" then
    decryptArgument()
-- elseif args[1] == "ansichartest" then
--     is_ansi_char("Test")
else
    print("Arguments: encrypt, decrypt")
end
