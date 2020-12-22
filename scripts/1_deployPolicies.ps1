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

    [string]$policyfolder = "esPoliciesAll",

    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99",

    [string]$environment = "AzureCLoud"
    


)
 
class LogStatus {
    [string]$PolicyName;
    [string]$DefinitionName;
    [string]$PolicyStatus;
    [string]$ErrMsg
} 

function Add-AzureRequestManagemenytAPI {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $Uri,
        [Parameter(Mandatory = $true, Position = 1)]
        $token,
        [Parameter(Mandatory = $true, Position = 2)]
        $Body,
        [Parameter( Position = 3)]
        $Method = "Get"
            
    )
    process {
        ## Write-Host "Execute " $Uri
        ## Write-Host $token.accesToken
        $Params = @{ 
            ContentType = 'application/json'
            Headers = @{ 
                'authorization' = "Bearer $($token.AccessToken)"
            }
            Method = $Method
            Uri = $Uri
            Body = $Body | ConvertTo-Json -Depth 100 
        }
        Try { 
            $Response = Invoke-WebRequest @Params
        } 
        catch {

            Write-Host "Error Execute " $Uri
                
            Write-Host "Error Response " $_.Exception  ": " $_.ErrorDetails
            $response = @()
            $response  | Add-Member -MemberType NoteProperty -Name "StatusCode"  -Value  $_.Exception 
            $response | Add-Member -MemberType NoteProperty -Name "StatusDescription"  -Value  $_.ErrorDetails

            Return $Response
        }
        


        If (($response.StatusCode -eq 200) -and ($Method -eq "Get")  ) {

            return $Response.Content | ConvertFrom-Json
        
        }
        elseif((($response.StatusCode -eq 201) -or ($response.StatusCode -eq 200)) -and ($Method -eq "Put")  ){

            return $Response

        }
        else {
            Write-Host "Error Execute " $Uri
                
            Write-Host "Error Response " $response.StatusCode  ": " $response.StatusDescription
            return $Response
        }
    }
}

$Logobject = @()


$polFiles = get-childitem "$PSScriptRoot/../$policyfolder/*.json"

$context = Get-AzContext 


if ($context.Subscription.id -ne $SubscriptionId) {
    Try { 
        Set-AzContext -SubscriptionId $SubscriptionId  -ErrorAction Stop
    } 
    catch {
        throw $_
    }
}

# Get a token 
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$token = $profileClient.AcquireAccessToken($Context.Tenant.Id)
  

$Azureurl = Get-AzEnvironment -Name $environment

foreach ($policy in $polFiles) {
    [PSObject]$definitionConfig = Get-Content    $policy | ConvertFrom-Json 
    $PolicyObject = [PSCustomObject] @{
        properties = $definitionConfig.Properties
    }
    $definitionName = "$( $definitionConfig.name)$($version)"
    If ($definitionConfig.properties.PolicyRule) {
        write-host $definitionConfig.Name
        $Uri = "$($Azureurl.ResourceManagerUrl)subscriptions/$SubscriptionId/providers/Microsoft.Authorization/policyDefinitions/$($definitionName)?api-version=2019-09-01"
        
    #    $Uri = "$($Azureurl.ResourceManagerUrl)providers/Microsoft.Management/managementgroups/marie/providers/Microsoft.Authorization/policyDefinitions/$($definitionName)?api-version=2019-09-01"
        $Method = "Put"
        $Body = $definitionConfig
        $response = Add-AzureRequestManagemenytAPI -uri $Uri -token  $token -body $body  -method $Method
        
        $status = $response.StatusDescription
        $status 
        $Logobject += @([LogStatus]@{
                PolicyName     = $policy.Name;
                DefinitionName = $definitionName;
                PolicyStatus   = $status;
                ErrMsg         = $ErrMsg;
            })    
        

    }
     
       
}

foreach ($policy in $polFiles) {
    [PSObject]$definitionConfig = Get-Content    $policy | ConvertFrom-Json 
    $PolicyObject = [PSCustomObject] @{
        properties = $definitionConfig.Properties
    }
    $definitionName = "$( $definitionConfig.name)$($version)"
    If ($definitionConfig.properties.PolicyDefinitions) {

        write-host $definitionConfig.Name      

        $Uri = "$($Azureurl.ResourceManagerUrl)subscriptions/$SubscriptionId/providers/Microsoft.Authorization/policySetDefinitions/$($definitionName)?api-version=2019-09-01"
        $Method = "Put"
        $Body = $definitionConfig
        $response = Add-AzureRequestManagemenytAPI -uri $Uri -token  $token -body $body  -method $Method

        $status = $response.StatusDescription 
        $Logobject += @([LogStatus]@{
                PolicyName     = $policy.Name;
                DefinitionName = $definitionName;
                PolicyStatus   = $status;
                ErrMsg         = $ErrMsg;
            })    
        

    }
     
       
}


$Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoS