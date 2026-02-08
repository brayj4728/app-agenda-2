$url = "https://n8n-n8n.xxboi7.easypanel.host/webhook/ai-insights"
$body = @{
    appointments = @(
        @{
            id          = 1
            patientName = "Test Patient"
            dateStr     = "2026-02-06"
            time        = "10:00"
            status      = "APROBADA"
        }
    )
    role         = "professional"
} | ConvertTo-Json -Depth 5

Write-Host "Testing N8N AI Endpoint..."
Write-Host "URL: $url"
Write-Host "Body: $body"
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host "Success!"
    Write-Host "Response:"
    Write-Host ($response | ConvertTo-Json -Depth 5)
}
catch {
    Write-Host "Error:"
    Write-Host $_.Exception.Message
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "Response Body:"
        Write-Host $reader.ReadToEnd()
    }
}
