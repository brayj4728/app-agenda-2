# Comprehensive N8N AI Workflow Test
Write-Host "=== Testing Complete N8N AI Workflow ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Prepare prompt (simulating "Prepare Prompts" node)
$appointments = @(
    @{
        id          = 1
        patientName = "Juan Pérez"
        dateStr     = "2026-02-06"
        time        = "10:00"
        status      = "APROBADA"
        type        = "Fisioterapia"
    },
    @{
        id          = 2
        patientName = "María García"
        dateStr     = "2026-02-06"
        time        = "14:00"
        status      = "PENDIENTE"
        type        = "Fisioterapia"
    }
)

$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$prompt = "Act as an expert scheduling assistant. Current time: $now. Analyze these appointments: $($appointments | ConvertTo-Json -Compress). Tasks: 1. Summarize schedule status. 2. Identify conflicts/gaps. 3. Suggest improvements. 4. Speak in Spanish. 5. Keep it concise."

Write-Host "Step 1: Prompt prepared" -ForegroundColor Green
Write-Host "Prompt: $prompt"
Write-Host ""

# Step 2: Call Gemini API (simulating "Gemini API" node)
$apiKey = "AIzaSyAseKung5RTdYoYaNhgrehfK-OUnGhQjgI"
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
$body = @{
    contents = @(
        @{
            parts = @(
                @{ text = $prompt }
            )
        }
    )
} | ConvertTo-Json -Depth 5

Write-Host "Step 2: Calling Gemini API..." -ForegroundColor Yellow
try {
    $geminiResponse = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host "✓ Gemini API responded successfully" -ForegroundColor Green
    Write-Host ""
    
    # Step 3: Format Response (simulating "Format Response" node)
    $text = $geminiResponse.candidates[0].content.parts[0].text
    if (-not $text) {
        $text = "No suggestion."
    }
    
    Write-Host "Step 3: Response formatted" -ForegroundColor Green
    Write-Host ""
    
    # Step 4: Final response (simulating "Respond AI" node)
    $finalResponse = @{
        suggestion = $text
    }
    
    Write-Host "=== FINAL RESPONSE ===" -ForegroundColor Cyan
    Write-Host ($finalResponse | ConvertTo-Json)
    Write-Host ""
    Write-Host "=== AI SUGGESTION ===" -ForegroundColor Cyan
    Write-Host $text -ForegroundColor White
    
}
catch {
    Write-Host "✗ Error calling Gemini API" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
