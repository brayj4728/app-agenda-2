
Write-Host "--- TEST: CLEAN ADMIN VIEW (NO BUTTON) ---"
try {
    $response = Invoke-WebRequest -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users" -Method Get
    $content = $response.Content
    
    # 1. Check Table is there
    if ($content -match "<table") {
        Write-Host "✅ Table Found"
    } else {
        Write-Host "❌ Table MISSING"
    }

    # 2. Check Button is GONE
    if ($content -match "Descargar") {
        Write-Host "❌ Button still visible! (Fail)"
    } else {
        Write-Host "✅ Button Successfully Removed"
    }
    
    # 3. Check /download link is gone
    if ($content -match "href=.download.") {
        Write-Host "❌ Download Link found! (Fail)"
    } else {
        Write-Host "✅ Download Link Cleaned"
    }

} catch {
    Write-Host "Request Failed: " $_.Exception.Message
}
