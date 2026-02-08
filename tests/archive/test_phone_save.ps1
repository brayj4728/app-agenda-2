# Test if N8N is saving phone numbers
$testUser = @{
    name   = "Test Phone User"
    email  = "testphone@test.com"
    cedula = "8888888888"
    phone  = "3001234567"
    role   = "patient"
} | ConvertTo-Json

Write-Host "Testing N8N Registration with Phone..." -ForegroundColor Cyan
Write-Host "Sending: $testUser" -ForegroundColor Gray

try {
    $response = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/register" -Method POST -Body $testUser -ContentType "application/json"
    Write-Host "`nSUCCESS!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
    
    # Check if phone was saved
    if ($response.user.phone) {
        Write-Host "`n✓ PHONE SAVED: $($response.user.phone)" -ForegroundColor Green
    }
    else {
        Write-Host "`n✗ PHONE NOT SAVED!" -ForegroundColor Red
        Write-Host "N8N workflow needs to be updated!" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "`nERROR!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# Now get the user back to verify
Write-Host "`n---" -ForegroundColor Gray
Write-Host "Getting user back from N8N..." -ForegroundColor Cyan

try {
    $getResponse = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users?cedula=8888888888" -Method GET
    Write-Host "User data:" -ForegroundColor Green
    $getResponse | ConvertTo-Json -Depth 10
    
    if ($getResponse.user.phone) {
        Write-Host "`n✓ PHONE RETRIEVED: $($getResponse.user.phone)" -ForegroundColor Green
    }
    else {
        Write-Host "`n✗ PHONE MISSING IN DATABASE!" -ForegroundColor Red
    }
}
catch {
    Write-Host "Error getting user: $($_.Exception.Message)" -ForegroundColor Red
}
