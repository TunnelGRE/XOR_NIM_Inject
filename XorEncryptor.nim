import strutils

proc xorEncryptDecrypt(data: seq[byte], key: seq[byte]): seq[byte] =
    var encrypted: seq[byte]
    for i in 0 ..< len(data):
        encrypted.add(data[i] xor key[i mod len(key)])
    result = encrypted

proc main() =
    let shellcode: seq[byte] = @[]
    let key: seq[byte] = @[0x6d, 0x79, 0x73, 0x65, 0x63, 0x72, 0x65, 0x74, 0x6b, 0x65, 0x79]

    let encryptedShellcode = xorEncryptDecrypt(shellcode, key)
    var encryptedHex: seq[string]
    for b in encryptedShellcode:
        encryptedHex.add("0x" & $toHex(b, 2))  # Converti il byte in esadecimale con "0x" prefisso
    echo "Shellcode encrypted:", encryptedHex.join(", ")

    let decryptedShellcode = xorEncryptDecrypt(encryptedShellcode, key)
    var decryptedHex: seq[string]
    for b in decryptedShellcode:
        decryptedHex.add("0x" & $toHex(b, 2))  # Converti il byte in esadecimale con "0x" prefisso
    echo "Original Shellcode:", decryptedHex.join(", ")

when isMainModule:
    main()
