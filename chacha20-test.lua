local chacha = require("/iDar.CryptoLib.src.chacha20")
local text_util = require("/lib/util/text_util")
local hash_util = require("/lib/util/hash_util")

-- This project requires iDar-CryptoLib
-- https://github.com/DarThunder/iDar-CryptoLib/tree/main

-- I got this working by outputting the encrypted text, and nonce to the encrypted_string.txt file
-- This converts the values to hex for storage in the text file.
-- Then it converts back to bytes for the decryption.

-- Generate nonce and encrypt
local nonce = chacha.generateNonce()
-- TODO Make this require user input for the key.
local key = "supersecretkey"
-- TODO Make this allow the user to specify if they are encrypting a value, or decrypting a value.
-- Add the encrypted text and nonce to the encrypted_string.txt file.
-- Decrypt with the key and nonce.
local encrypted = chacha.encrypt("Hello world", key, nonce)
local decrypted = chacha.decrypt(encrypted, key, nonce)

-- Contains the encrypted text.
local encryptedTextFile = "/enc_test/encrypted_string.txt"

-- https://stackoverflow.com/questions/37796287/convert-decimal-to-hex-in-lua-4
-- Oops, this is only for numbers
-- print(string.format("%x", encrypted))
-- print(encrypted)

-- Create the encrypted text file if it doesn't exist.
if not fs.exists(encryptedTextFile) then
    local file = fs.open(encryptedTextFile, "w")
    file.write("ChaCha20-hex:null\n")
    file.write("ChaCha20-nonce:null")
end

--- Write the encrypted text to the file
--- First, this is converted to hex.
--- @param encrypted_text The encrypted text to write to the file.
--- @param nonce The nonce is required for decryption.
local function write_encrypted_text(encryptedText, nonce)
    local file = fs.open(encryptedTextFile, "w")
    file.write("ChaCha20-hex:" .. hash_util:bytes_to_hex(encrypted) .. "\n")
    file.write("ChaCha20-nonce:" .. hash_util:bytes_to_hex(nonce))
end

write_encrypted_text(encrypted, nonce)

-- print(text_util:returnString(encryptedTextFile, 1))
local encryptedString = text_util:returnString(encryptedTextFile, 1)
local encryptionNonce = text_util:returnString(encryptedTextFile, 2)
-- local decryptedString = chacha.decrypt(hash_util:hex_to_bytes(encryptedString), key, nonce)
local decryptedString = chacha.decrypt(hash_util:hex_to_bytes(encryptedString), key, hash_util:hex_to_bytes(encryptionNonce))
-- print(encryptedString)

-- print(hash_util:hex_to_bytes(encryptedString))

print(decryptedString)
