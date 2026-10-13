---
description: Sweep this machine for malware persistence (infostealer follow-up)
---

Follow-up sweep for the infostealer found on 2026-07-29. Read-only — **report
findings, remove nothing without asking.**

Background (from the global CLAUDE.md): a fake `AppData\Local\Google Chrome\`
folder ran `zvchost.exe` (a renamed signed `python.exe`) plus a packed payload
named `huna`, persisted via an `HKCU\...\Run` value called `svchost`, undetected
by Defender for ~8 months. Persistence and folder were removed; a Defender
Offline scan was still pending.

Check each of these and report a clean/dirty verdict per line:

1. **Run keys** — `HKCU:\Software\Microsoft\Windows\CurrentVersion\Run` and
   `RunOnce`, and the `HKLM:` equivalents. List every value with its full data.
2. **Startup folders** — the per-user Startup folder and the all-users one.
3. **Scheduled tasks** — anything not Microsoft-signed; flag tasks whose action
   points into `AppData`, `Temp`, or `ProgramData`.
4. **The known-bad path** — confirm `AppData\Local\Google Chrome` is still
   absent. The real Chrome is `AppData\Local\Google\Chrome` — note the
   difference and do not confuse them.
5. **Lookalike executables** — anything named like a system binary
   (`svchost`, `zvchost`, `csrss`, `lsass`, `winlogon`) running from a user-writable
   path. Compare against the real location in `System32`.
6. **Defender health** — `Get-MpComputerStatus`: real-time protection on,
   signature age, and **when the last full and offline scan ran**.
7. **Exclusions** — `Get-MpPreference | Select-Object Exclusion*`. Malware adds
   these. Any unexpected exclusion is a finding.

Then:

- Present findings as a table with a clear verdict column.
- For anything suspicious, give the full path, signature status
  (`Get-AuthenticodeSignature`), and creation time.
- **Do not delete, quarantine, or modify anything.** Propose the fix and wait.
- Close by restating the two items still outstanding from the original
  remediation: the **Defender Offline scan** (needs a reboot) and **credential
  rotation from a separate clean device**.
