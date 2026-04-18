# Brave Debloater Scripts

These scripts disable all non-core Brave Browser features to replicate the **Brave Origin** debloated experience — without paying for it.

## What Gets Disabled

| Feature | Policy Key |
|---------|-----------|
| Leo AI Chat | `BraveAIChatEnabled = 0` |
| Brave News | `BraveNewsDisabled = 1` |
| Brave Rewards & Ads | `BraveRewardsDisabled = 1` |
| Speedreader | `BraveSpeedreaderEnabled = 0` |
| Telemetry (P3A, crash logs, daily ping) | `BraveP3AEnabled = 0`, `BraveStatsPingEnabled = 0` |
| Brave Talk | `BraveTalkDisabled = 1` |
| Tor Private Windows | `TorDisabled = 1` |
| Brave VPN | `BraveVPNDisabled = 1` |
| Brave Wallet & Web3 | `BraveWalletDisabled = 1` |
| Wayback Machine | `BraveWaybackMachineEnabled = 0` |
| Web Discovery Project | `BraveWebDiscoveryEnabled = 0` |

**What you keep:** Brave Shields (ad/tracker blocking), Brave Search, core browser speed & security updates.

---

## macOS — `debloat-brave-macos.sh`

### Requirements
- macOS 10.14 or later
- Brave Browser installed

### Usage

1. **Close Brave completely** (Cmd+Q)
2. Open Terminal
3. Make the script executable and run it:

```bash
cd /path/to/this/folder
chmod +x debloat-brave-macos.sh
./debloat-brave-macos.sh
```

4. Restart Brave and visit `brave://policy` to verify.

### Undo / Restore

```bash
./debloat-brave-macos.sh --restore
```

---

## Windows — Option A: PowerShell Script

### Requirements
- Windows 10/11
- Brave Browser installed
- PowerShell run as **Administrator**

### Usage

1. **Close Brave completely**
2. Right-click PowerShell → **Run as Administrator**
3. Allow script execution (one-time):

```powershell
Set-ExecutionPolicy -Scope Process RemoteSigned
```

4. Run the script:

```powershell
cd C:\path\to\this\folder
.\debloat-brave-windows.ps1
```

5. Restart Brave and visit `brave://policy` to verify.

### Undo / Restore

```powershell
.\debloat-brave-windows.ps1 -Restore
```

---

## Windows — Option B: Registry File (Easiest)

If you prefer not to use PowerShell, just double-click the `.reg` file.

### Usage

1. **Close Brave completely**
2. Double-click `debloat-brave-windows.reg`
3. Click **Yes** on the UAC prompt
4. Click **Yes** to confirm adding to registry
5. Restart Brave and visit `brave://policy` to verify.

### Undo

Open Registry Editor (`regedit`), navigate to:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave
```

Delete the value names you want to revert, or change `1` → `0` (and `0` → `1` for `*Enabled` keys).

---

## How It Works

### macOS
Uses the `defaults write` command to set **policy preferences** in `~/Library/Preferences/com.brave.Browser.plist`. 

**⚠️ CRITICAL:** On macOS, Brave policies that are `DWord` (0/1) on Windows **must** be set as **integers** (`-integer`), not booleans (`-bool`). Using the wrong type causes Brave to crash on startup with `EXC_BREAKPOINT`. The script handles this correctly.

### Windows
Writes **Group Policy registry values** under `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`. This is the officially supported method to manage Brave in enterprise environments — it completely disables the targeted features rather than just hiding them.

> ⚠️ **Note:** After applying these policies, you may see "Your browser is managed by your organization" in Brave's settings or menu. This is normal and expected — it simply means policy values are active.

---

## Safety & Backups

Both the macOS and PowerShell scripts **automatically back up** your existing settings before making changes:
- **macOS**: Backups saved to `~/.brave-debloat-backups/<timestamp>/`
- **Windows**: Backups saved to `%USERPROFILE%\.brave-debloat-backups\<timestamp>\`

You can restore from these backups using the `--restore` (macOS) or `-Restore` (Windows) flags.

---

## References

- [Brave Support — What is Brave Origin?](https://support.brave.app/hc/en-us/articles/38561489788173-What-is-Brave-Origin)
- [Brave Support — Group Policy](https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy)
- [Brave Group Policy Templates](https://support.brave.com/hc/en-us/articles/360039248271)
