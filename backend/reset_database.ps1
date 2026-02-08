# Script para purgar datos y configurar nuevo profesional
$BASE_URL = "https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook"

Write-Host "--- EMPEZANDO RESET DE DATOS ---" -ForegroundColor Cyan

# 1. ELIMINAR CITAS (Todas)
Write-Host "`n1. Purgando todas las citas..." -ForegroundColor Yellow
try {
    $deleteAppts = Invoke-RestMethod -Uri "$BASE_URL/appointments" -Method DELETE -Body (@{all = $true } | ConvertTo-Json) -ContentType "application/json"
    Write-Host "Resultado purga citas:" -ForegroundColor Green
    $deleteAppts | ConvertTo-Json
}
catch {
    Write-Host "Error en purga de citas: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. ELIMINAR USUARIOS (deja solo a Carmona Cesar)
Write-Host "`n2. Purgando usuarios..." -ForegroundColor Yellow
try {
    $deleteRes = Invoke-RestMethod -Uri "$BASE_URL/users" -Method DELETE
    Write-Host "Resultado purga usuarios:" -ForegroundColor Green
    $deleteRes | ConvertTo-Json
}
catch {
    Write-Host "Error en purga de usuarios: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. REGISTRAR AL NUEVO PROFESIONAL
Write-Host "`n3. Registrando a Carmona Cesar..." -ForegroundColor Yellow
$newProfessional = @{
    name   = "Carmona Cesar"
    cedula = "1000491639"
    phone  = "3174098558"
    email  = "carmona@profesional.com"
    role   = "professional"
} | ConvertTo-Json

try {
    $regRes = Invoke-RestMethod -Uri "$BASE_URL/register" -Method POST -Body $newProfessional -ContentType "application/json"
    Write-Host "Resultado registro:" -ForegroundColor Green
    $regRes | ConvertTo-Json
}
catch {
    Write-Host "Error en registro: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n--- PROCESO FINALIZADO ---" -ForegroundColor Cyan
Write-Host "Profesional configurado: Carmona Cesar (1000491639)" -ForegroundColor Green
Write-Host "Teléfono: 3174098558" -ForegroundColor Green
