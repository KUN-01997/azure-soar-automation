# Sentinel Insider Threat Detection and Response (Terraform + SOAR)

This project demonstrates how to detect insider threats on Windows systems using Microsoft Sentinel, with infrastructure provisioned by Terraform and automated response via Logic Apps.

It includes end-to-end log collection, detection rules, automation rules, and enrichment playbooks.

---

## Project Workflow

### 1. Infrastructure Deployment (Terraform)
All core Azure infrastructure is deployed using Terraform:
- Azure Virtual Network and Subnet
- Windows Virtual Machine
- Network Interface Card (NIC)
- Network Security Group (NSG)
- Log Analytics Workspace
- Data Collection Rule (DCR)
- Azure Monitor Agent (AMA) extension
- Microsoft Sentinel enabled on the workspace

### 2. Data Collection Setup
- Windows security logs are ingested using AMA.
- DCR is configured to collect `SecurityEvent` logs from the VM.
- Events are verified via Log Analytics query.

### 3. Detection with Microsoft Sentinel
Microsoft Sentinel analytics rules are created for key insider threat techniques:

| Detection                           | Event ID | Description                             |
|------------------------------------|----------|-----------------------------------------|
| Security Events Deleted            | 1102     | Detects clearing of Windows logs        |
| User Added to Privileged Group     | 4732     | Detects privilege escalation attempts   |
| Multiple Failed Logon Attempts     | 4625     | Detects brute-force or password spray   |

### 4. SOAR: Automated Incident Response
A Logic App is triggered when incidents are created in Sentinel.

- It inspects the `incident title` using a `Switch` action.
- Based on the rule matched, it:
  - Adds appropriate **tags** to the incident
  - Posts a **comment** for analyst triage
  - All actions use Sentinel’s incident ARM ID

| Incident Title                    | Tags                               | Comment Added                                        |
|----------------------------------|------------------------------------|------------------------------------------------------|
| Security Events Deleted          | DefenseEvasion, LogTampering       | Log clearing activity detected                      |
| User Added to Privileged Group   | PrivilegeEscalation, GroupChange   | User added to admin group                          |
| Multiple Failed Logons           | BruteForce, AccountAttack          | Excessive failed logins detected                   |

---

## MITRE ATT&CK Mapping

| Tactic              | Technique ID | Description                        |
|---------------------|--------------|------------------------------------|
| Defense Evasion     | T1070.001    | Clear Windows Event Logs           |
| Privilege Escalation| T1078.002    | Valid Accounts: Domain Accounts    |
| Credential Access   | T1110        | Brute Force                        |

---

## How to Simulate

Run the following commands on your VM to generate test events:

- **Log Clearing (1102):**
```powershell
wevtutil cl Security
```

- **Privileged Group Add (4732):**
```powershell
net localgroup administrators attacker /add
```

- **Failed Logon (4625):** Try RDP login with wrong credentials 5+ times.

---
