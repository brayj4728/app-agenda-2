# Test directo a Gemini API con la nueva key
$apiKey = "AIzaSyCsJQJuug8ugm7vEmoiOb8_tG1o9B_QEjw"

# Probar diferentes endpoints
$endpoints = @(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey",
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey"
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
        Write-Host "Model works! Response: $text"
        Write-Host "USE THIS URL IN N8N" -ForegroundColor Yellow
        break
    }
    catch {
        Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}
