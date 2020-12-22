
[cmdletbinding()] 
Param (

    [string]$policySourcefile = "policies.json",

    [string]$policyFolderSource = "esPoliciesDefinitionsCustom",

    [string]$policyInitiativeFolderSource = "esPolicyInitiatives",

    [string]$policyFileExport = "expPolicies.json",

    [string]$topLevelManagementGroupPrefix = "MRIT",

    [string]$Location = "WestEurope"


)

$Root = $PSScriptRoot + "/"
$FilePolicy = "$($Root)./$policyFileExport"

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

          
            $NewObjectPol.Properties.PSObject.Properties.Remove('PolicyRule')

            $NewObjectPol.Properties | Add-Member -MemberType NoteProperty -Name PolicyRule  -Value  (Convertfrom-Json  $addEscape ) 

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
    
    $NewObject.variables.policies.policyDefinitions = $NewDefinitions
    $NewObject.variables.initiatives.policySetDefinitions = $newPolicyDefinitions
    $NewObject |  ConvertTo-Json  -Depth 100 | out-file  $FilePolicy
    write-host "generated new file  $($FilePolicy)"
  
    Write-Host "Start deploy policy definitions to toplevel Management Group"
    New-AzManagementGroupDeployment -TemplateFile "$Root./$policyFileExport" -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -ManagementGroupId "$($topLevelManagementGroupPrefix)" -Verbose -Location $Location 



  

}
else {

    write-host "Missing template file $policySourceFileFullPath" -ForegroundColor Red
    exit
}



  
