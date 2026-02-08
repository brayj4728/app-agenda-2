$url = "https://n8n-n8n.xxboi7.easypanel.host/webhook/ai-insights"
$body = @{
    appointments = @(
        @{
            id          = 1
            patientName = "Juan Pérez"
            dateStr     = "2026-02-06"
            time        = "10:00"
            status      = "APROBADA"
        }
    )
    role         = "professional"
} | ConvertTo-Json -Depth 5

Write-Host "Testing N8N AI Endpoint with new key..."
try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 30
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "Response:"
    Write-Host ($response | ConvertTo-Json -Depth 5)
}
catch {
    Write-Host "ERROR" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
