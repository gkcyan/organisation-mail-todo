# Installe ou met à jour la skill organisation-mail-todo pour Claude Code (Windows).
# Usage : irm https://raw.githubusercontent.com/gkcyan/organisation-mail-todo/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'

$name   = 'organisation-mail-todo'
$zipUrl = "https://github.com/gkcyan/$name/archive/refs/heads/main.zip"
$skills = Join-Path $env:USERPROFILE '.claude\skills'
$dest   = Join-Path $skills $name
$tmp    = Join-Path ([System.IO.Path]::GetTempPath()) ("$name-" + [guid]::NewGuid().ToString('N'))

try {
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    $zip = Join-Path $tmp 'skill.zip'

    Write-Host "Téléchargement de la skill $name..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $zipUrl -OutFile $zip -UseBasicParsing

    Expand-Archive -Path $zip -DestinationPath $tmp -Force
    $source = Join-Path $tmp "$name-main\$name"
    if (-not (Test-Path (Join-Path $source 'SKILL.md'))) {
        throw "SKILL.md introuvable dans l'archive téléchargée."
    }

    New-Item -ItemType Directory -Force -Path $skills | Out-Null
    if (Test-Path $dest) {
        # Conserve la version précédente à côté, sans rien supprimer définitivement
        # (hors du dossier skills, pour ne pas être chargée comme une seconde skill)
        $backups = Join-Path $env:USERPROFILE '.claude\skills-sauvegardes'
        New-Item -ItemType Directory -Force -Path $backups | Out-Null
        $backup = Join-Path $backups ("$name-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
        Move-Item -Path $dest -Destination $backup
        Write-Host "Version précédente conservée dans : $backup"
    }
    Copy-Item -Recurse -Path $source -Destination $dest

    Write-Host "Skill installée dans : $dest"
    Write-Host "Relancez Claude Code, puis tapez / pour vérifier que $name apparaît."
}
finally {
    if (Test-Path $tmp) { Remove-Item -Recurse -Force -Path $tmp }
}
