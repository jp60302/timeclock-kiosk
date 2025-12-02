# Variables
$WebsiteUrl = "https://insperity.myisolved.com/UserLogin.aspx?ReturnUrl=%2fdefault.aspx"

# Launch Firefox and relaunch when it's closed
while ($true) {
    Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -Wait -ArgumentList "-kiosk $WebsiteUrl"
}