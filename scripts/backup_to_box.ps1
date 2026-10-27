# ====================================================================
#  Back up participant data to Box over SFTP (Emotion Utility Beliefs)
#
#  Run it from the desktop shortcut (backup_to_box.bat) at the end of
#  every testing session. The same script works on both lab PCs:
#    Stimulus PC: uploads the PsychoPy data folder  -> raw_psychopy
#    Biopac PC:   uploads the Biopac recordings     -> raw_physiology
#
#  It only UPLOADS new files. It never deletes or changes anything on
#  this PC or in Box.
#
#  One-time setup on each PC: run setup_box_login.bat first.
#  Needs WinSCP installed (https://winscp.net).
# ====================================================================

param([switch]$TestConnection)

$ErrorActionPreference = 'Stop'

# ---------- SETTINGS -------------------------------------------------
$BoxHost    = 'sftp.services.box.com'
# Box's published SFTP host key (see "Using Box with SFTP" on support.box.com).
$HostKey    = 'ecdsa-sha2-nistp256 256 An60IqVqISRa3o2GRscno7QLnsTrIy0BGIchIAvJ9ZM'
$RemoteRoot = '/Carmen MD PhD/Emotion_Utility_Beliefs'
# ---------------------------------------------------------------------

$Docs     = [Environment]::GetFolderPath('MyDocuments')
if (-not $Docs) { $Docs = Join-Path $env:USERPROFILE 'Documents' }
$CredFile = Join-Path $env:LOCALAPPDATA 'EmotionUtilityBeliefs\box_sftp_credential.xml'
$LogDir   = Join-Path $Docs 'box_backup_logs'

$Jobs = @(
    @{ Label  = 'PsychoPy data'
       Local  = Join-Path $Docs 'Github\Emotion_Utility_Beliefs\experiment\task\data'
       Remote = "$RemoteRoot/raw_psychopy" },
    @{ Label  = 'Biopac recordings'
       Local  = Join-Path $Docs 'Carmen MD Emotion_Utility_Beliefs\data'
       Remote = "$RemoteRoot/raw_physiology" }
)

function Show-Result {
    param([bool]$Ok, [string]$Title, [string[]]$Lines)
    $bg = if ($Ok) { 'DarkGreen' } else { 'DarkRed' }
    Write-Host ''
    Write-Host ('  ' + ('=' * 62)) -ForegroundColor White -BackgroundColor $bg
    Write-Host ('   ' + $Title.PadRight(60)) -ForegroundColor White -BackgroundColor $bg
    foreach ($l in $Lines) {
        Write-Host ('   ' + $l.PadRight(60)) -ForegroundColor White -BackgroundColor $bg
    }
    if (-not $Ok) {
        Write-Host ('   ' + 'Nothing has been deleted. All the data is still on this PC.'.PadRight(60)) -ForegroundColor White -BackgroundColor $bg
    }
    Write-Host ('  ' + ('=' * 62)) -ForegroundColor White -BackgroundColor $bg
    Write-Host ''
}

function Find-WinScpDll {
    $bases = @(${env:ProgramFiles(x86)}, $env:ProgramFiles, (Join-Path $env:LOCALAPPDATA 'Programs')) | Where-Object { $_ }
    foreach ($b in $bases) {
        $c = Join-Path $b 'WinSCP\WinSCPnet.dll'
        if (Test-Path $c) { return $c }
    }
    return $null
}

$exitCode = 1
$session  = $null
try {
    # ---- Checks before connecting ------------------------------------
    if (-not (Test-Path $CredFile)) {
        Show-Result $false 'BACKUP NOT DONE: no Box login saved on this PC' @(
            'Tell Carmen: setup_box_login.bat needs to be run',
            'on this PC, logged in to this Windows account.')
        return
    }
    $dll = Find-WinScpDll
    if (-not $dll) {
        Show-Result $false 'BACKUP NOT DONE: WinSCP is not installed' @(
            'Tell Carmen: WinSCP needs installing on this PC.')
        return
    }
    $active = @($Jobs | Where-Object { Test-Path $_.Local })
    if (-not $TestConnection -and $active.Count -eq 0) {
        Show-Result $false 'BACKUP NOT DONE: no data folder found on this PC' @(
            'Looked for:',
            $Jobs[0].Local,
            $Jobs[1].Local,
            'Tell Carmen.')
        return
    }

    Add-Type -Path $dll
    $cred = Import-Clixml -Path $CredFile

    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $log   = Join-Path $LogDir ("backup_{0}_{1}.log" -f $env:COMPUTERNAME, $stamp)

    $opts = New-Object WinSCP.SessionOptions -Property @{
        Protocol              = [WinSCP.Protocol]::Sftp
        HostName              = $BoxHost
        PortNumber            = 22
        UserName              = $cred.UserName
        SecurePassword        = $cred.Password
        SshHostKeyFingerprint = $HostKey
    }

    $session = New-Object WinSCP.Session
    $session.SessionLogPath = $log

    Write-Host ''
    Write-Host '  Connecting to Box...'
    $session.Open($opts)

    if (-not $session.FileExists($RemoteRoot)) {
        Show-Result $false 'BACKUP NOT DONE: study folder not found in Box' @(
            "Expected: $RemoteRoot",
            'Tell Carmen: the folder or the login needs checking.')
        return
    }

    if ($TestConnection) {
        Show-Result $true 'CONNECTION OK' @(
            'Logged in to Box and found the study folder.')
        $exitCode = 0
        return
    }

    # ---- Upload ------------------------------------------------------
    $transfer = New-Object WinSCP.TransferOptions
    # Skip empty files (Box SFTP can't store 0-byte files) and Windows junk.
    $transfer.FileMask = '*>0 | desktop.ini; Thumbs.db'
    # Box doesn't keep file times, so compare by size, not date.
    $transfer.PreserveTimestamp = $false

    $failed = @()
    $summary = @()
    foreach ($job in $active) {
        Write-Host ''
        Write-Host ("  Uploading {0}..." -f $job.Label)
        Write-Host ("    From: {0}" -f $job.Local)
        Write-Host ("    To:   Box{0}" -f $job.Remote)
        try {
            if (-not $session.FileExists($job.Remote)) {
                $session.CreateDirectory($job.Remote)
            }
            # Remote mode, removeFiles = $false, mirror = $false:
            # upload new or changed files only, never delete anything.
            $result = $session.SynchronizeDirectories(
                [WinSCP.SynchronizationMode]::Remote,
                $job.Local, $job.Remote, $false, $false,
                [WinSCP.SynchronizationCriteria]::Size, $transfer)
            $result.Check()
            $n = $result.Uploads.Count
            foreach ($u in $result.Uploads) { Write-Host ("    uploaded {0}" -f (Split-Path $u.FileName -Leaf)) }
            $summary += ("{0}: {1} file(s) uploaded" -f $job.Label, $n)
        }
        catch {
            $failed  += $job.Label
            $summary += ("{0}: FAILED" -f $job.Label)
            Write-Host ("    PROBLEM: {0}" -f $_.Exception.Message) -ForegroundColor Red
        }
    }

    if ($failed.Count -eq 0) {
        Show-Result $true 'BACKUP COMPLETE' ($summary + @('The files are now in Box.'))
        $exitCode = 0
    }
    else {
        Show-Result $false 'BACKUP NOT COMPLETE: some files were not uploaded' ($summary + @(
            'Close PsychoPy and the Biopac software, check the',
            'internet connection, then run this again.',
            'If it fails again, tell Carmen and send her the log:',
            $log))
    }
}
catch {
    $msg = $_.Exception.Message
    $hint = 'Check the internet connection and try again.'
    if ($msg -match 'Authentication|password|Access denied') {
        $hint = 'The Box login was refused. Tell Carmen.'
    }
    elseif ($msg -match 'service_blocked|403') {
        $hint = 'Box SFTP is switched off for this account. Tell Carmen.'
    }
    elseif ($msg -match 'host key|fingerprint') {
        $hint = 'Box server identity did not match. Do not retry; tell Carmen.'
    }
    Show-Result $false 'BACKUP NOT DONE: could not connect to Box' @(
        $hint,
        'If it keeps failing, tell Carmen and send her the log:',
        "$log")
    Write-Host ("  Details: {0}" -f $msg) -ForegroundColor DarkGray
}
finally {
    if ($session) { $session.Dispose() }
    Write-Host ''
    Read-Host '  Press Enter to close this window' | Out-Null
    exit $exitCode
}
