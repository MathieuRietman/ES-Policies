<#
	.SYNOPSIS
        1. SortPolicies based on policy.json and extract policiy definition and policy Initiatives
        2. require the sample policies.json in the same folder .



	.DESCRIPTION

         


	.EXAMPLE
	   .\createCustomPolicyFrom.ps1  
	   
	.LINK

	.Notes
		NAME:      createCustomPolicyFileAndDeploy
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

	[string]$policySourcefile = "policies1.json",

	[string]$policyOldWithRightSort = "policies.json",

	[string]$policyNew = "policies2.json"



)



$Root = $PSScriptRoot + "/"
$FilePolicy = "$($Root)./$policyOldWithRightSort"
$FileOutputPolicy = "$($Root)./$policyNew"
$FilePolicySource = "$($Root)./$policySourcefile"

$BodyString = Get-Content $FilePolicy | ConvertFrom-Json 

$NewObject = @()
$NewObject = [PSObject]$BodyString

$NewObject.variables.policies.policyDefinitions = @()
$NewObject.variables.initiatives.policySetDefinitions = @()



$BodyStringSource = Get-Content $FilePolicySource  | ConvertFrom-Json 
$newPolicyDefinitions = @()
$newPolicySetDefinitions = @()

If (Test-Path -Path $FilePolicy  ) {

	$BodyString = Get-Content $FilePolicy  | ConvertFrom-Json 

	foreach ( $PolicyDef in  $BodyString.variables.initiatives.policySetDefinitions) {
		$name = $policyDef.Name
		foreach ( $PolicyDefSource in  $BodyStringSource.variables.initiatives.policySetDefinitions) {

			if ($name -eq $PolicyDefSource.name) {
	
				$PolicyObject = [PSCustomObject] @{
					properties = $policyDef.Properties
					name       = $policyDef.Name
				}
				$newPolicySetDefinitions += $PolicyObject
			}
	

		
		}
	}
	#Add new ones
	foreach ( $PolicyDef in  $BodyStringSource.variables.initiatives.policySetDefinitions) {
		$name = $policyDef.Name
		$find = $false
		foreach ( $PolicyDefSource in  $BodyString.variables.initiatives.policySetDefinitions) {

			if ($name -eq $PolicyDefSource.name) {
				$find = $true
			
			}
		
		}
		if (!$find) {
			$PolicyObject = [PSCustomObject] @{
				properties = $policyDef.Properties
				name       = $policyDef.Name
			}
			$newPolicySetDefinitions += $PolicyObject
		}
	}

	foreach ( $PolicyDef in  $BodyString.variables.policies.policyDefinitions) {

		$name = $policyDef.Name
		foreach ( $PolicyDefSource in  $BodyStringSource.variables.policies.policyDefinitions) {

			if ($name -eq $PolicyDefSource.name) {
	
				$PolicyObject = [PSCustomObject] @{
					properties = $policyDef.Properties
					name       = $policyDef.Name
				}
				$newPolicyDefinitions += $PolicyObject
			}
	

		
		}

	}
	#Add new ones
	foreach ( $PolicyDef in   $BodyStringSource.variables.policies.policyDefinitions) {
		$name = $policyDef.Name
		$find = $false
		foreach ( $PolicyDefSource in  $BodyString.variables.policies.policyDefinitions) {

			if ($name -eq $PolicyDefSource.name) {
				$find = $true
			
			}
		
		}
		if (!$find) {
			$PolicyObject = [PSCustomObject] @{
				properties = $policyDef.Properties
				name       = $policyDef.Name
			}
			$newPolicyDefinitions += $PolicyObject
		}
	}

	$NewObject.variables.policies.policyDefinitions = $newPolicyDefinitions
	$NewObject.variables.initiatives.policySetDefinitions = $newPolicySetDefinitions
	$NewObject |  ConvertTo-Json  -Depth 100 | out-file  $FileOutputPolicy
	write-host "generated new file  $($FileOutputPolicy)"

   
}
else {

	write-host "Missing input file $FilePolicy" -ForegroundColor Red
	exit
}

