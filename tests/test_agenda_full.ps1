$ErrorActionPreference = "Stop"

$baseUrl = "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments"
$cedula = "TEST999"
$otherCedula = "TEST888"

Write-Host "--- 1. Limpiando entorno (Borrar previos) ---"
try {
    $existing = Invoke-RestMethod -Uri "$baseUrl?cedula=$cedula&role=patient" -Method Get
    if ($existing.appointments) {
        foreach ($app in $existing.appointments) {
            Invoke-RestMethod -Uri $baseUrl -Method Delete -Body (@{id=$app.id} | ConvertTo-Json) -ContentType "application/json" | Out-Null
        }
    }
} catch { Write-Host "Nada que limpiar o error menor." }

Write-Host "`n--- 2. Creando Cita para $cedula ---"
$rand = Get-Random -Minimum 1000 -Maximum 9999
$testDate = "2026-01-01"
$testTime = "$($rand % 12):00am"

$payload = @{
    patientName = "Test User $rand"
    patientCedula = $cedula
    dateStr = $testDate
    time = $testTime
    type = "Cita de Prueba"
}
$createRes = Invoke-RestMethod -Uri $baseUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType "application/json"
Write-Host "Creado: $($createRes.success) - ID: $($createRes.id)"

if (-not $createRes.success) {
    Write-Error "Fallo al crear cita."
}

# 3. GET (Read)
Write-Host "`n--- 3. Verificando Cita (Lectura) ---"
$getUri = "$baseUrl" + "?cedula=$cedula&role=patient"
$getRes = Invoke-RestMethod -Uri $getUri -Method Get
$myAppt = $getRes.appointments | Where-Object { $_.dateStr -eq "2024-12-25" }

if ($myAppt) {
    Write-Host "✅ Cita encontrada correctamente."
} else {
    Write-Error "❌ Cita NO encontrada."
}

Write-Host "`n--- 4. Verificando Aislamiento (Otro usuario) ---"
$otherUri = "$baseUrl" + "?cedula=$otherCedula&role=patient"
$otherRes = Invoke-RestMethod -Uri $otherUri -Method Get
$leak = $otherRes.appointments | Where-Object { $_.patientCedula -eq $cedula }

if ($leak) {
    Write-Error "❌ FALLO DE SEGURIDAD: Usuario 888 vio la cita de 999."
} else {
    Write-Host "✅ Seguridad OK: Usuario 888 no ve nada."
}

Write-Host "`n--- 5. Eliminando Cita ---"
if ($myAppt.id) {
    $delRes = Invoke-RestMethod -Uri $baseUrl -Method Delete -Body (@{id=$myAppt.id} | ConvertTo-Json) -ContentType "application/json"
    Write-Host "Eliminado: $($delRes.success)"
    
    # Verify deletion
    $checkRes = Invoke-RestMethod -Uri "$baseUrl?cedula=$cedula&role=patient" -Method Get
    $stillThere = $checkRes.appointments | Where-Object { $_.id -eq $myAppt.id }
    
    if ($stillThere) {
        Write-Error "❌ La cita sigue ahí después de borrar."
    } else {
        Write-Host "✅ Cita eliminada correctamente."
    }
}

Write-Host "`n🎉 PRUEBA COMPLETADA CON ÉXITO 🎉"
