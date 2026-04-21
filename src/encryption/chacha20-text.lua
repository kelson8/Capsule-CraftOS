local chacha = require("/iDar.CryptoLib.src.chacha20")

-- Download text_util and hash_util if they don't exist.

local local_repo = "https://raw.githubusercontent.com/kelson8/Capsule-CraftOS/refs/heads/main"

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

--- Write the encrypted text to the file
--- First, this is converted to hex.
--- @param encrypted_text The encrypted text to write to the file.
--- @param nonce The nonce is required for decryption.
local function write_encrypted_text(encryptedText, nonce)
    local file = fs.open(encryptedTextFile, "w")
    file.write("ChaCha20-hex:" .. hash_util:bytes_to_hex(encryptedText) .. "\n")
    file.write("ChaCha20-nonce:" .. hash_util:bytes_to_hex(nonce))
end

-- Encrypt a message encrypted with chacha20 from the computer
local function encryptArgument()
    print("What would you want to set the key to?: ")
    local key = read("*")

    print("What is the string you want to encrypt?: ")
    local messageToEncrypt = read()

    if messageToEncrypt == "" or messageToEncrypt == " " then
        print("Invalid string to encrypt")
        return
    end

    -- Generate nonce and encrypt
    local nonce = chacha.generateNonce()

    local encrypted = chacha.encrypt(messageToEncrypt, key, nonce)

    -- Create the encrypted text file if it doesn't already exist.
    createEncryptedTextFile()

    -- Write the encrypted text and nonce with the bytes_to_hex function.
    write_encrypted_text(encrypted, nonce)
end

-- Decrypt a message encrypted with chacha20 from the computer
-- If the encryption password is invalid, the text will not display and will show up as corrupted symbols.
local function decryptArgument()
    print("Enter a key to decrypt the message: ")
    local key = read("*")

    print("Attempting to decrypt message stored in " .. encryptedTextFile)
    -- print("Enter the encrypted message from the " .. encryptedTextFile .. " file.")
    -- local messageToDecrypt = read()
    -- if messageToDecrypt == "" or messageToDecrypt == " " then
    --     print("Invalid string to encrypt")
    --     return
    -- end

    local encryptedString = text_util:returnString(encryptedTextFile, 1)
    local encryptionNonce = text_util:returnString(encryptedTextFile, 2)
    -- Attempt to decrypt the string
    local decryptedString = chacha.decrypt(hash_util:hex_to_bytes(encryptedString), key, hash_util:hex_to_bytes(encryptionNonce))

    -- Print the decrypted output.
    -- print(hash_util:hex_to_bytes(encryptedString))
    print(decryptedString)
end

if args[1] == "encrypt" then
    encryptArgument()
elseif args[1] == "decrypt" then
    decryptArgument()
end
