﻿
function Create-NewO365Destination
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$False)]
        [String]$domain 
    )
    if ($domain -like "devcmp*.onmicrosoft.com")
    {

        # connect to O365
        $UserCredential = Get-Credential
        
        Connect-MsolService
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
        
        Import-PSSession $Session
        
        # create an array of users which will be created
        $users = New-Object System.Collections.ArrayList
        $users.Add("atila bala")
        $users.Add("nemanja tomic")
        $users.Add("fedor hajdu")
        $users.Add("milan stojanovic")
        $users.Add("slavisa radicevic")
        $users.Add("paula novokmet")
        $users.Add("robert sebescen")
        $users.Add("dragan eremic")
        $users.Add("vladimir pecanac")
        $users.Add("milivoj kovacevic")
        $users.Add("martin jonas")
        $users.Add("dragana berber")
        $users.Add("danijel avramov")
        $users.Add("dejan babic")
        $users.Add("Babara Harcharik")
        $users.Add("Brenton Byus")
        $users.Add("Catrice Hartz")
        $users.Add("Doris Luening")
        $users.Add("Ebony Tott")
        $users.Add("Florentino Snobeck")
        $users.Add("Ila Lockamy")
        $users.Add("Lovie Geronime")
        $users.Add("Lucretia Sangalli")
        $users.Add("Randell Fleniken")
        
        # Crate user account from users in the array
        foreach ($user in $users) 
        {
            $u = New-Object System.Collections.ArrayList
            $u = $user.Split(" ")
            
            $first = $u[0]
            $last = $u[1]
            
            $upn = $first + "." + $last + $domain
            
            New-MsolUser -FirstName $first -LastName $last -UserPrincipalName $upn -Password m1cr0s0ft$ -DisplayName $user -PasswordNeverExpires $true -ForceChangePassword $false
            
            set-msoluser -userprincipalname $upn -usagelocation RS
            
            $tenant = (Get-MsolAccountSku).AccountObjectId
            Set-MsolUserLicense -TenantId $tenant -UserPrincipalName $upn -AddLicenses (Get-MsolAccountSku -TenantId $tenant).AccountSkuId
        }
    }
    else
    {
        $ErrorText = "Domain must be in devcmpXX.onmicrosoft.com format.
        Youre entry is: $domain"
        Write-Host $ErrorText -ForegroundColor Red
    }

    # apply impersonation rights for goran.manot user on whole domain
    Enable-OrganizationCustomization
    $User = "goran.manot" + $domain
    New-ManagementRoleAssignment -Role ApplicationImpersonation -User $User
    Remove-PSSession $Session
}