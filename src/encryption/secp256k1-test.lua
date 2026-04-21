-- local ecc = require("iDar.CryptoLib.secp256k1")
local ecc = require("/iDar.CryptoLib.src.secp256k1")

-- https://github.com/DarThunder/iDar-CryptoLib/tree/main#secp256k1

-- Key exchange example
local privA = ecc.generatePrivateKey()
local pubA = ecc.getPublicKey(privA)

local privB = ecc.generatePrivateKey()
local pubB = ecc.getPublicKey(privB)

-- Both parties compute the same shared secret
local secretA = ecc.getSharedSecret(privA, pubB)
local secretB = ecc.getSharedSecret(privB, pubA)

print(secretA == secretB) -- Output: true
local message = "tung tung tung sahur ta ta ta sahur"
os.sleep(10) -- a very neccessary sleep if you don't want to burn your cpu lol

-- sign example
local sign = ecc.sign(privA, message)
print("R = " .. sign.r) -- R
print("S = " .. sign.s) -- S
os.sleep(10) -- another small pause to keep the CPU cool :)

-- verify example
local verify = ecc.verify(pubA, message, sign)
print("Result: ", verify.result, "\nMessage: ", verify.message) --Output true, Signature verification result

