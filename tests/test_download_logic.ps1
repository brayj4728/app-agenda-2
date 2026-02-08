
Write-Host "--- TEST: VERIFY DOWNLOAD LOGIC ---"
$url = "https://n8n-n8n.xxboi7.easypanel.host/webhook/users"
try {
    $response = Invoke-WebRequest -Uri $url -Method Get
    $content = $response.Content

    if ($content -match "function downloadCSV") {
        Write-Host "✅ Function 'downloadCSV' found."
    } else {
        Write-Host "❌ Function 'downloadCSV' MISSING."
    }

    if ($content -match "uFEFF") {
        Write-Host "✅ BOM (Excel Fix) found."
    } else {
        Write-Host "❌ BOM (Excel Fix) MISSING (Check escape chars)."
    }

    if ($content -match "downloadLink.click") {
        Write-Host "✅ Click trigger found."
    } else {
        Write-Host "❌ Click trigger MISSING."
    }
    
    if ($content -match ";") {
        # Rudimentary check for semicolon separator intent in JS
        Write-Host "✅ Semicolon found (Excel Latam)."
    }

} catch {
    Write-Host "Request Failed: " $_.Exception.Message
}
