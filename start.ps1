# 🚀 Script de Inicio Rápido - Solar Rosette (Windows)
# Este script inicia un servidor local para desarrollo

Write-Host "🌟 Solar Rosette - Sistema de Gestión de Citas" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Node.js está instalado
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js detectado: $nodeVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Node.js no está instalado" -ForegroundColor Red
    Write-Host "📥 Descarga Node.js desde: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}

# Verificar si http-server está instalado
$httpServerInstalled = $null
try {
    $httpServerInstalled = Get-Command http-server -ErrorAction Stop
} catch {
    Write-Host "📦 Instalando http-server..." -ForegroundColor Yellow
    npm install -g http-server
}

Write-Host "🚀 Iniciando servidor local..." -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Abriendo en: http://localhost:8000" -ForegroundColor Green
Write-Host "📂 Sirviendo desde: .\public" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Presiona Ctrl+C para detener el servidor" -ForegroundColor Yellow
Write-Host ""

# Iniciar servidor
Set-Location public
http-server -p 8000 -o

# Nota: -o abre automáticamente el navegador
