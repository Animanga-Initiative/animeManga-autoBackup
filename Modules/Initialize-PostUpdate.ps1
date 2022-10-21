#!/usr/bin/env pwsh
#Requires -Version 7

[CmdletBinding()]
Param(
    <#
    .SYNOPSIS
        Do a post initialization after updating script
    #>
)

Write-Verbose -Message "[$(Get-Date)] Initialize Post Update"

Function Update-Backupper {
    $path = "./.github/workflows/backup.yaml"
    $loadYaml = Get-Content -Path $path -Raw

    # Replace update frequency
    Write-Verbose -Message "[$(Get-Date)] Replace backup frequency"
    If ($Env:BACKUP_FREQ) {
        $loadYaml = $loadYaml -Replace 'cron: 0 0 * * SUN', "cron: `"$($Env:BACKUP_FREQ)`""
        $loadYaml | Out-File -FilePath $path -Encoding utf8 -Force
        Write-Verbose -Message "[$(Get-Date)] Backup frequency updated"
    }
    Else {
        Write-Verbose -Message "[$(Get-Date)] Backup frequency not updated"
    }
}

Function Update-Updater {
    $path = "./.github/workflows/updateRepository.yaml"
    $loadYaml = Get-Content -Path $path -Raw

    # Replace update frequency
    Write-Verbose -Message "[$(Get-Date)] Replace Update frequency"
    If ($Env:UPDATE_FREQ) {
        $loadYaml = $loadYaml -Replace 'cron: "0 0 * * *"', "cron: `"$($Env:UPDATE_FREQ)`""
        $loadYaml | Out-File -FilePath $path -Encoding utf8 -Force
        Write-Verbose -Message "[$(Get-Date)] Update frequency updated"
    }
    Else {
        Write-Verbose -Message "[$(Get-Date)] Update frequency not updated"
    }
}

<#
Function Remove-RepoTrash {
    $filePath = @(
        "./.github/dependabot.yml",
        "./Modules/Get-AniDBBackup.py"
    )
    ForEach ($file in $filePath) {
        Write-Verbose "[$(Get-Date)] Removing $($file)"
        Remove-Item -Path $file
    }
} #>

Update-Backupper
Update-Updater
