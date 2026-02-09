# Test de Migración a Supabase Directo
# Este script prueba que la aplicación funciona correctamente con Supabase

Write-Host "=== PRUEBA DE MIGRACION SUPABASE DIRECTO ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Verificar que Supabase está accesible
Write-Host "[1/5] Verificando conexión a Supabase..." -ForegroundColor Yellow
$SUPABASE_URL = "https://vfbujngupbnvmlomzfgg.supabase.co"
$SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmYnVqbmd1cGJudm1sb216ZmdnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDYwMzU3MCwiZXhwIjoyMDg2MTc5NTcwfQ.jNHJ-2N3STg9vlKXW8sV3knsfjwe4XQfhfaT-Mwob4M"

try {
    $headers = @{
        "apikey"        = $SUPABASE_KEY
        "Authorization" = "Bearer $SUPABASE_KEY"
    }
    $test = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/users?select=count" -Headers $headers
    Write-Host "✓ Supabase conectado correctamente" -ForegroundColor Green
}
catch {
    Write-Host "✗ Error conectando a Supabase: $_" -ForegroundColor Red
    exit 1
}

# Test 2: Verificar archivos modificados
Write-Host "`n[2/5] Verificando archivos modificados..." -ForegroundColor Yellow
$files = @(
    "public\config.js",
    "public\supabase-client.js",
    "public\register.html",
    "public\login.html",
    "public\agenda.html"
)

$allExist = $true
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $file NO ENCONTRADO" -ForegroundColor Red
        $allExist = $false
    }
}

if (-not $allExist) {
    Write-Host "`n✗ Faltan archivos necesarios" -ForegroundColor Red
    exit 1
}

# Test 3: Verificar que config.js tiene Supabase configurado
Write-Host "`n[3/5] Verificando configuración..." -ForegroundColor Yellow
$configContent = Get-Content "public\config.js" -Raw
if ($configContent -match "SUPABASE_URL" -and $configContent -match "USE_SUPABASE_DIRECT") {
    Write-Host "✓ config.js configurado correctamente" -ForegroundColor Green
}
else {
    Write-Host "✗ config.js no tiene configuración de Supabase" -ForegroundColor Red
    exit 1
}

# Test 4: Verificar que supabase-client.js existe y tiene las funciones
Write-Host "`n[4/5] Verificando helper de Supabase..." -ForegroundColor Yellow
$helperContent = Get-Content "public\supabase-client.js" -Raw
$functions = @("registerUser", "loginUser", "createAppointment", "getAppointments", "updateAppointment")
$allFunctionsExist = $true
foreach ($func in $functions) {
    if ($helperContent -match $func) {
        Write-Host "  ✓ $func" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $func NO ENCONTRADA" -ForegroundColor Red
        $allFunctionsExist = $false
    }
}

if (-not $allFunctionsExist) {
    Write-Host "`n✗ Faltan funciones en supabase-client.js" -ForegroundColor Red
    exit 1
}

# Test 5: Verificar que los HTML tienen imports de Supabase
Write-Host "`n[5/5] Verificando imports en HTML..." -ForegroundColor Yellow
$htmlFiles = @("public\register.html", "public\login.html", "public\agenda.html")
foreach ($html in $htmlFiles) {
    $content = Get-Content $html -Raw
    if ($content -match "supabase-js@2" -and $content -match "supabase-client.js") {
        Write-Host "  ✓ $(Split-Path $html -Leaf)" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $(Split-Path $html -Leaf) - Faltan imports" -ForegroundColor Red
        $allExist = $false
    }
}

Write-Host "`n=== RESULTADO ===" -ForegroundColor Cyan
if ($allExist -and $allFunctionsExist) {
    Write-Host "✓ MIGRACIÓN COMPLETADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "`nPróximos pasos:" -ForegroundColor White
    Write-Host "1. Abre la aplicación en el navegador" -ForegroundColor Gray
    Write-Host "2. Intenta registrarte como paciente" -ForegroundColor Gray
    Write-Host "3. Inicia sesión y crea una cita" -ForegroundColor Gray
    Write-Host "4. Verifica que los datos persisten en Supabase" -ForegroundColor Gray
}
else {
    Write-Host "✗ HAY ERRORES EN LA MIGRACIÓN" -ForegroundColor Red
}
