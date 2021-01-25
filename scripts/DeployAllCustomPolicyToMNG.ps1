<#
	.SYNOPSIS
        1. Deploys one policy to mangement group



	.DESCRIPTION

         


	.EXAMPLE
	   .\DeployPolicyToMNG.ps1 -topLevelManagementGroupPrefix MRIT -file <File name From esPoliciesDefinitionsCustom> 
	   
	.LINK

	.Notes
		NAME:      DeployPolicyToMNG
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (



    [Parameter(Mandatory = $true)]
    [string]$topLevelManagementGroupPrefix ,

    [string]$location = "WestEurope",


    [string]$environment = "AzureCLoud"


)
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
            Headers     = @{ 
                'authorization' = "Bearer $($token.AccessToken)"
            }
            Method      = $Method
            Uri         = $Uri
            Body        = $Body | ConvertTo-Json -Depth 100 
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
        elseif ((($response.StatusCode -eq 201) -or ($response.StatusCode -eq 200)) -and ($Method -eq "Put")  ) {

            return $Response

        }
        else {
            Write-Host "Error Execute " $Uri
            
            Write-Host "Error Response " $response.StatusCode  ": " $response.StatusDescription
            return $Response
        }
    }
}

$context = Get-AzContext 

# Get a token 
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
$token = $profileClient.AcquireAccessToken($context.Tenant.Id)
  

$Azureurl = Get-AzEnvironment -Name $environment




  
$polFiles = get-childitem "$PSScriptRoot/../esPoliciesDefinitionsCustom/*.json"

foreach ($policyfile in $polFiles) {

    write-host "process file $($policyfile.Name)"
  


    [PSObject]$definitionConfig = Get-Content    $policyfile | ConvertFrom-Json 
    $definitionName = "$( $definitionConfig.name)"

        
    $Uri = "$($Azureurl.ResourceManagerUrl)providers/Microsoft.Management/managementgroups/$($topLevelManagementGroupPrefix)/providers/Microsoft.Authorization/policyDefinitions/$($definitionName)?api-version=2019-09-01"
    $Method = "Put"
    $Body = $definitionConfig
    $response = Add-AzureRequestManagemenytAPI -uri $Uri -token  $token -body $body  -method $Method
        
    $status = $response.StatusDescription
    $status 
      
        

}
