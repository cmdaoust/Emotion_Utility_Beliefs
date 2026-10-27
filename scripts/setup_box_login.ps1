# ====================================================================
#  One-time setup: save the Box SFTP login on this PC
#
#  Run once on each lab PC, while logged in to the Windows account that
#  will run the backup (e.g. Lab on the Stimulus PC, cm909 on the
#  Biopac PC). Run it again whenever the Box password changes.
#
#  The password is encrypted with Windows DPAPI: only this Windows user
#  on this PC can decrypt it. It is never written in plain text, and it
#  is stored outside the repo, so it can't end up on GitHub.
# ====================================================================

$ErrorActionPreference = 'Stop'

$CredDir  = Join-Path $env:LOCALAPPDATA 'EmotionUtilityBeliefs'
$CredFile = Join-Path $CredDir 'box_sftp_credential.xml'

Write-Host ''
Write-Host '  Save the Box SFTP login for this PC'
Write-Host '  -----------------------------------'
Write-Host '  User name: the Box account email address'
Write-Host '  Password:  the Box-specific password (Box > Account Settings >'
Write-Host '             Account > Authentication), NOT the university login.'
Write-Host ''

$cred = Get-Credential -Message 'Box SFTP login: Box email and Box-specific password'
if (-not $cred) {
    Write-Host '  Cancelled. Nothing was saved.'
    Read-Host '  Press Enter to close this window' | Out-Null
    exit 1
}

New-Item -ItemType Directory -Force -Path $CredDir | Out-Null
$cred | Export-Clixml -Path $CredFile

Write-Host ''
Write-Host "  Saved (encrypted) to: $CredFile"
Write-Host '  Now testing the connection to Box...'

& (Join-Path $PSScriptRoot 'backup_to_box.ps1') -TestConnection
