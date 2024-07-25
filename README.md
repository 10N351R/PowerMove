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

## Disclaimer
**Ethical Use:** PowerMove is provided for educational and lawful purposes only. The author is not responsible for any misuse or damaged caused by this tool. By using this tool, you agree to use it ethically and comply with all applicable laws and regulations. Unauthorized use of this tool is strictly prohibited and may result in severe legal consequences.

**Use Of Artificial Intelligence:** This tool was partially developed with the assistance of Artificial Intelligence (AI), and contains portions of code generated using OpenAI's ChatGPT, an AI language model.
