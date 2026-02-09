# Script para probar conexión directa a Supabase
# Esto verifica que las credenciales y tablas funcionan

$SUPABASE_URL = "https://vfbujngupbnvmlomzfgg.supabase.co"
$SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmYnVqbmd1cGJudm1sb216ZmdnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDYwMzU3MCwiZXhwIjoyMDg2MTc5NTcwfQ.jNHJ-2N3STg9vlKXW8sV3knsfjwe4XQfhfaT-Mwob4M"

Write-Host "=== PRUEBA DE CONEXION SUPABASE ===" -ForegroundColor Cyan

# Test 1: Listar usuarios
Write-Host "`n[1/3] Obteniendo usuarios..." -ForegroundColor Yellow
try {
    $headers = @{
        "apikey"        = $SUPABASE_KEY
        "Authorization" = "Bearer $SUPABASE_KEY"
    }
    $users = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/users?select=*" -Headers $headers
    Write-Host "OK - Usuarios encontrados: $($users.Count)" -ForegroundColor Green
    if ($users.Count -gt 0) {
        Write-Host "Ejemplo: $($users[0].name) - $($users[0].cedula)" -ForegroundColor Gray
    }
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

# Test 2: Listar citas
Write-Host "`n[2/3] Obteniendo citas..." -ForegroundColor Yellow
try {
    $appts = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/appointments?select=*" -Headers $headers
    Write-Host "OK - Citas encontradas: $($appts.Count)" -ForegroundColor Green
    if ($appts.Count -gt 0) {
        Write-Host "Ejemplo: $($appts[0].patient_name) - $($appts[0].date_str)" -ForegroundColor Gray
    }
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

# Test 3: Insertar usuario de prueba
Write-Host "`n[3/3] Insertando usuario de prueba..." -ForegroundColor Yellow
try {
    $newUser = @{
        name          = "Test Direct"
        email         = "test.direct@example.com"
        cedula        = "6666666666"
        phone         = "3001234567"
        role          = "patient"
        registered_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    } | ConvertTo-Json

    $headers["Content-Type"] = "application/json"
    $headers["Prefer"] = "return=representation"
    
    $result = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/users" -Method POST -Headers $headers -Body $newUser
    Write-Host "OK - Usuario creado: ID $($result[0].id)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

Write-Host "`n=== PRUEBA COMPLETADA ===" -ForegroundColor Cyan
Write-Host "Si ves 'OK' en los 3 tests, Supabase funciona correctamente." -ForegroundColor White
