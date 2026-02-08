$baseUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments"
$viewUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/view-db"

Write-Host "--- 1. Testing Create ---"
$id = Get-Random -Minimum 1000 -Maximum 9999
$create = Invoke-RestMethod -Uri $baseUrl -Method Post -Body (@{ patientName="Test Fix"; patientCedula="999"; dateStr="2024-12-31"; time="$id" } | ConvertTo-Json) -ContentType "application/json"
$apptId = $create.appointment.id
Write-Host "Created ID: $apptId"

Write-Host "`n--- 2. Testing Update (PUT) ---"
try {
    $update = Invoke-RestMethod -Uri $baseUrl -Method Put -Body (@{ id=$apptId; status="APROBADA"; color="bg-green" } | ConvertTo-Json) -ContentType "application/json"
    Write-Host "Update Success: $($update.success)"
    Write-Host "New Status: $($update.appointment.status)"
} catch {
    Write-Error "Update Failed: $_"
}

Write-Host "`n--- 3. Testing View DB (HTML) ---"
try {
    $html = Invoke-RestMethod -Uri $viewUrl -Method Get
    if ($html -match "<table") {
        Write-Host "View DB returned HTML Table: Success"
    } else {
        Write-Host "View DB returned unexpected content."
    }
} catch {
    Write-Error "View DB Failed: $_"
}
