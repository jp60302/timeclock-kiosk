# firefox-kiosk

This repository contains a simple PowerShell script that launches Mozilla Firefox in kiosk mode to a specified URL and automatically restarts it if the browser is closed. It is designed for kiosk-style terminals, time clocks, or single-purpose workstations.

---

## Features

- Launches Firefox in full-screen [kiosk mode](https://support.mozilla.org/en-US/kb/how-use-full-screen) to a defined URL.
- Monitors the Firefox process and relaunches it if closed.
- Suitable for kiosk / shared environments where users should only access a single website.

---

## Requirements

- Windows 10/11
- Mozilla Firefox installed at the default location:

  ```text
  C:\Program Files\Mozilla Firefox\firefox.exe
  ```

  *If Firefox is installed elsewhere, update the `-FilePath` in the script accordingly.*

- PowerShell 5.1 or later (standard on modern Windows)

---

## Configuration

### 1. Change the Target Website

Edit the script and update the `$WebsiteUrl` variable:

```powershell
$WebsiteUrl = "https://your.internal.or.external.site"
```

### 2. Adjust the Firefox Path (Optional)

If Firefox is installed in a non-default location, change:

```powershell
Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" ...
```

to the correct path for your environment.

---

## Deploying via Group Policy (GPO)

1. Copy `firefox-kiosk.ps1` to a central location, e.g.:
   ```text
   \\YourDomain\netlogon\firefox-kiosk\firefox-kiosk.ps1
   ```
   or to a local location, e.g.:
   ```text
   C:\firefox-kiosk.ps1
   ```
2. Open **Group Policy Management** (`gpmc.msc`).
3. Create or edit a GPO linked to the OU containing your kiosk computers or users.
4. Navigate to:

   ```text
   User Configuration
     → Policies
       → Windows Settings
         → Scripts (Logon/Logoff)
   ```

5. Double-click **Logon** → click **Add…**.
6. Click **Browse…** and copy the script into the GPO’s script folder, or specify a UNC path.
7. If you place the script in the GPO’s script folder, select it and click **OK**.
8. If your environment requires it, you can create a small CMD wrapper to launch PowerShell, for example:

   ```cmd
   powershell.exe -ExecutionPolicy Bypass -File "\\YourDomain\netlogon\KioskFirefox\KioskFirefox.ps1"
   ```

   Add this CMD file instead of the PS1 if you prefer.

### PowerShell Execution Policy Considerations

If your environment uses a restrictive PowerShell Execution Policy, you have a few options:

- Sign the script with a trusted code-signing certificate, or
- Use the `-ExecutionPolicy Bypass` flag in a wrapper script/CMD, for example:

  ```cmd
  powershell.exe -ExecutionPolicy Bypass -File "\\YourDomain\netlogon\KioskFirefox\KioskFirefox.ps1"
  ```

You can also centrally configure execution policy via GPO:

```text
Computer Configuration
  → Policies
    → Administrative Templates
      → Windows Components
        → Windows PowerShell
          → Turn on Script Execution
```

---

## Disabling File Explorer via Group Policy (Lockdown)

To tighten kiosk security, you may want to prevent users from accessing File Explorer and navigating the local system.

### 1. Hide Desktop Icons and Prevent Access to Explorer

In your kiosk GPO:

```text
User Configuration
  → Policies
    → Administrative Templates
      → Desktop
```

- Enable **Hide and disable all items on the desktop**.

Then:

```text
User Configuration
  → Policies
    → Administrative Templates
      → Start Menu and Taskbar
```

Consider enabling:
- **Remove File Explorer icon from Start Menu**
- **Remove common program groups from Start Menu**
- **Do not use the search-based method when resolving shell shortcuts**
- **Prevent access to the command prompt**
- **Do not keep history of recently opened documents**
- **Remove access to the context menus for the taskbar**

### 2. Prevent Access to Drives and File Explorer Settings

```text
User Configuration
  → Policies
    → Administrative Templates
      → Windows Components
        → File Explorer
```

Commonly-used settings for kiosks:
- **Prevent access to drives from My Computer**  
  - Set to **Enabled** and choose the drives to restrict (often C: or All Drives).
- **Hide these specified drives in My Computer**  
  - Set to **Enabled** and choose the same drives as above.
- **Prevent access to the File Explorer features** (depending on your Windows version, wording may vary).
- **Turn off Windows+X hotkey** (if available) to avoid power user menus.

### 3. Use a Kiosk Account (Optional but Recommended)

Consider creating a dedicated kiosk user and applying the GPO only to that user or to an OU containing kiosk machines. This way, normal users and admins are not affected.

---

## Notes & Limitations

- Users can’t exit kiosk mode easily using normal UI; however, they might still be able to use keyboard shortcuts (e.g., Alt+F4, Win+D, etc.) unless further locked down by other policies or third-party tools.
- If Firefox crashes repeatedly, it will be continuously relaunched by the script; monitor logs and event viewer for underlying stability issues.
