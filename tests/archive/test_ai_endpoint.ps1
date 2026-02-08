$url = "https://n8n-n8n.xxboi7.easypanel.host/webhook/ai-insights"
$body = @{
    appointments = @(
        @{
            id          = 1
            patientName = "Juan Pérez"
            dateStr     = "2026-02-06"
            time        = "10:00"
            status      = "APROBADA"
        },
        @{
            id          = 2
            patientName = "María García"
            dateStr     = "2026-02-07"
            time        = "14:00"
            status      = "PENDIENTE"
        }
    )
    role         = "professional"
} | ConvertTo-Json -Depth 5

Write-Host "Testing N8N AI Endpoint..." -ForegroundColor Cyan
Write-Host "URL: $url"
Write-Host "Body: $body"
Write-Host ""

try {
    $response = Invoke-WebRequest -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 30
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "Response:"
    Write-Host $response.Content
}
catch {
    Write-Host "ERROR!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error Message: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody"
    }
}
