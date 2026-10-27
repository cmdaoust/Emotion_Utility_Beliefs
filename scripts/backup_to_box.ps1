# ====================================================================
#  Back up participant data to Box over SFTP (Emotion Utility Beliefs)
#
#  Run it from the desktop shortcut (backup_to_box.bat) at the end of
#  every testing session. The same script works on both lab PCs:
#    Stimulus PC: uploads the PsychoPy data folder  -> raw_psychopy
#    Biopac PC:   uploads the Biopac recordings     -> raw_physiology
#
#  Whoever runs it logs in with THEIR OWN Box account each time:
#  their Box email and their Box-specific password (not the university
#  password). Nothing is saved on this PC.
#
#  It only UPLOADS new files. It never deletes or changes anything on
#  this PC or in Box, and it never creates folders in Box.
#
#  Needs WinSCP installed (https://winscp.net).
# ====================================================================

$ErrorActionPreference = 'Stop'

# ---------- SETTINGS -------------------------------------------------
$BoxHost = 'sftp.services.box.com'
# Box's published SFTP host key (see "Using Box with SFTP" on support.box.com).
$HostKey = 'ecdsa-sha2-nistp256 256 An60IqVqISRa3o2GRscno7QLnsTrIy0BGIchIAvJ9ZM'

# Where the Box folders can appear, depending on who logs in:
#  - students: the folders are shared with them, so they sit at the top
#    level of their Box ("/raw_psychopy")
#  - Carmen: they sit inside her own folder structure
# The first location that exists for the logged-in account is used.
$RemoteBases = @(
    '',
    '/Carmen MD PhD/Emotion_Utility_Beliefs'
)
# ---------------------------------------------------------------------

$Docs = [Environment]::GetFolderPath('MyDocuments')
if (-not $Docs) { $Docs = Join-Path $env:USERPROFILE 'Documents' }
$LogDir = Join-Path $Docs 'box_backup_logs'

$Jobs = @(
    @{ Label  = 'PsychoPy data'
       Local  = Join-Path $Docs 'Github\Emotion_Utility_Beliefs\experiment\task\data'
       Folder = 'raw_psychopy' },
    @{ Label  = 'Biopac recordings'
       Local  = Join-Path $Docs 'Carmen MD Emotion_Utility_Beliefs\data'
       Folder = 'raw_physiology' }
)

function Show-Result {
    param([bool]$Ok, [string]$Title, [string[]]$Lines)
    $bg = if ($Ok) { 'DarkGreen' } else { 'DarkRed' }
    Write-Host ''
    Write-Host ('  ' + ('=' * 62)) -ForegroundColor White -BackgroundColor $bg
    Write-Host ('   ' + $Title.PadRight(60)) -ForegroundColor White -BackgroundColor $bg
    foreach ($l in $Lines) {
        Write-Host ('   ' + ([string]$l).PadRight(60)) -ForegroundColor White -BackgroundColor $bg
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
$log      = ''
try {
    # ---- Checks before asking for a login ----------------------------
    $dll = Find-WinScpDll
    if (-not $dll) {
        Show-Result $false 'BACKUP NOT DONE: WinSCP is not installed' @(
            'Tell Carmen: WinSCP needs installing on this PC.')
        return
    }
    $active = @($Jobs | Where-Object { Test-Path $_.Local })
    if ($active.Count -eq 0) {
        Show-Result $false 'BACKUP NOT DONE: no data folder found on this PC' @(
            'Looked for:', $Jobs[0].Local, $Jobs[1].Local, 'Tell Carmen.')
        return
    }

    # ---- Ask for the Box login (used once, never saved) --------------
    Write-Host ''
    Write-Host '  Log in with YOUR Box account:'
    Write-Host '    User name: your university email address'
    Write-Host '    Password:  your Box-specific password'
    Write-Host '               (NOT your university password)'
    Write-Host ''
    $cred = $null
    try {
        $cred = Get-Credential -Message 'Box login: your email and your Box-specific password (not your university password)'
    } catch { $cred = $null }
    if (-not $cred -or -not $cred.UserName) {
        Show-Result $false 'BACKUP NOT DONE: login cancelled' @(
            'Run the backup again and enter your Box login.')
        return
    }

    Add-Type -Path $dll
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
    $cred = $null

    $session = New-Object WinSCP.Session
    $session.SessionLogPath = $log   # WinSCP never writes passwords to its log

    Write-Host '  Connecting to Box...'
    $session.Open($opts)
    $opts = $null

    # ---- Upload ------------------------------------------------------
    $transfer = New-Object WinSCP.TransferOptions
    # Skip empty files (Box SFTP can't store 0-byte files) and Windows junk.
    $transfer.FileMask = '*>0 | desktop.ini; Thumbs.db'
    # Box doesn't keep file times, so compare by size, not date.
    $transfer.PreserveTimestamp = $false

    $failed  = @()
    $summary = @()
    foreach ($job in $active) {
        Write-Host ''
        Write-Host ("  {0}" -f $job.Label)

        # Find the Box folder for the logged-in account. Never create it:
        # a missing folder means it hasn't been shared with this account.
        $remote = $null
        foreach ($base in $RemoteBases) {
            $candidate = "$base/$($job.Folder)"
            if ($session.FileExists($candidate)) { $remote = $candidate; break }
        }
        if (-not $remote) {
            $failed  += $job.Label
            $summary += ("{0}: Box folder '{1}' not found" -f $job.Label, $job.Folder)
            Write-Host ("    PROBLEM: the Box folder '{0}' isn't shared with this account." -f $job.Folder) -ForegroundColor Red
            continue
        }

        Write-Host ("    From: {0}" -f $job.Local)
        Write-Host ("    To:   Box{0}" -f $remote)
        try {
            # Remote mode, removeFiles = $false, mirror = $false:
            # upload new or changed files only, never delete anything.
            $result = $session.SynchronizeDirectories(
                [WinSCP.SynchronizationMode]::Remote,
                $job.Local, $remote, $false, $false,
                [WinSCP.SynchronizationCriteria]::Size, $transfer)
            $result.Check()
            foreach ($u in $result.Uploads) { Write-Host ("    uploaded {0}" -f (Split-Path $u.FileName -Leaf)) }
            $summary += ("{0}: {1} file(s) uploaded" -f $job.Label, $result.Uploads.Count)
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
            'If a Box folder was not found: ask Carmen to share it',
            'with your Box account.',
            'Otherwise close PsychoPy and the Biopac software, check',
            'the internet connection, and run this again.',
            'If it fails again, tell Carmen and send her the log:',
            $log))
    }
}
catch {
    $msg  = $_.Exception.Message
    $hint = @('Check the internet connection and try again.')
    if ($msg -match 'Authentication|password|Access denied|denied') {
        $hint = @('Box refused the login. Check you used your Box',
                  'email and your Box-specific password, NOT your',
                  'university password, then run this again.')
    }
    elseif ($msg -match 'service_blocked|403') {
        $hint = @('Box SFTP is not switched on for your account.',
                  'Tell Carmen.')
    }
    elseif ($msg -match 'host key|fingerprint') {
        $hint = @('Box server identity did not match.',
                  'Do not retry; tell Carmen.')
    }
    Show-Result $false 'BACKUP NOT DONE: could not log in to Box' ($hint + @(
        'If it keeps failing, tell Carmen and send her the log:',
        $log))
    Write-Host ("  Details: {0}" -f $msg) -ForegroundColor DarkGray
}
finally {
    if ($session) { $session.Dispose() }
    Write-Host ''
    Read-Host '  Press Enter to close this window' | Out-Null
    exit $exitCode
}
