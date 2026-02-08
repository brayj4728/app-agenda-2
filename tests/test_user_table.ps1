$regUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/register"
$viewUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/agenda-view"

Write-Host "--- 1. Registering New User ---"
$rand = Get-Random -Minimum 1000 -Maximum 9999
$body = @{
    name = "User Verify $rand"
    email = "verify$rand@test.com"
    cedula = "VER-$rand"
    role = "patient"
} | ConvertTo-Json

try {
    $reg = Invoke-RestMethod -Uri $regUrl -Method Post -Body $body -ContentType "application/json"
    Write-Host "Register Success: $($reg.success)"
} catch {
    Write-Error "Register Failed: $_"
    exit
}

Write-Host "`n--- 2. Fetching Table (HTML) ---"
try {
    # -UseBasicParsing is default in PS Core but good to be safe.
    # We want RAW content to check for HTML tags.
    $response = Invoke-WebRequest -Uri $viewUrl -UseBasicParsing
    $content = $response.Content

    Write-Host "Status Code: $($response.StatusCode)"
    
    if ($content -match "<html>" -and $content -match "Rol (Tipo)") {
        Write-Host "SUCCESS: Detected HTML Table with 'Rol (Tipo)' column."
        if ($content -match "User Verify $rand") {
            Write-Host "SUCCESS: Found newly registered user in the table!"
        } else {
            Write-Host "WARNING: Table HTML valid, but new user NOT found (maybe delay?)."
        }
    } else {
        Write-Host "FAILURE: Response is NOT the expected HTML Table."
        Write-Host "Preview: $($content.Substring(0, [math]::Min(100, $content.Length)))"
    }

} catch {
    Write-Error "Fetch View Failed: $_"
}
