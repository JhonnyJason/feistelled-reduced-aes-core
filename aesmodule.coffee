############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("aesmodule")
#endregion

############################################################
import {performance} from "node:perf_hooks"
import crypto from "crypto"
import  * as tbut from "thingy-byte-utils"
import { sha512Hex, sha256Hex } from "secret-manager-crypto-utils"
import { AESEngine } from "./aes.js"

############################################################
count = 1000
messageBytes = new Uint8Array(1024)
seedHex = ""
seedBytes = null

############################################################
keyBytes = null
iv1Bytes = null
iv2Bytes = null
iv2Hex = ""

aesEngine = null
cipher = null
decipher = null
############################################################
# encAlgo = "aes-256-cbc"
encAlgo = "aes-256-ctr"
# encAlgo = "aes-256-gcm"


############################################################
export initialize = ->
    log "initialize"
    seedHex = sha512Hex("tralalalalla der Walddödel dödelt im Wald")
    seedBytes = tbut.hexToBytes(seedHex)

    # ivHex = seedHex.substring(0, 32)
    # ivBuffer = Buffer.from(ivHex, "hex")
    # aesKeyHex = seedHex.substring(32,96)
    # aesKeyBuffer = Buffer.from(aesKeyHex, "hex")


    keyBytes = seedBytes.slice(0,32)
    iv1Bytes = seedBytes.slice(32, 48)
    
    iv2Bytes = seedBytes.slice(48, 64)
    iv2Hex = tbut.bytesToHex(iv2Bytes)
    aesEngine = new AESEngine(seedBytes)

    cipher = crypto.createCipheriv(encAlgo, keyBytes, iv1Bytes)
    decipher = crypto.createDecipheriv(encAlgo, keyBytes, iv1Bytes)

    return


export runAllTests = ->
    log "runAllTests"
    count = 100000000
    # log "encrypting: #{iv2Hex}"

    # gibbrish = nativeEncrypt()
    # log "gibbrish: #{gibbrish}"
    # log "gibbrish length: #{gibbrish.length}"
    
    # result = nativeDecrypt(gibbrish)
    # log "decrypted: #{result}"

    # return
    await runTest("sha256", calcSHA2, count)
    await runTest("uniqueTokenOld", calcOldUnique, count)
    await runTest("uniqueToken2", calcUnique2, count)
    await runTest("uniqueToken", calcUnique, count)
    await runTest("feistelDigest", calcFeistel, count)
    await runTest("nativeEncrypt", nativeEncrypt, count)
    return

runTest = (name, func, count) ->
    before = performance.now()
    while(count--)
        func()
        # await func()
    after = performance.now()
    diff = after - before
    log "Test #{name}: #{diff}ms"

    return


############################################################
nativeEncrypt = ->
    return cipher.update(iv2Hex, "utf8", 'hex')

nativeDecrypt = (gibbrishHex) ->
    return decipher.update(gibbrishHex, 'hex', "utf8")

############################################################
calcSHA2 = ->
    result = sha256Hex(messageBytes)
    # result = await sha256Hex(messageBytes)
    # return result

############################################################
calcSymEncrypt = ->
    return symmetricEncryptHex(seedBytes)
    # result = await symmetricEncryptHex(seedBytes)
    # return result

############################################################
calcOldUnique = ->
    return aesEngine.ctrDigestOld(Date.now())
    # result = await aesEngine.ctrDigestOld(Date.now())
    # return tbut.bytesToHex(result)

############################################################
calcUnique = ->
    return aesEngine.ctrDigest(Date.now())
    # result = await aesEngine.ctrDigest(Date.now())
    # return tbut.bytesToHex(result)

############################################################
calcUnique2 = ->
    return aesEngine.ctrDigest2(Date.now())
    # result = await aesEngine.ctrDigest2(Date.now())
    # return tbut.bytesToHex(result)

############################################################
calcFeistel = ->
    return aesEngine.feistelDigest(Date.now())
    # result = await aesEngine.ctrDigest2(Date.now())
    # return tbut.bytesToHex(result)
