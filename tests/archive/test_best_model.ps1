$apiKey = "AIzaSyCsJQJuug8ugm7vEmoiOb8_tG1o9B_QEjw"

$modelsToTest = @(
    "gemini-2.5-flash",
    "gemini-2.0-flash",
    "gemini-flash-latest"
)

$body = @{
    contents = @(
        @{
            parts = @(
                @{ text = "Responde solo 'OK' en español" }
            )
        }
    )
} | ConvertTo-Json -Depth 5

foreach ($model in $modelsToTest) {
    $url = "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$apiKey"
    Write-Host "`nTesting model: $model" -ForegroundColor Cyan
    Write-Host "URL: $url"
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 10
        $text = $response.candidates[0].content.parts[0].text
        Write-Host "SUCCESS!" -ForegroundColor Green
        Write-Host "Response: $text"
        Write-Host "`n=== USE THIS IN N8N ===" -ForegroundColor Yellow
        Write-Host "URL: $url" -ForegroundColor Yellow
        Write-Host "Model: $model" -ForegroundColor Yellow
        Write-Host "=====================`n" -ForegroundColor Yellow
        break
    }
    catch {
        Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}
