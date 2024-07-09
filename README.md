# PowerMove
Author: 10N351R


PowerMove is a simple fileless process injector written in PowerShell for injecting shellcode and migrating your shell to new processes. PowerMove uses "quick-and-easy" WINAPIs such as `OpenProcess`, `VirtualAllocEx`, `WriteProcessMemory`, and `CreateRemoteThread` to perform process injection. These WINAPIs are often detected by anti-virus solutions on disk but will bypass them when run exclusively in memory. PowerMove will likely not work against more sophisticated Emergency, Detected, and Respond (EDR) systems as the APIs it utilizes are easily detected in memory. 

Tested on PowerShell version: 5.1.19041.4522

## Instructions
To use PowerMove in an existing PowerShell shell
1. Copy the contents PowerMove.ps1 into a text editor
2. Edit the `$targetPid` variable with the PID of the target process to inject into
3. Edit the `$shellcode` variable with the payload you wish to inject
4. Copy the contents from the beginning `###` to the end `###` to your clipboard
5. Paste the contents your existing PowerShell shell and hit `Enter`
6. Enjoy the benifits fileless process injection

## Output
![alt text](https://github.com/10N351R/PowerMove/blob/main/Images/PowerMove_output.png)

## Disclaimer
**Ethical Use:** PowerMove is provided for educational and lawful purposes only. The author is not responsible for any misuse or damaged caused by this tool. By using this tool, you agree to use it ethically and comply with all applicable laws and regulations. Unauthorized use of this tool is strictly prohibited and may result in severe legal consequences.

**Use Of Artificial Intelligence:** This tool was partially developed with the assistance of Artificial Intelligence (AI), and contains portions of code generated using OpenAI's ChatGPT, an AI language model.
