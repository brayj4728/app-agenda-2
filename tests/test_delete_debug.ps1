$baseUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments"
$cedula = "TEST_DEBUG"

# 1. Create Dummy
Write-Host "Creating dummy..."
$payload = @{
    patientName = "Debug User"
    patientCedula = $cedula
    dateStr = "2025-01-01"
    time = "10:00am"
    type = "Test"
}
try {
    $create = Invoke-RestMethod -Uri $baseUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType "application/json"
    $id = $create.appointment.id
    if (!$id) { 
        # Falls back to parsing as array if needed?
        Write-Host "Create Response Raw: $($create | ConvertTo-Json -Depth 5)"
        if ($create[0].success) { $id = $create[0].appointment.id }
    }
} catch { Write-Host "Create Error: $_"; exit }

Write-Host "Created ID: $id"

# 2. Delete Dummy and Print RAW
if ($id) {
    Write-Host "Deleting ID: $id"
    try {
        $del = Invoke-RestMethod -Uri $baseUrl -Method Delete -Body (@{id=$id} | ConvertTo-Json) -ContentType "application/json"
        Write-Host "DELETE RESPONSE RAW:"
        Write-Host ($del | ConvertTo-Json -Depth 5)
    } catch {
        Write-Host "Delete Error: $_"
    }
} else {
    Write-Host "Could not create dummy, skipping delete."
}
