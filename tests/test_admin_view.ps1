
Write-Host "--- TEST: GET USERS (ADMIN VIEW) ---"
try {
    $response = Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users" -Method Get
    Write-Host "Success! Users found:"
    $response.users | Format-Table id, name, email, role -AutoSize
} catch {
    Write-Host "Request Failed: " $_.Exception.Message
    Write-Host "Make sure the workflow is ACTIVE and updated with the new Webhook Node."
}
