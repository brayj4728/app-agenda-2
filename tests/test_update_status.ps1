$base = "https://n8n-n8n.xxboi7.easypanel.host/webhook"

# 1. Create a dummy test appointment
$payload = @{
    patientName = "TestUser"
    patientCedula = "123"
    dateStr = "2026-02-18"
    time = "9:00AM"
    type = "Test"
} | ConvertTo-Json

try {
    Write-Host "Creating Appointment..."
    $res = Invoke-RestMethod -Uri "$base/appointments" -Method Post -Body $payload -ContentType "application/json"
    $appt = $res.appointment
    $id = $appt.id
    Write-Host "Created ID: $id"

    # 2. Update Status to APROBADA
    $updatePayload = @{
        id = $id
        status = "APROBADA"
        color = "bg-green"
    } | ConvertTo-Json

    Write-Host "Updating Status..."
    $updateRes = Invoke-RestMethod -Uri "$base/appointments" -Method Put -Body $updatePayload -ContentType "application/json"
    
    if ($updateRes.success) {
        Write-Host "Update Success: $($updateRes.appointment.status)"
        
        # 3. Verify Persistence (GET)
        $getRes = Invoke-RestMethod -Uri "$base/appointments?cedula=123&role=patient" -Method Get
        $found = $getRes.appointments | Where-Object { $_.id -eq $id }
        Write-Host "Verification Status: $($found.status)"

        # 4. Cleanup
        Invoke-RestMethod -Uri "$base/appointments" -Method Delete -Body (@{id=$id} | ConvertTo-Json) -ContentType "application/json" | Out-Null
    } else {
        Write-Error "Update Failed: $($updateRes.message)"
    }
} catch {
    Write-Error $_.Exception.Message
}
