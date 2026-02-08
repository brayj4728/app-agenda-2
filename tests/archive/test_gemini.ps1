$apiKey = "AIzaSyAseKung5RTdYoYaNhgrehfK-OUnGhQjgI"
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
$body = @{
    contents = @(
        @{
            parts = @(
                @{ text = "Hola, dame una sugerencia breve sobre citas médicas en español." }
            )
        }
    )
} | ConvertTo-Json -Depth 5

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host "Success!"
    Write-Host "Full Response Structure:"
    Write-Host ($response | ConvertTo-Json -Depth 10)
}
catch {
    Write-Host "Error:"
    Write-Host $_.Exception.Message
}
