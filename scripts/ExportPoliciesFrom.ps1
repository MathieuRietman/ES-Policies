<#
	.SYNOPSIS
        1. create from policy.json and extract policiy definition and policy Initiatives
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

    [string]$policyFolderExport = "esPoliciesDefinitionsCustomCheck",

    [string]$policyInitiativeExport= "esPoliciesInitiativesCheck"



)

$Root = $PSScriptRoot + "/"
$FilePolicy = "$($Root)./$policySourcefile"

If (!(Test-Path -Path "$($Root)/../$($policyFolderExport)")) { $dummy = New-Item -ItemType Directory -Force -Path "$($Root)/../$($policyFolderExport)" } 

If (!(Test-Path -Path "$($Root)/../$($policyInitiativeExport)")) { $dummy = New-Item -ItemType Directory -Force -Path "$($Root)/../$($policyInitiativeExport)" } 

If (Test-Path -Path $FilePolicy  ) {

    $BodyString = Get-Content $FilePolicy  | ConvertFrom-Json 

	foreach ( $PolicyDef in  $BodyString.variables.initiatives.policySetDefinitions) {

		$FilePolicy = "$($Root)/../$($policyInitiativeFolderSource)/$($policyDef.Name).json"
	
		$PolicyObject = [PSCustomObject] @{
			properties = $policyDef.Properties
			id         = "/providers/policySetDefinitions/$( $policyDef.Name)"
			type       = "Microsoft.Authorization/policySetDefinitions" 
			name       = $policyDef.Name
		}
		$PolicyObject |  ConvertTo-Json  -Depth 100 | out-file  $FilePolicy

		
	}

	foreach ( $PolicyDef in  $BodyString.variables.policies.policyDefinitions) {

		$FilePolicy = "$($Root)/../$($policyFolderExport)/$($policyDef.Name).json"
	
		$PolicyObject = [PSCustomObject] @{
			properties = $policyDef.Properties
			id         = "/providers/policySetDefinitions/$( $policyDef.Name)"
			type       = "Microsoft.Authorization/policySetDefinitions" 
			name       = $policyDef.Name
		}
		$PolicyObject |  ConvertTo-Json  -Depth 100 | out-file  $FilePolicy

		
	}

   
}
else {

    write-host "Missing input file $FilePolicy" -ForegroundColor Red
    exit
}



  
