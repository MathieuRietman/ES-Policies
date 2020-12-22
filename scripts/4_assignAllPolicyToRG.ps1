<#
	.SYNOPSIS
        1. Deploy all policies from folder to SUbscription to test



	.DESCRIPTION

         


	.EXAMPLE
	   .\DeployPolicies.ps1 
	   
	.LINK

	.Notes
		NAME:      DeployPolicies
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$policyfolder = "esPolicies2",

    [string]$subscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99",

    [string]$resourceGroup = "testpolicies",
    
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


Get-AzResourceGroup -Name $resourceGroup -ev notPresent -ea 0 
if ($notPresent) { 

    New-AzResourceGroup -Name $resourceGroup -Location $location -Tags $Tags 
}
else { write-Host "Resource Group already exists" } 

$polFiles = get-childitem "$PSScriptRoot/../$policyfolder/*.json"

$configFile = "$PSScriptRoot/config/$($configJson).json"
If (Test-Path -Path $configFile ) {
    [PSObject]$BodyString = (Get-Content $configFile | ConvertFrom-Json).general



    $context = Get-AzContext 

    if ($context.Subscription.id -ne $subscriptionId) {
        Try { 
            Set-AzContext -subscriptionId $subscriptionId  -ErrorAction Stop
        } 
        catch {
            throw $_
        }
    }



    foreach ($policy in $polFiles) {
        [PSObject]$definitionConfig = Get-Content    $policy | ConvertFrom-Json 
        $PolicyObject = [PSCustomObject] @{
            properties = $definitionConfig.Properties
        }
        $definitionName = "$( $definitionConfig.name)_$($version)"

        [PSObject]$ParametersInPolicy = $PolicyObject.properties.Parameters
        [hashtable]$parameters = @{ }

        $PolicyObject.properties.Parameters.PSobject.Properties | foreach-object {
            $parametername = $_.Name 
            if ($parametername -ne "effect") { 
                $parameters[$parametername] = $BodyString.$($parametername)
            }
        }

        $status = "succes"
        $ErrMsg = ""
        $status = $null
        $policyDefinition = Get-AzPolicyDefinition -Name  $definitionName  -subscriptionId $subscriptionId
        If ( $policyDefinition.Properties.PolicyRule.then.details.roleDefinitionIds) {
            try {
                $status = New-AzPolicyAssignment -Name $definitionName  -PolicyDefinition $policyDefinition  -Scope  $BodyString.SCOPE -PolicyParameterObject $parameters -Location $BodyString.location -AssignIdentity 
            }
            catch {
                $status = "failed"
                $ErrMsg = $_.Exception.ErrorRecord.Exception.Message
            }  
            if ($status) {
                write-host "set security"
                foreach ($roleDefinitionIds in  $PolicyObject.properties.PolicyRule.then.details.roleDefinitionIds) {
                    $roleDefinitionID = ($roleDefinitionIds -split "/")[-1]
                    write-host "Adding Role $roleDefinitionID"
                    # $principle = get-azman
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
                    If (!(Get-AzRoleAssignment -Scope $BodyString.scope -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId)){}
                    New-AzRoleAssignment -Scope $BodyString.scope -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId 
                    New-AzRoleAssignment -Scope "/subscriptions/$($BodyString.managementsubscriptionId)" -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId
                    New-AzRoleAssignment -Scope "/subscriptions/$subscriptionId" -RoleDefinitionId $roleDefinitionID -ObjectId $status.Identity.principalId
                }

                
            }

        }
        else {
            if ( $parameters -eq @()) {
                try {
                    $status = New-AzPolicyAssignment -Name $definitionName  -PolicyDefinition $policyDefinition  -Scope  $BodyString.SCOPE 
                } 
                catch {
                    $status = "failed"
                    $ErrMsg = $_.Exception.ErrorRecord.Exception.Message
                }  
            } 
            else {
                
           
                try {
                    $status = New-AzPolicyAssignment -Name $definitionName  -PolicyDefinition $policyDefinition  -Scope  $BodyString.SCOPE -PolicyParameterObject $parameters
                } 
                catch {
                    $status = "failed"
                    $ErrMsg = $_.Exception.ErrorRecord.Exception.Message
                }  
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
else {
    Write-Host "No config file found"   
}

$Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoS