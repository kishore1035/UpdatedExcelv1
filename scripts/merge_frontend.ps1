# Merge frontend source from the Etherx_Excelv1-main project into this project
# Usage (from PowerShell):
#   .\scripts\merge_frontend.ps1

$source = "c:\Users\Dell\Downloads\Etherx_Excelv1-main\etherx-excel-frontend"
$target = "c:\Users\Dell\Downloads\EtherX-_Excel-main\EtherX-_Excel-main"

if (-not (Test-Path $source)) {
    Write-Error "Source folder not found: $source"
    exit 1
}
if (-not (Test-Path $target)) {
    Write-Error "Target folder not found: $target"
    exit 1
}

# Backup current src
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backup = Join-Path $target "src_backup_$timestamp"
Write-Output "Backing up existing src to $backup"
Copy-Item -Path (Join-Path $target 'src') -Destination $backup -Recurse -Force

# Create destination for imported frontend to avoid overwriting critical target files
$dest = Join-Path $target 'src_etherx_frontend'
if (Test-Path $dest) {
    Write-Output "Removing existing $dest"
    Remove-Item -Path $dest -Recurse -Force
}

Write-Output "Copying frontend src from $source to $dest"
Copy-Item -Path (Join-Path $source 'src') -Destination $dest -Recurse -Force

# Copy top-level assets like index.html and vite config if user wants (commented out by default)
# Copy-Item -Path (Join-Path $source 'index.html') -Destination (Join-Path $target 'index.frontend.html') -Force
# Copy-Item -Path (Join-Path $source 'vite.config.ts') -Destination (Join-Path $target 'vite.config.frontend.ts') -Force

Write-Output "Frontend source copied to: $dest"
Write-Output "Next steps: review files in src_etherx_frontend, then merge or replace files as needed."
