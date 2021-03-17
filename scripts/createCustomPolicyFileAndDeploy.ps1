<#
	.SYNOPSIS
        1. create the policy.json and deploy it to the specified management group  
        2. require the sample policies.json in the same flder that is used as the template for the resource deploy logic.



	.DESCRIPTION

         


	.EXAMPLE
	   .\createCustomPolicyFileAndDeploy.ps1  
	   
	.LINK

	.Notes
		NAME:      createCustomPolicyFileAndDeploy
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$policySourcefile = "policies.json",
    

    [string]$policyFolderSource = "esPoliciesDefinitionsCustom",

    [string]$policyInitiativeFolderSource = "esPoliciesInitiatives",

    [string]$policyFileExport = "/../armTemplates/auxiliary/policies.json",

    [Parameter(Mandatory = $true)]
    [string]$topLevelManagementGroupPrefix ,

    [string]$Location = "WestEurope"


)


$Root = $PSScriptRoot + "/"


$newLine = 
$policySourceFileFullPath = "$($Root)./$policySourcefile"

If (Test-Path -Path $policySourceFileFullPath ) {

    $BodyString = Get-Content $policySourceFileFullPath  | ConvertFrom-Json 

    $NewObject = @()
    $NewObject = [PSObject]$BodyString

    $NewObject.variables.policies.policyDefinitions = @()
    $NewObject.variables.initiatives.policySetDefinitions = @()
  
    $polFiles = get-childitem "$PSScriptRoot/../$policyfolderSource/*.json"
    $newDefinitions = @()
    $newPolicyDefinitions = @()
    foreach ($policy in $polFiles) {
        write-host "process file $($policy.Name)"
        $BodyStringPol = Get-Content $policy  | ConvertFrom-Json 
        $NewObjectPol = @()
        $NewObjectPol = [PSObject]$BodyStringPol
        if ($NewObjectPol.Type) {
            $NewObjectPol.PSObject.Properties.Remove('Type')
        }
        if ($NewObjectPol.Id) {
            $NewObjectPol.PSObject.Properties.Remove('Id')
        }

        if ($NewObjectPol.Properties.PolicyRule) {

            [string]$createexcope = $NewObjectPol.Properties.PolicyRule | ConvertTo-Json -Depth 100
           
            $addEscape = $createexcope -replace """\[", """[["

          
         

            $NewObjectPol.Properties.PolicyRule = @()

          
            $NewObjectPol.Properties.PSObject.Properties.Remove('policyRule')

            $NewObjectPol.Properties | Add-Member -MemberType NoteProperty -Name policyRule  -Value  (Convertfrom-Json  $addEscape ) 

            $newDefinitions += $NewObjectPol
        }


    }
    $polFiles = get-childitem "$PSScriptRoot/../$policyInitiativeFolderSource/*.json"

    foreach ($policy in $polFiles) {
        write-host "process file $($policy.Name)"
        $BodyStringPol = Get-Content $policy  | ConvertFrom-Json 
        $NewObjectPol = @()
        $NewObjectPol = [PSObject]$BodyStringPol
        if ($NewObjectPol.Type) {
            $NewObjectPol.PSObject.Properties.Remove('Type')
        }
        if ($NewObjectPol.Id) {
            $NewObjectPol.PSObject.Properties.Remove('Id')
        }



        if ($NewObjectPol.Properties.PolicyDefinitions) {

            [string]$createexcope = $NewObjectPol.Properties.PolicyDefinitions | ConvertTo-Json -Depth 100

            $newfilesstring = ""
            $BodyString = Get-Content $policy 
            foreach ($line in $BodyString) {


                $line = $line -replace """\[parameters", """[[parameters"
                if ($newLine -ne "") {
                    $newfilesstring += "`n"
                } 
                If ($line -notcontains "policyDefinitionId") {
                    $line = $line -replace """\[parameters", """[[parameters"
                }

                $newfilesstring += $line
            }
           
          

            $NewObjectPol.Properties.PolicyDefinitions = @()

          
            $NewObjectPol.Properties.PSObject.Properties.Remove('PolicyDefinitions')

            $addEscape = (Convertfrom-Json   $newfilesstring ).Properties.PolicyDefinitions 

            $NewObjectPol.Properties | Add-Member -MemberType NoteProperty -Name PolicyDefinitions  -Value   (  $addEscape ) 



            $newPolicyDefinitions += $NewObjectPol
        }

        



    }
    
    $Root = $PSScriptRoot + "/"
    $FileTempPolicy = "$($Root)./Temp.json"

    $NewObject.variables.policies.policyDefinitions = $NewDefinitions
    $NewObject.variables.initiatives.policySetDefinitions = $newPolicyDefinitions
    $NewObject |  ConvertTo-Json  -Depth 100 | out-file   $FileTempPolicy
    write-host "Temp generated new file  $( $FileTempPolicy)"
  
  

    #SOrt file based on input and add newest at the bottum




    $Root = $PSScriptRoot + "/"
    $FilePolicy = "$($Root)./$policySourcefile"
    $FileOutputPolicy = "$($Root)./$policyFileExport"
    $FilePolicySource = $FileTempPolicy

    $BodyString = Get-Content $FilePolicy | ConvertFrom-Json 

    $NewObject = @()
    $NewObject = [PSObject]$BodyString

    $NewObject.variables.policies.policyDefinitions = @()
    $NewObject.variables.initiatives.policySetDefinitions = @()



    $BodyStringSource = Get-Content $FilePolicySource  | ConvertFrom-Json 
    $newPolicyDefinitions = @()
    $newPolicySetDefinitions = @()



    $BodyString = Get-Content $FilePolicy  | ConvertFrom-Json 

    foreach ( $PolicyDef in  $BodyString.variables.initiatives.policySetDefinitions) {
        $name = $policyDef.Name
        foreach ( $PolicyDefSource in  $BodyStringSource.variables.initiatives.policySetDefinitions) {

            if ($name -eq $PolicyDefSource.name) {
	
                $PolicyObject = [PSCustomObject] @{
                    properties =  $PolicyDefSource.Properties
                    name       =  $PolicyDefSource.Name
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
                    properties =  $PolicyDefSource.Properties
                    name       =  $PolicyDefSource.Name
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


    Write-Host "Start deploy policy definitions to toplevel Management Group"
    New-AzManagementGroupDeployment -TemplateFile $FileOutputPolicy -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -ManagementGroupId "$($topLevelManagementGroupPrefix)" -Verbose -Location $Location 

    Remove-Item $FileTempPolicy
    

}
else {

    write-host "Missing template file $policySourceFileFullPath" -ForegroundColor Red
    exit
}



  
