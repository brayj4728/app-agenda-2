# Test Gemini API v1 (no beta)
$apiKey = "AIzaSyCsJQJuug8ugm7vEmoiOb8_tG1o9B_QEjw"

$endpoints = @(
    "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey",
    "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey"
)

$body = @{
    contents = @(
        @{
            parts = @(
                @{ text = "Di 'Hola' en español" }
            )
        }
    )
} | ConvertTo-Json -Depth 5

foreach ($url in $endpoints) {
    Write-Host "`nTesting: $url" -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 10
        $text = $response.candidates[0].content.parts[0].text
        Write-Host "SUCCESS!" -ForegroundColor Green
        Write-Host "Response: $text"
        Write-Host "`n=== USE THIS URL IN N8N ===" -ForegroundColor Yellow
        Write-Host $url -ForegroundColor Yellow
        Write-Host "============================`n" -ForegroundColor Yellow
        break
    }
    catch {
        Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}
