
Write-Host "--- TEST: SERVER-SIDE DOWNLOADING ---"

# 1. Test HTML View Link
try {
    Write-Host "1. Testing Admin Page..."
    $response = Invoke-WebRequest -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users" -Method Get
    $content = $response.Content
    
    if ($content -match 'href="download"') {
        Write-Host "✅ Standard HTML Link found."
    } else {
        Write-Host "❌ HTML Link MISSING."
    }
} catch {
    Write-Host "❌ Admin Page Request Failed: $_"
}

# 2. Test Download Endpoint
try {
    Write-Host "`n2. Testing /download Endpoint..."
    $dlResponse = Invoke-WebRequest -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users/download" -Method Get
    $csvContent = $dlResponse.Content
    $headers = $dlResponse.Headers

    Write-Host "Content-Type: $($headers['Content-Type'])"
    Write-Host "Disposition: $($headers['Content-Disposition'])"

    if ($csvContent -match "Nombre;Cédula") {
        Write-Host "✅ CSV Headers Correct."
    } else {
        Write-Host "❌ CSV Headers MISSING."
    }
    
    Write-Host "`nSample CSV:"
    Write-Host $csvContent.Substring(0, [math]::Min(200, $csvContent.Length))

} catch {
    Write-Host "❌ Download Request Failed: $_"
}
