
# Create 3 Mock Users
$users = @(
    @{ name="Maria Perez"; cedula="1001"; email="maria@test.com"; role="patient" },
    @{ name="Juan Lopez"; cedula="1002"; email="juan@test.com"; role="patient" },
    @{ name="Carlos Diaz"; cedula="1003"; email="carlos@test.com"; role="patient" }
)

foreach ($u in $users) {
    $body = $u | ConvertTo-Json
    Write-Host "Registering $($u.name)..."
    try {
        Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/register" -Method Post -ContentType "application/json" -Body $body
    } catch {
        Write-Host "Error: $_"
    }
    Start-Sleep -Milliseconds 500
}
Write-Host "Population Complete."
