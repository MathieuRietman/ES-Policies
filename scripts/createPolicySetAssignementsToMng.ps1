<#
	.SYNOPSIS
        1. makes policy assignement of every initiative in folder esPolicyInitiatives using the parameters specified in the config file  



	.DESCRIPTION

         


	.EXAMPLE
	   .\createPolicySetAssignementsToMng.ps1 -topLevelManagementGroupPrefix MRIT -configJson Test
	   
	.LINK

	.Notes
		NAME:      createPolicySetAssignementsToMng
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$policyfolder = "esPoliciesInitiatives",

    [Parameter(Mandatory = $true)]
    [string]$topLevelManagementGroupPrefix ,

    [string]$Location = "WestEurope",

    
    [Parameter(Mandatory = $true)]
    [argumentcompleter( { (get-childitem "$PSScriptRoot/config/*.json").basename })]
    [string]$configJson,
    
    [string]$version = ""

)
 
class LogStatus {
    [string]$PolicyName;
    [string]$DefinitionName;
    [string]$PolicyStatus;
    [string]$ErrMsg
} 

$Logobject = @()


$polFiles = get-childitem "$PSScriptRoot/../$policyfolder/*.json"

$configFile = "$PSScriptRoot/config/$($configJson).json"
If (Test-Path -Path $configFile ) {
    [PSObject]$BodyString = (Get-Content $configFile | ConvertFrom-Json).general





    $Scope = "/providers/Microsoft.Management/managementGroups/$($topLevelManagementGroupPrefix)"

    foreach ($policy in $polFiles) {
        [PSObject]$definitionConfig = Get-Content    $policy | ConvertFrom-Json 
        $PolicyObject = [PSCustomObject] @{
            properties = $definitionConfig.Properties
        }
        $definitionName = "$( $definitionConfig.name)$($version)"

        [PSObject]$ParametersInPolicy = $PolicyObject.properties.Parameters
        [hashtable]$parameters = @{ }

        $PolicyObject.properties.Parameters.PSobject.Properties | foreach-object {
            $parametername = $_.Name 
            if ($BodyString.$($parametername)) { 
                $parameters[$parametername] = $BodyString.$($parametername)
            }
        }

        $status = "succes"
        $ErrMsg = ""
        $status = $null
 
        If ($PolicyObject.properties.PolicyDefinitions) {
            $definitionName
            $policyDefinition = Get-AzPolicySetDefinition -Name  $definitionName  -ManagementGroupName $topLevelManagementGroupPrefix
            try {
                $status = New-AzPolicyAssignment -Name $definitionName   -PolicySetDefinition $policyDefinition  -Scope  $scope -PolicyParameterObject $parameters -Location $BodyString.location -AssignIdentity 
            }
            catch {
                $status = "failed"
                $ErrMsg = $_.Exception.ErrorRecord.Exception.Message
            }  
            if ($status) {
                write-host "set security"
                #First Build .roleDefinitionIds array of the Defenitions
                $roleId = @()
                Foreach ($Definition in $PolicyObject.properties.PolicyDefinitions) {
             
                    If ($Definition.policyDefinitionId -like "*concat(variables('scope')*") {
                        $Definition.policyDefinitionId=  $Scope + $Definition.policyDefinitionId.TrimStart("[concat(variables('scope'), '")
                        $Definition.policyDefinitionId= $Definition.policyDefinitionId -replace "[')\]]",""
                        
                    }
    
                    $policyDefinition = Get-AzPolicyDefinition -id $Definition.policyDefinitionId
                    if ($policyDefinition.Properties.PolicyRule.then.details.roleDefinitionIds) {
                        foreach ($roleIdPolicyDefinition in $policyDefinition.Properties.PolicyRule.then.details.roleDefinitionIds) {
                            if ($roleId -notcontains $roleIdPolicyDefinition ) {
                                $roleId += $roleIdPolicyDefinition
                            }
                        }
                    }
                }

                foreach ($roleDefinitionIds in  $roleId ) {
                    $roleDefinitionID = ($roleDefinitionIds -split "/")[-1]
                    # $principle = get-azman
                    write-host "Adding Role $roleDefinitionID"
                    $SP = Get-AzADServicePrincipal  -ObjectId $status.Identity.principalId   
                    if (!$SP) {
                        $count = 0
                        DO {
                            Write-Host "waiting until sp is create "                  
                            start-sleep 1
                            $count++

                        }
                    
                        Until (!(Get-AzADServicePrincipal  -ObjectId $status.Identity.principalId) -or ($count -le 10) )
                    
                        if (!$SP) {
                            start-sleep 1
                            $SP = Get-AzADServicePrincipal  -ObjectId $status.Identity.principalId       
                        }
                    }
                    If (!(Get-AzRoleAssignment -Scope $scope -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId)) {
                        New-AzRoleAssignment -Scope $scope -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId 
                    }
                    # If (!(Get-AzRoleAssignment -Scope "/subscriptions/$($BodyString.managementSubscriptionId)"  -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId)) {
                    #     New-AzRoleAssignment -Scope "/subscriptions/$($BodyString.managementSubscriptionId)" -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId
       
                    # }
                }

                
            }

     
     
            $status
            $Logobject += @([LogStatus]@{
                    PolicyName     = $policy.Name;
                    DefinitionName = $definitionName;
                    PolicyStatus   = $status;
                    ErrMsg         = $ErrMsg;
                })    
        }
    }
}
else {
    Write-Host "No config file found"   
}

$Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoS