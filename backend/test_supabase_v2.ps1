# Test Script for Supabase V2.0 Backend
$BASE_URL = "https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook"

Write-Host "=== PRUEBA COMPLETA DEL BACKEND SUPABASE V2.0 ===" -ForegroundColor Cyan

# Test 1: Register
Write-Host "`n[1/5] Probando REGISTRO..." -ForegroundColor Yellow
$registerData = @{
    body = @{
        name   = "Test Supabase"
        email  = "test.sb@example.com"
        cedula = "8888888888"
        phone  = "3001234567"
        role   = "patient"
    }
} | ConvertTo-Json -Depth 3

try {
    $regResponse = Invoke-RestMethod -Uri "$BASE_URL/register" -Method POST -Body $registerData -ContentType "application/json"
    Write-Host "OK Registro: $($regResponse.success)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

# Test 2: Login
Write-Host "`n[2/5] Probando LOGIN..." -ForegroundColor Yellow
$loginData = @{
    body = @{
        cedula = "8888888888"
    }
} | ConvertTo-Json -Depth 3

try {
    $loginResponse = Invoke-RestMethod -Uri "$BASE_URL/login" -Method POST -Body $loginData -ContentType "application/json"
    Write-Host "OK Login: $($loginResponse.success)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

# Test 3: Create Appointment
Write-Host "`n[3/5] Probando CREAR CITA..." -ForegroundColor Yellow
$apptData = @{
    body = @{
        patientName   = "Test Supabase"
        patientCedula = "8888888888"
        dateStr       = "2026-02-20"
        time          = "14:00"
        type          = "Consulta"
    }
} | ConvertTo-Json -Depth 3

try {
    $apptResponse = Invoke-RestMethod -Uri "$BASE_URL/appointments" -Method POST -Body $apptData -ContentType "application/json"
    Write-Host "OK Cita creada: ID $($apptResponse.appointment.id)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

# Test 4: View Database
Write-Host "`n[4/5] Probando VISTA DE BASE DE DATOS..." -ForegroundColor Yellow
try {
    $dbView = Invoke-RestMethod -Uri "$BASE_URL/agenda-view" -Method GET
    if ($dbView -match "Usuarios Registrados") {
        Write-Host "OK Vista de DB generada" -ForegroundColor Green
    }
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

# Test 5: Available Hours
Write-Host "`n[5/5] Probando HORAS DISPONIBLES..." -ForegroundColor Yellow
try {
    $availHours = Invoke-RestMethod -Uri "$BASE_URL/appointments/available-hours?date=2026-02-20" -Method GET
    Write-Host "OK Horas disponibles: $($availHours.availableSlots)/$($availHours.totalSlots)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

Write-Host "`n=== PRUEBAS COMPLETADAS ===" -ForegroundColor Cyan
