$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

# variables configured in form
$alias = $form.naming.alias 
$commonname = $form.naming.commonname
$displayname =$form.naming.displayname
$mail = $form.naming.mail
$samaccountname = $form.naming.samaccountname

<#----- Exchange On-Premises: Start -----#>
# Connect to Exchange
try{
    $adminSecurePassword = ConvertTo-SecureString -String "$ExchangeAdminPassword" -AsPlainText -Force
    $adminCredential = [System.Management.Automation.PSCredential]::new($ExchangeAdminUsername,$adminSecurePassword)
    $sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
    $exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $exchangeConnectionUri -Credential $adminCredential -SessionOption $sessionOption -ErrorAction Stop 
    #-AllowRedirection
    $session = Import-PSSession $exchangeSession -DisableNameChecking -AllowClobber
    Write-Information "Successfully connected to Exchange using the URI [$exchangeConnectionUri]" 
    
    $Log = @{
            Action            = "CreateResource" # optional. ENUM (undefined = default) 
            System            = "Exchange On-Premise" # optional (free format text) 
            Message           = "Successfully connected to Exchange using the URI [$exchangeConnectionUri]" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $exchangeConnectionUri # optional (free format text) 
            TargetIdentifier  = $([string]$session.GUID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log 

} catch {
    Write-Error "Error connecting to Exchange using the URI [$exchangeConnectionUri]. Error: $($_.Exception.Message)"
    $Log = @{
            Action            = "CreateResource" # optional. ENUM (undefined = default) 
            System            = "Exchange On-Premise" # optional (free format text) 
            Message           = "Failed to connect to Exchange using the URI [$exchangeConnectionUri]." # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $exchangeConnectionUri # optional (free format text) 
            TargetIdentifier  = $([string]$session.GUID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log
}

# Create distributiongroup
try{
    $exchangeDistributionGroupParams = @{
        Name             = $commonname
        Alias            = $alias
        DisplayName      = $displayname
        SamAccountName   = $samaccountname
        OrganizationalUnit = $ADdistributionGroupsOU
    }
    
    $distributionGroup = New-DistributionGroup @exchangeDistributionGroupParams -ErrorAction Stop
    Write-Information "Successfully created distributiongroup for $commonname" 
    
    $Log = @{
            Action            = "CreateResource" # optional. ENUM (undefined = default) 
            System            = "Exchange On-Premise" # optional (free format text) 
            Message           = "Successfully created distributiongroup for $commonname" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $commonname # optional (free format text) 
            TargetIdentifier  = $([string]$distributionGroup.Guid) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log   
    
}catch{
    Write-Error "Error creating distributiongroup for $commonname.  Error: $($_.Exception.Message)"
    $Log = @{
            Action            = "CreateResource" # optional. ENUM (undefined = default) 
            System            = "Exchange On-Premise" # optional (free format text) 
            Message           = "Error creating distributiongroup for $commonname." # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $commonname # optional (free format text) 
            TargetIdentifier  = $([string]$distributionGroup.SID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log 
}


# Disconnect from Exchange
try{
    Remove-PsSession -Session $exchangeSession -Confirm:$false -ErrorAction Stop
    Write-Information "Successfully disconnected from Exchange using the URI [$exchangeConnectionUri]"     
    $Log = @{
            Action            = "CreateResource" # optional. ENUM (undefined = default) 
            System            = "Exchange On-Premise" # optional (free format text) 
            Message           = "Successfully disconnected from Exchange using the URI [$exchangeConnectionUri]" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $exchangeConnectionUri # optional (free format text) 
            TargetIdentifier  = $([string]$session.GUID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log 
} catch {
    Write-Error "Error disconnecting from Exchange.  Error: $($_.Exception.Message)"
    $Log = @{
            Action            = "CreateResource" # optional. ENUM (undefined = default) 
            System            = "Exchange On-Premise" # optional (free format text) 
            Message           = "Failed to disconnect from Exchange using the URI [$exchangeConnectionUri]." # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $exchangeConnectionUri # optional (free format text) 
            TargetIdentifier  = $([string]$session.GUID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log    
    
}
<#----- Exchange On-Premises: End -----#>
