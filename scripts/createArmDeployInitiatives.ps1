<#
	.SYNOPSIS
        1. create the policy.json and deploy it to the specified management group  
        2. require the sample policies.json in the same flder that is used as the template for the resource deploy logic.



	.DESCRIPTION

         


	.EXAMPLE
	   .\createCustomPolicyFileAndDeploy.ps1  
	   
	.LINK

	.Notes
		NAME:      createCustomArmPolicySets
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$policySourcefile = "armPolicySetTemplate.json",
    
 
    [string]$policyInitiativeFolderSource = "esPoliciesInitiatives",

    [string]$policyFolderExport = "/../Changes/DeploymenPolicySets/"



)


$Root = $PSScriptRoot + "/"


$newLine = 
$policySourceFileFullPath = "$($Root)./$policySourcefile"

If (Test-Path -Path $policySourceFileFullPath ) {

   
  
    $polFiles = get-childitem "$PSScriptRoot/../$policyInitiativeFolderSource/*.json"

    foreach ($policy in $polFiles) {
        write-host "process file $($policy.Name)"
        # Get the template
        $BodyString = Get-Content $policySourceFileFullPath  | ConvertFrom-Json 

        $NewObject = @()
        $NewObject = [PSObject]$BodyString
    
        $NewObject.resources[0].properties = @()
        $newfilesstring =""
        $polFiles = get-childitem "$PSScriptRoot/../$policyfolderSource/*.json"
        $newParameters = @()
        $newPolicyDefinitions = @()
        # Get the file
        $BodyStringPol = Get-Content $policy  | ConvertFrom-Json 
        $NewObjectPol = @()
        $NewObjectPol = [PSObject]$BodyStringPol
        $NewObject.resources[0].name =   $NewObjectPol.name 
    
  
        [string]$createexcope = $NewObjectPol.properties | ConvertTo-Json -Depth 100

        foreach ($line in $createexcope) {


            $line = $line -replace """\[parameters", """[[parameters"
   
          

            $newfilesstring += $line
        }

        $addEscape =    $newfilesstring |Convertfrom-Json
        $NewObject.resources[0].properties=  $addEscape

       # $NewObject.resources[0].properties | Add-Member -MemberType NoteProperty -Name PolicyDefinitions  -Value   (  $addEscape ) 
        $FileOutputArm = "$($root)$($policyFolderExport)$($policy.name)"
        $NewObject |  ConvertTo-Json  -Depth 100 | out-file  $FileOutputArm

        



    }
    
    

}
else {

    write-host "Missing template file $policySourceFileFullPath" -ForegroundColor Red
    exit
}



  
