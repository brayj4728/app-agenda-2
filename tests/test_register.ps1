
$rand = Get-Random -Minimum 1000 -Maximum 9999
$cedula = "777$rand"
$name = "RegTest $rand"
$email = "reg$rand@solar.com"
$role = "patient"

Write-Host "--- TEST: REGISTER WEBHOOK ---"
$body = @{
    name = $name
    cedula = $cedula
    email = $email
    role = $role
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/register" -Method Post -ContentType "application/json" -Body $body
    Write-Host "Response received:"
    Write-Host ($response | ConvertTo-Json -Depth 5)
    
    if ($response.success -eq $true) {
        Write-Host "`n✅ REGISTER SUCCESS"
    } else {
        Write-Host "`n❌ REGISTER FAILED response"
    }
} catch {
    Write-Host "Request Failed: " $_.Exception.Message
}
