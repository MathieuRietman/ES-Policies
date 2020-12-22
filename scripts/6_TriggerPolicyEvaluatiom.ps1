<#
	.SYNOPSIS
        1. DoTestDeployments



	.DESCRIPTION

         


	.EXAMPLE
	   .\doTestDeployments
	   
	.LINK

	.Notes
		NAME:      DeployPolicies
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$Scope = "subscriptions/4d035de6-4cb3-4d00-9796-cdbea308da99",


    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99",

    [string]$environment = "AzureCLoud",
    

    [int]$interval = 20

    


)
 


$context = Get-AzContext 

if ($context.Subscription.id -ne $SubscriptionId) {
    Try { 
        "switching subscription to   $SubscriptionId " 
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


$uri = "$($Azureurl.ResourceManagerUrl)$scope/providers/Microsoft.PolicyInsights/policyStates/latest/triggerEvaluation?api-version=2018-07-01-preview"


$Method = "Post"
$Body = ""
$Params = @{ 
 
    Headers     = @{ 
        'authorization' = "Bearer $($token.AccessToken)"
        'Content-Type' = 'application/json'
    }
    Method      = $Method
    UseBasicParsing = $true
 

}

Try { 
    $PostRaw = (Invoke-WebRequest -uri $uri @Params).Rawcontent
    Write-Host "Submitted Policy Evaluation Trigger Request" -foregroundcolor Yellow
} 
catch {

    Write-Host "Error Execute " $uri
        
    Write-Host "Error Response " $_.Exception  ": " $_.ErrorDetails

    exit
}


$PostArray = $PostRaw.Split("`n")
[string]$LocationVar = $($PostArray|Select-String -SimpleMatch "Location")
$Uri = $($LocationVar.Split(" ",2))[1]

$Method = "Get"
$Body = ""
$Params = @{ 
 
    Headers     = @{ 
        'authorization' = "Bearer $($token.AccessToken)"
        'Content-Type' = 'application/json'
    }
    Method      = $Method
    UseBasicParsing = $true
 

}

$GetResults = Invoke-WebRequest -uri $uri @Params
while($GetResults.StatusCode -ne 200)
{
    $PostArray = $PostRaw.Split("`n")
    [string]$LocationVar = $($PostArray|Select-String -SimpleMatch "Location")
    $Uri = $($LocationVar.Split(" ",2))[1]
  

   $GetResults = Invoke-WebRequest -uri $uri @Params
   Write-Host "Status code $($GetResults.Statuscode) returned on query.  Still in progress...waiting $interval seconds to requery" 
   start-sleep $interval
}

Write-Host "Successfully Triggered a Policy Evaluation Request" -foregroundcolor Cyan

        