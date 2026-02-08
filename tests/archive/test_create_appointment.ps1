$body = @{
    patientCedula = "1000595138"
    patientName   = "Test Patient"
    dateStr       = "2026-02-07"
    time          = "10:00"
    type          = "Fisioterapia"
    status        = "PENDIENTE"
} | ConvertTo-Json

Write-Host "Testing Appointment Creation..."
Write-Host "URL: https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments"
Write-Host "Body: $body"
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body
    
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
}
catch {
    Write-Host "ERROR!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error Message: $($_.Exception.Message)"
    Write-Host "Response: $($_.Exception.Response)"
}
