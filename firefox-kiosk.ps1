# Variables
$WebsiteUrl = "https://insperity.myisolved.com/UserLogin.aspx?ReturnUrl=%2fdefault.aspx"

# Launch Firefox and relaunch when it's closed
while ($true) {
    # Check if Firefox is running
    if (-not (Get-Process -Name "firefox" -ErrorAction SilentlyContinue)) {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ArgumentList "-kiosk $WebsiteUrl"
    }
    # Wait for 10 seconds before checking again
    Start-Sleep -Seconds 10
}