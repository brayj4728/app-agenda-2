# Test N8N Registration Endpoint
$body = @{
    name   = "KAREN"
    email  = "KAREN@GMAIL.COM"
    cedula = "1000595140"
    phone  = "3245522306"
    role   = "patient"
} | ConvertTo-Json

Write-Host "Testing N8N Registration..." -ForegroundColor Cyan
Write-Host "URL: https://n8n-n8n.xxboi7.easypanel.host/webhook/register" -ForegroundColor Yellow
Write-Host "Body: $body" -ForegroundColor Gray

try {
    $response = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/register" -Method POST -Body $body -ContentType "application/json"
    Write-Host "`nSUCCESS!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
}
catch {
    Write-Host "`nERROR!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Error Message: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nResponse Body:" -ForegroundColor Yellow
    $_.Exception.Response.GetResponseStream() | ForEach-Object {
        $reader = New-Object System.IO.StreamReader($_)
        $reader.ReadToEnd()
    }
}
