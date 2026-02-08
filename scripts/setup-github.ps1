# Script de Configuración de GitHub para Solar Rosette
# Este script ayuda a configurar y verificar la integración con GitHub

param(
    [switch]$Verify,
    [switch]$Setup,
    [switch]$TestAPI
)

# Colores para output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }
function Write-Info { Write-Host $args -ForegroundColor Cyan }

# Cargar variables de entorno
function Load-EnvFile {
    if (Test-Path ".env") {
        Write-Info "Cargando configuración desde .env..."
        Get-Content ".env" | ForEach-Object {
            if ($_ -match '^([^#][^=]+)=(.*)$') {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                Set-Item -Path "env:$name" -Value $value
            }
        }
        Write-Success "✓ Configuración cargada"
        return $true
    }
    else {
        Write-Error "✗ Archivo .env no encontrado"
        return $false
    }
}

# Verificar configuración
function Verify-Setup {
    Write-Info "`n=== Verificando Configuración de GitHub ==="
    
    $allGood = $true
    
    # Verificar archivo .env
    if (Test-Path ".env") {
        Write-Success "✓ Archivo .env existe"
    }
    else {
        Write-Error "✗ Archivo .env no encontrado"
        $allGood = $false
    }
    
    # Verificar .gitignore
    if (Test-Path ".gitignore") {
        $gitignoreContent = Get-Content ".gitignore" -Raw
        if ($gitignoreContent -match "\.env") {
            Write-Success "✓ .env está en .gitignore"
        }
        else {
            Write-Error "✗ .env NO está protegido en .gitignore"
            $allGood = $false
        }
    }
    
    # Verificar workflows
    if (Test-Path ".github\workflows\ci.yml") {
        Write-Success "✓ Workflow de CI configurado"
    }
    else {
        Write-Error "✗ Workflow de CI no encontrado"
        $allGood = $false
    }
    
    # Verificar token de GitHub
    if (Load-EnvFile) {
        if ($env:GITHUB_TOKEN) {
            Write-Success "✓ Token de GitHub configurado"
        }
        else {
            Write-Error "✗ Token de GitHub no encontrado en .env"
            $allGood = $false
        }
    }
    
    if ($allGood) {
        Write-Success "`n✓ Configuración completa y correcta"
    }
    else {
        Write-Error "`n✗ Hay problemas en la configuración"
    }
    
    return $allGood
}

# Probar API de GitHub
function Test-GitHubAPI {
    Write-Info "`n=== Probando Conexión con GitHub API ==="
    
    if (-not (Load-EnvFile)) {
        return $false
    }
    
    if (-not $env:GITHUB_TOKEN) {
        Write-Error "✗ Token de GitHub no configurado"
        return $false
    }
    
    try {
        Write-Info "Probando autenticación..."
        
        $headers = @{
            "Authorization" = "token $env:GITHUB_TOKEN"
            "Accept"        = "application/vnd.github.v3+json"
        }
        
        $response = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method Get
        
        Write-Success "✓ Autenticación exitosa"
        Write-Info "Usuario: $($response.login)"
        Write-Info "Nombre: $($response.name)"
        Write-Info "Repositorios públicos: $($response.public_repos)"
        
        return $true
    }
    catch {
        Write-Error "✗ Error al conectar con GitHub API"
        Write-Error $_.Exception.Message
        return $false
    }
}

# Configuración inicial
function Setup-GitHub {
    Write-Info "`n=== Configuración Inicial de GitHub ==="
    
    # Verificar si .env existe
    if (-not (Test-Path ".env")) {
        if (Test-Path ".env.example") {
            Write-Info "Copiando .env.example a .env..."
            Copy-Item ".env.example" ".env"
            Write-Success "✓ Archivo .env creado"
            Write-Info "Por favor, edita .env y agrega tu GITHUB_TOKEN"
        }
        else {
            Write-Error "✗ No se encontró .env.example"
            return $false
        }
    }
    
    Write-Info "`nPara obtener un token de GitHub:"
    Write-Info "1. Ve a https://github.com/settings/tokens"
    Write-Info "2. Click en 'Generate new token (classic)'"
    Write-Info "3. Selecciona los scopes: repo, workflow, read:org"
    Write-Info "4. Copia el token y agrégalo a .env como GITHUB_TOKEN"
    
    return $true
}

# Main
Write-Info "Solar Rosette - GitHub Setup Script"
Write-Info "====================================`n"

if ($Setup) {
    Setup-GitHub
}
elseif ($Verify) {
    Verify-Setup
}
elseif ($TestAPI) {
    Test-GitHubAPI
}
else {
    Write-Info "Uso:"
    Write-Info "  .\scripts\setup-github.ps1 -Setup     # Configuración inicial"
    Write-Info "  .\scripts\setup-github.ps1 -Verify    # Verificar configuración"
    Write-Info "  .\scripts\setup-github.ps1 -TestAPI   # Probar API de GitHub"
}
