Write-Host "Testing Appointment Retrieval..."
Write-Host "URL: https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments?cedula=1000595138&role=patient"
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments?cedula=1000595138&role=patient" `
        -Method GET
    
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
    
    if ($response.appointments) {
        Write-Host "`nTotal Appointments: $($response.appointments.Count)" -ForegroundColor Cyan
    }
}
catch {
    Write-Host "ERROR!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error Message: $($_.Exception.Message)"
}
