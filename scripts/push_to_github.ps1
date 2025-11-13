<#
Push the current project to a GitHub repository.

Usage (PowerShell):
  1) Ensure you are authenticated to GitHub (recommended):
     - `gh auth login` (follow prompts)
     OR
     - Have a Personal Access Token (PAT) ready when prompted by Git.

  2) Run this script from the project root:
     cd "C:\Users\Dell\Downloads\EtherX-_Excel-main\EtherX-_Excel-main"
     .\scripts\push_to_github.ps1 -RemoteUrl "https://github.com/kishore1035/updatedExcel.git"

This script:
  - initializes a git repo if needed
  - sets branch `main`
  - optionally replaces remote `origin` if it exists
  - commits all changes (if there are staged/uncommitted changes)
  - attempts to push to the provided remote URL

Note: For security, do not paste PATs into this script. Use `gh auth login` or Git credential prompt.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$RemoteUrl
)

function Exec($cmd) {
    Write-Output "-> $cmd"
    $r = cmd /c $cmd
    Write-Output $r
}

$cwd = Get-Location
Write-Output "Project folder: $cwd"

# Initialize repo if necessary
if (-not (Test-Path (Join-Path $cwd '.git'))) {
    Write-Output "No .git detected — initializing repository."
    Exec "git init"
    Exec "git branch -M main"
} else {
    Write-Output ".git exists — skipping git init."
}

# Configure identity if not set
$userName = (& git config user.name) -join ''
$userEmail = (& git config user.email) -join ''
if (-not $userName -or -not $userEmail) {
    Write-Output "Setting temporary commit identity (you can change this later)."
    Exec "git config user.name \"Your Name\""
    Exec "git config user.email \"you@example.com\""
}

# Remote handling
$existsOrigin = $false
try {
    $remotes = git remote -v 2>$null
    if ($remotes) { $existsOrigin = $remotes -match '^origin' }
} catch { }

if ($existsOrigin) {
    Write-Output "A remote named 'origin' already exists. Removing and replacing it with provided remote URL."
    Exec "git remote remove origin"
}
Exec "git remote add origin $RemoteUrl"

# Stage and commit
# If no commits exist, create an initial commit even if empty
$hasCommits = $true
try { git rev-parse --verify HEAD 2>$null } catch { $hasCommits = $false }

Exec "git add -A"

$changes = cmd /c "git status --porcelain"
if ($changes -and $changes.Trim()) {
    $msg = "Integrate Etherx frontend - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Exec "git commit -m \"$msg\""
} elseif (-not $hasCommits) {
    # create empty initial commit
    Exec "git commit --allow-empty -m \"Initial commit: integrate Etherx frontend\""
} else {
    Write-Output "No changes to commit."
}

# Push
Write-Output "Attempting to push to origin/main..."
try {
    Exec "git push -u origin main"
    Write-Output "Push completed (if no errors were shown)."
} catch {
    Write-Error "Push failed. Common causes: authentication required, remote has conflicting history."
    Write-Output "If auth failed, run: `gh auth login` then re-run this script, or provide a PAT when Git prompts."
    Write-Output "If remote has existing commits, you may need to pull and merge or force push (destructive):"
    Write-Output "  git pull --rebase origin main"
    Write-Output "  git push -u origin main"
}

Write-Output "Done."