try {
    $iterationMax = 10
    $iterationStart = 1;
    $displayName = $datasource.commonname
    
    function Remove-StringLatinCharacters
    {
        PARAM ([string]$String)
        [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
    }
    
    for($i = $iterationStart; $i -lt $iterationMax; $i++) {
        
    	$sAMAccountName = $displayName
    	$alias = $displayName
    	
        if($i -eq $iterationStart) {
            $sAMAccountName = $sAMAccountName
            $cn = $displayName
        } else {
            $sAMAccountName = $sAMAccountName + "$i"
            $cn = $displayName + "$i"
        }
    	
    	$sAMAccountName = $sAMAccountName.ToLower()
    	$sAMAccountName = Remove-StringLatinCharacters $sAMAccountName
    	$sAMAccountName = $sAMAccountName.trim() -replace '\s+', ''
    	
    	$upn = $sAMAccountName + "@" + $ADuserUPNsuffix
        $mailadres = $upn
        
        
        Write-information "Searching for AD user sAMAccountName=$sAMAccountName or userPrincipalName=$upn"
        $found = Get-ADUser -Filter{sAMAccountName -eq $sAMAccountName -or userPrincipalName -eq $upn}
    
        if(@($found).count -eq 0) {
            $returnObject = @{samaccountname=$sAMAccountName; displayname=$displayName; userPrincipalName=$upn ; mail=$mailadres ; commonName=$cn; alias=$sAMAccountName}
            Write-information "AD User sAMAccountName=$sAMAccountName or userPrincipalName=$upn not found"
            break;
        } else {
            Write-information "AD User sAMAccountName=$sAMAccountName or userPrincipalName=$upn found"
        }
    }
} catch {
    Write-error "Error generating names. Error: $($_.Exception.Message)"
}


if(-not [string]::IsNullOrEmpty($returnObject)) {
   Write-output $returnObject
}
