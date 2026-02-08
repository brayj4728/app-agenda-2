$appointments = @(@{id = 1; patientName = "Juan"; dateStr = "2026-02-06"; time = "10:00"; status = "APROBADA" })
$now = Get-Date -Format "yyyy-MM-dd HH:mm"
$prompt = "Act as an expert scheduling assistant. Current time: $now. Analyze these appointments: $($appointments | ConvertTo-Json -Compress). Tasks: 1. Summarize schedule status. 2. Identify conflicts/gaps. 3. Suggest improvements. 4. Speak in Spanish. 5. Keep it concise."

$apiKey = "AIzaSyAseKung5RTdYoYaNhgrehfK-OUnGhQjgI"
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
$body = @{contents = @(@{parts = @(@{text = $prompt }) }) } | ConvertTo-Json -Depth 5

Write-Host "Calling Gemini..."
$response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
$text = $response.candidates[0].content.parts[0].text

Write-Host "=== AI SUGGESTION ==="
Write-Host $text
