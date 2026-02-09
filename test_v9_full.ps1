# Solar Rosette V9.0 ULTIMATE - End-to-End Test Suite

$BaseUrl = "https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook"
$Date = (Get-Date).AddDays(1).ToString("yyyy-MM-dd") # Tomorrow
$Cedula = "123456789" # Test Patient

function Test-Step {
    param($Name, $ScriptBlock)
    Write-Host "[:] TESTING: $Name..." -NoNewline
    try {
        $res = & $ScriptBlock
        if ($res.success -eq $true -or $res -match "V9.0") {
            Write-Host " [OK]" -ForegroundColor Green
            return $res
        }
        else {
            Write-Host " [FAIL]" -ForegroundColor Red
            Write-Host "   Response: $($res | ConvertTo-Json -Depth 2)" -ForegroundColor Gray
            return $null
        }
    }
    catch {
        Write-Host " [ERROR]" -ForegroundColor Red
        Write-Host "   Exception: $($_.Exception.Message)" -ForegroundColor Gray
        return $null
    }
}

Write-Host "--- STARTING V9.0 ULTIMATE SYSTEM TEST ---`n" -ForegroundColor Cyan

# 1. PING
Test-Step "Connectivity (Ping)" {
    Invoke-RestMethod -Uri "$BaseUrl/ping" -Method Get
} | Out-Null

# 2. AVAILABILITY (20-min slots)
$avail = Test-Step "Availability (20-min Slots)" {
    Invoke-RestMethod -Uri "$BaseUrl/appointments/available-hours-v7?date=$Date" -Method Get
}
if ($avail) {
    Write-Host "   > Slots Found: $($avail.availableHours.Count)" -ForegroundColor Gray
    Write-Host "   > Sample: $($avail.availableHours[0]), $($avail.availableHours[1])" -ForegroundColor Gray
}

# 3. LOGIN PATIENT
$user = Test-Step "Auth (Login Patient)" {
    $body = @{ cedula = $Cedula; role = "patient" }
    Invoke-RestMethod -Uri "$BaseUrl/login" -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
}

# 4. CREATE APPOINTMENT
$appt = $null
if ($avail.availableHours.Count -gt 0) {
    $slot = $avail.availableHours[0]
    $appt = Test-Step "Process (Create Appt at $slot)" {
        $body = @{
            patientName   = "Test User Automated";
            patientCedula = $Cedula;
            dateStr       = $Date;
            time          = $slot;
            type          = "Prueba Sistema V9"
        }
        Invoke-RestMethod -Uri "$BaseUrl/appointments" -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
    }
}
else {
    Write-Host "   [SKIP] Cannot create appt (No slots)" -ForegroundColor Yellow
}

# 5. UPDATE APPOINTMENT (Professional Action)
if ($appt.success) {
    $id = $appt.appointment.id
    Test-Step "Process (Professional Approve ID: $id)" {
        $body = @{ id = $id; status = "APROBADA"; color = "bg-green" }
        Invoke-RestMethod -Uri "$BaseUrl/appointments" -Method Put -Body ($body | ConvertTo-Json) -ContentType "application/json"
    } | Out-Null

    # 6. DELETE APPOINTMENT
    Test-Step "Process (Delete Appt ID: $id)" {
        $body = @{ id = $id }
        Invoke-RestMethod -Uri "$BaseUrl/appointments" -Method Delete -Body ($body | ConvertTo-Json) -ContentType "application/json"
    } | Out-Null
}

Write-Host "`n--- TEST COMPLETE ---" -ForegroundColor Cyan
