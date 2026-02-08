$apiKey = "AIzaSyCsJQJuug8ugm7vEmoiOb8_tG1o9B_QEjw"
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
$body = @{
    contents = @(
        @{
            parts = @(
                @{ text = "Hola, responde brevemente en español" }
            )
        }
    )
} | ConvertTo-Json -Depth 5

Write-Host "Testing new API key..."
try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    $text = $response.candidates[0].content.parts[0].text
    Write-Host "SUCCESS! API key works!" -ForegroundColor Green
    Write-Host "Response: $text"
}
catch {
    Write-Host "ERROR! API key failed" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
