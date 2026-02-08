
Write-Host "--- TEST: AGENDA CONFLICT DETECTION ---"
$url = "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments"
$dateToken = Get-Random -Minimum 1000 -Maximum 9999
$testDate = "2026-12-$dateToken" # Random date to avoid previous collisions
$testTime = "10:00am"

# 1. First Booking (Should Succeed)
Write-Host "`n1. Attempting First Booking ($testDate @ $testTime)..."
$payload1 = @{
    patientName = "Test User A"
    patientCedula = "11111"
    dateStr = "2026-12-01" 
    time = "10:00am"
    type = "Cita"
} | ConvertTo-Json

try {
    $response1 = Invoke-RestMethod -Uri $url -Method Post -Body $payload1 -ContentType "application/json"
    Write-Host "Response 1: Success=$($response1.success)"
    if ($response1.appointment) { Write-Host " - ID: $($response1.appointment.id)" }
} catch {
    Write-Host "Request 1 Failed: $_"
}

# 2. Second Booking (Should Fail)
Write-Host "`n2. Attempting Second Booking (SAME SLOT)..."
$payload2 = @{
    patientName = "Test User B"
    patientCedula = "22222"
    dateStr = "2026-12-01"
    time = "10:00am"
    type = "Cita"
} | ConvertTo-Json

try {
    # Note: Invoke-RestMethod throws on HTTP errors, but if n8n returns 200 OK with success:false, it won't throw.
    $response2 = Invoke-RestMethod -Uri $url -Method Post -Body $payload2 -ContentType "application/json"
    
    if ($response2.success -eq $false) {
        Write-Host "✅ PASSED: System blocked the conflict!"
        Write-Host "Message: $($response2.message)"
    } else {
        Write-Host "❌ FAILED: System allowed double booking"
        Write-Host "Response: $($response2 | ConvertTo-Json -Depth 2)"
    }

} catch {
    Write-Host "Request 2 Failed (Network/Server Error): $_"
}
