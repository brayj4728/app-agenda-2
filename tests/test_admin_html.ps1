
Write-Host "--- TEST: GET USERS (HTML VIEW) ---"
try {
    # Using 'Invoke-WebRequest' to get raw content
    $response = Invoke-WebRequest -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users" -Method Get
    
    $content = $response.Content
    Write-Host "Status: $($response.StatusCode)"
    Write-Host "Content Type: $($response.Headers['Content-Type'])"
    
    if ($content -match "<table") {
        Write-Host "✅ Table Found"
    } else {
        Write-Host "❌ Table NOT Found in output"
    }

    if ($content -match "Descargar Excel") {
        Write-Host "✅ Download Button Found"
    } else {
        Write-Host "❌ Download Button NOT Found"
    }

    # Print a snippet
    Write-Host "`nSnippet of Content:"
    Write-Host $content.Substring(0, [math]::Min(500, $content.Length))
} catch {
    Write-Host "Request Failed: " $_.Exception.Message
}
