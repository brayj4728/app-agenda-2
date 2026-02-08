# Script para crear flujo N8N limpio con campo phone
$backupPath = "backend/n8n_workflow_BACKUP.json"
$outputPath = "backend/n8n_workflow_FINAL.json"

Write-Host "Creando flujo N8N limpio con campo phone..." -ForegroundColor Cyan

# Leer el backup original
$json = Get-Content $backupPath -Raw | ConvertFrom-Json

# Buscar y actualizar el nodo "Register Logic"
$updated = $false
foreach ($node in $json.nodes) {
    if ($node.name -eq "Register Logic") {
        Write-Host "✓ Encontrado nodo 'Register Logic'" -ForegroundColor Green
        
        # Código actualizado con campo phone
        $node.parameters.functionCode = "const staticData = getWorkflowStaticData('global');\nif (!staticData.users) { staticData.users = []; }\n\nconst body = items[0].json.body;\n\n// Create User Object WITH PHONE FIELD\nconst newUser = {\n  id: Date.now(),\n  name: body.name,\n  email: body.email,\n  cedula: body.cedula,\n  phone: body.phone || '',\n  role: body.role || 'patient',\n  type: body.type || '',\n  registeredAt: new Date().toISOString()\n};\n\nstaticData.users.push(newUser);\n\nreturn [{ json: { success: true, user: newUser } }];"
        
        Write-Host "✓ Campo 'phone' agregado al código" -ForegroundColor Green
        $updated = $true
    }
}

if ($updated) {
    # Guardar el JSON actualizado
    $json | ConvertTo-Json -Depth 100 | Set-Content $outputPath
    Write-Host "✓ Archivo guardado: $outputPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "LISTO! Importa el archivo 'backend/n8n_workflow_FINAL.json' en N8N" -ForegroundColor Cyan
}
else {
    Write-Host "✗ No se encontró el nodo 'Register Logic'" -ForegroundColor Red
}
