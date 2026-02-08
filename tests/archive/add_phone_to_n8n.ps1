# Script para agregar campo 'phone' al flujo de N8N
$jsonPath = "backend/n8n_workflow.json"
$json = Get-Content $jsonPath -Raw | ConvertFrom-Json

# Buscar el nodo "Register Logic"
foreach ($node in $json.nodes) {
    if ($node.name -eq "Register Logic") {
        Write-Host "Encontrado nodo 'Register Logic'" -ForegroundColor Green
        
        # El nuevo código con el campo phone
        $node.parameters.functionCode = "const staticData = getWorkflowStaticData('global');\nif (!staticData.users) { staticData.users = []; }\n\nconst body = items[0].json.body;\n\n// Create User Object WITH PHONE FIELD\nconst newUser = {\n  id: Date.now(),\n  name: body.name,\n  email: body.email,\n  cedula: body.cedula,\n  phone: body.phone || '',\n  role: body.role || 'patient',\n  type: body.type || '',\n  registeredAt: new Date().toISOString()\n};\n\nstaticData.users.push(newUser);\n\nreturn [{ json: { success: true, user: newUser } }];"
        
        Write-Host "Campo 'phone' agregado" -ForegroundColor Green
    }
}

# Guardar
$json | ConvertTo-Json -Depth 100 | Set-Content $jsonPath
Write-Host "Archivo guardado!" -ForegroundColor Cyan
