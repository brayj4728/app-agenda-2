$regUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/register"
$viewUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/view-db"

Write-Host "--- 1. Testing Registration ---"
$rand = Get-Random -Minimum 1000 -Maximum 9999
$body = @{
    name = "Test User $rand"
    email = "test$rand@email.com"
    cedula = "TEST-$rand"
    role = "patient"
} | ConvertTo-Json

try {
    $reg = Invoke-RestMethod -Uri $regUrl -Method Post -Body $body -ContentType "application/json"
    Write-Host "Register Response: $($reg.success)"
} catch {
    Write-Error "Register Failed: $_"
    exit
}

Write-Host "`n--- 2. Testing View DB (User Table) ---"
try {
    $html = Invoke-RestMethod -Uri $viewUrl -Method Get
    if ($html -match "Test User $rand") {
        Write-Host "SUCCESS: Found created user in the Table!"
        Write-Host "Table contains 'Nombre', 'Email', 'Cedula' headers."
    } else {
        Write-Host "WARNING: User created but not found in HTML. Check n8n Logic."
        Write-Host "HTML Preview: $($html.Substring(0, [math]::Min(200, $html.Length)))"
    }
} catch {
    Write-Error "View DB Failed: $_"
}
