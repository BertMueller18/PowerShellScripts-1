﻿
<#
    .SYNOPSIS
        Connects to CloudMigrationService.net
         
    .DESCRIPTION
        Creates remote PowerShell connection to Hosted Exchange Server 2016 as Goran Manot.
        This was originally a function but if it is set that way then it has problems with importing commands. 
        That can be overcomed by replacing Import-PSSession $Session with: 
        Import-Module (Import-PSSession $Session -DisableNameChecking -AllowClobber) -Global -DisableNameChecking -Force
        but in that case it returned all commands without formatting, e.g. get-mailbox goran.manot would return result
        as it has | fl at the end. It would do the same for any get command.

    .EXAMPLE
        Connect-CloudMigrationService
    
        Connects to Hosted Exchange server 2010 as primary admin (GM)
#>
    
$fullDomain = "cloudmigrationservice.net"
$AdminName = Get-Content "D:\Credentials\Username.txt"
$FullAdminName = $AdminName + "@" + $fullDomain
$Pass = Get-Content "D:\Credentials\Password.txt" | ConvertTo-SecureString
$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $FullAdminName, $Pass

try
{
    $SessionOptions = New-PSSessionOption –SkipCACheck –SkipCNCheck –SkipRevocationCheck
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://mail.cloudmigrationservice.net/powershell -Authentication Basic -Credential $Cred –SessionOption $SessionOptions
    Import-PSSession $Session 
}
catch
{
    Write-Output "Connection has failed"
    Write-Output $_.ErrorID
    Write-Output $_.Exception.Message
    break
}

