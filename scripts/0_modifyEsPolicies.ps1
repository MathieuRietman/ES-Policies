<#
	.SYNOPSIS
        1. Modify the policies to conbverted to build in



	.DESCRIPTION

         
     Use the excel to get new naming from it

	.EXAMPLE
	   .\ModifyPolicies.ps1 
	   
	.LINK

	.Notes
		NAME:      ModifyPolicies
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$policyfolderSource = "esPoliciesFixed",

    [string]$policyfolderTarget = "esModifediPolicies2"
    

)



$policyInititiveSourceFile = "$PSScriptRoot/../$policyfolderSource/$policyInititiveSourceFileName"
$policyInititiveTargetFile = "$PSScriptRoot/../$policyfolderTarget/$policyInititiveSourceFile"
$polFiles = get-childitem "$PSScriptRoot/../$policyfolderSource/*.json"
$newFolder = "$PSScriptRoot/../$policyfolderTarget"
class PolicyInfo {
    [string]$PolicyName;
    [string]$ProposedFilename
    [string]$DisplayName;
    [String]$ProposedDisplayname;
    [string]$Description;
    [string]$ProposedDescription
    [string]$version; 
    [string]$category; 
    [string]$effect; 
    [string]$roleDefinitionIds;
    [string]$ProposedRoleID
    [string]$parameters;
    [String]$existenceCondition
} 
$LogObject = @()





$parameffectDeny = @"
{
    "type": "String",
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    }
}
"@

$parameffectDeployIfNotExists = @"
{
    "type": "string",
    "defaultValue": "DeployIfNotExists",
    "allowedValues": [
      "DeployIfNotExists",
      "Disabled"
    ],
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    }
}
"@

$paramProfile = @"
{
    "type": "string",
    "defaultValue": "setbypolicy",
    "metadata": {
      "displayName": "Profile name",
      "description": "The diagnostic settings profile name"
    }
}
"@



$paramMetricsEnabled = @"
{
    "type": "string",
    "defaultValue": "True",
    "allowedValues": [
      "True",
      "False"
    ],
    "metadata": {
      "displayName": "Enable metrics",
      "description": "Whether to enable metrics stream to the Log Analytics workspace - True or False"
    }
}
"@



$paramLogsEnabled = @"
{
    "type": "string",
    "defaultValue": "True",
    "allowedValues": [
      "True",
      "False"
    ],
    "metadata": {
      "displayName": "Enable logs",
      "description": "Whether to enable logs stream to the Log Analytics workspace - True or False"
    }
}
"@


$metadata = @"
{
      "version": "0",
      "category": "dummy"
} 
"@

$Typestr = @"
{
    "type": "string"
  }
"@


Install-Module -Name PSExcel
Get-command -module psexcel
$Excelfile = "https://microsofteur-my.sharepoint.com/:x:/g/personal/krnese_microsoft_com/Ef-2c0sax7tFuyCrKutZZX0BKDLXfgvAGZlMV3tBwYYFbQ?e=Hpuf7E"
$tmp = "$PSScriptRoot\ES-Built-In-Policy.xlsx"


$PoliciesExcel = new-object System.Collections.ArrayList

foreach ( $Policy in (Import-XLSX -Path $tmp -sheet "Provided List" -RowStart 1)) {

    $PoliciesExcel.add($Policy)

}



if (!(Test-Path -Path $newFolder )) {
    New-Item -ItemType directory -Path $newFolder
}
if ((Test-Path -Path $newFolder) -and ($newfolder)) {
    #First eremove existing items as we create new ones.
    Get-ChildItem -Path $newFolder -File | foreach { $_.Delete() }
}


   
foreach ($policy in $polFiles) {


    $bodyString2 = Get-Content $policy  | ConvertFrom-Json 
    $policyDefinitionObject = @()
    $policyDefinitionObject = [PSObject]$bodyString2.Parameters.Input.Value
    $Type = $policyDefinitionObject.ResourceType    
    write-host $Policy.name 

     

    #Find Policies file with diagnosticsettings

    
    if ($policyDefinitionObject.Properties.parameters.logAnalytics) {
        $policyDefinitionObject.Properties.parameters.logAnalytics.metadata.description = "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID."
    }

    if (  $policyDefinitionObject.Properties.PolicyRule.then.effect) {

        if (  $policyDefinitionObject.Properties.PolicyRule.then.effect -eq "Deny") {

           
            if (!$policyDefinitionObject.Properties.parameters) {
                $policyDefinitionObject.Properties  | Add-Member -MemberType NoteProperty Parameters -Value ("{}" | ConvertFrom-Json -Depth 100) -force
            }
            $policyDefinitionObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name effect  -Value ( $parameffectDeny | ConvertFrom-Json -Depth 100) -force
            $policyDefinitionObject.Properties.policyRule.then.effect = "[parameters('effect')]"
                
        }

        if (  $policyDefinitionObject.Properties.PolicyRule.then.effect -eq "DeployIfNotExists") {

               
            $policyDefinitionObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name effect  -Value ( $parameffectDeployIfNotExists | ConvertFrom-Json -Depth 100) -force
            $policyDefinitionObject.Properties.policyRule.then.effect = "[parameters('effect')]"     
        }
        if ($policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template) {
            if ($policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].type -match "providers/diagnosticSettings") {

                $policyDefinitionObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name profileName  -Value ( $paramProfile | ConvertFrom-Json -Depth 100) -force
                $Value = @"
{
    "value": "[parameters('profileName')]"
  }
"@
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.parameters  | Add-Member -MemberType NoteProperty -Name profileName -Value ($Value | ConvertFrom-Json -Depth 100)
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.parameters | Add-Member -MemberType NoteProperty  -Name profileName -Value ( $Typestr | ConvertFrom-Json -Depth 100)
       
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].name = "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]"
            }
            if ($policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].properties.metrics) {

                $policyDefinitionObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name metricsEnabled -Value ( $paramMetricsEnabled | ConvertFrom-Json -Depth 100) -force
                $Value = @"
{
    "value": "[parameters('metricsEnabled')]"
  }
"@
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.parameters  | Add-Member -MemberType NoteProperty -Name metricsEnabled -Value ($value | ConvertFrom-Json -Depth 100)
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.parameters | Add-Member -MemberType NoteProperty  -Name metricsEnabled -Value ( $Typestr | ConvertFrom-Json -Depth 100)
                foreach ($metric in $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].properties.metrics) {

                    $metric.enabled = "[parameters('metricsEnabled')]"


                }

            }
                
            if ($policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].properties.logs) {

                $policyDefinitionObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name logsEnabled -Value ( $paramLogsEnabled | ConvertFrom-Json -Depth 100) -force
                $Value = @"
{
    "value": "[parameters('logsEnabled')]"
    }
"@
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.parameters  | Add-Member -MemberType NoteProperty -Name logsEnabled -Value  ($Value | ConvertFrom-Json -Depth 100)
                $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.parameters | Add-Member -MemberType NoteProperty  -Name logsEnabled -Value ( $Typestr | ConvertFrom-Json -Depth 100)
               

                foreach ($Log in $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].properties.logs) {

                    $log.enabled = "[parameters('logsEnabled')]"


                }

            }

        }
        

              
    }
    # Use the proposed values from the excel sheet
    $ProposedValues = $PoliciesExcel | Where-Object { $_.PolicyName -in $Policy.name }
    If ($ProposedValues) {
        if ($ProposedValues.ProposedDisplayname) 
        { $policyDefinitionObject.Properties.DisplayName = $ProposedValues.ProposedDisplayname }
        if ($ProposedValues.Mode -and $policyDefinitionObject.Properties.Mode) 
        { $policyDefinitionObject.Properties.Mode = $ProposedValues.Mode }
        if ($ProposedValues.ProposedDescription) 
        { $policyDefinitionObject.Properties.Description = $ProposedValues.ProposedDescription }
        if ($ProposedValues.Version) {
            if (! $policyDefinitionObject.Properties.metadata) { $policyDefinitionObject.Properties | add-member -Name "metadata" -value (Convertfrom-Json $metadata ) -MemberType NoteProperty -Force }
            if (! $policyDefinitionObject.Properties.metadata.version) { $policyDefinitionObject.Properties.metadata | Add-Member -MemberType NoteProperty version -Value "A" }
            $policyDefinitionObject.Properties.metadata.version = $ProposedValues.version
        }
        if ($ProposedValues.category) {
            if (! $policyDefinitionObject.Properties.metadata) { $policyDefinitionObject.Properties | add-member -Name "metadata" -value (Convertfrom-Json $metadata ) -MemberType NoteProperty -Force }
            if (! $policyDefinitionObject.Properties.metadata.category) { $policyDefinitionObject.Properties.metadata | Add-Member -MemberType NoteProperty category -Value "A" }
            $policyDefinitionObject.Properties.metadata.category = $ProposedValues.category
        }
        if (($ProposedValues.ProposedRoleID) -and ( $policyDefinitionObject.Properties.PolicyRule.then.details.roleDefinitionIds) ) {
            $ProposedRoleID = ($ProposedValues.ProposedRoleID).Split(",")
            $policyDefinitionObject.Properties.PolicyRule.then.details.roleDefinitionIds = @($ProposedRoleID) 
        }
    }
    
    $FilePolicy = "$($newFolder)/$($policy.Name)"
    if ($ProposedValues.ProposedFilename) { $FilePolicy = "$($newFolder)/$($ProposedValues.ProposedFilename)" }
    $PolicyObject = [PSCustomObject] @{
        properties = $policyDefinitionObject.Properties
        id         = "/providers/$($type)/$( $policyDefinitionObject.Name)"
        type       = $policyDefinitionObject.ResourceType   
        name       = $policyDefinitionObject.Name
    }
    $PolicyObject |  ConvertTo-Json  -Depth 100 | out-file  $FilePolicy
      
    $Logobject += @([PolicyInfo]@{
            PolicyName         = $policy.Name;

            DisplayName        = $policyDefinitionObject.Properties.DisplayName;
            ProposedFilename   = $ProposedValues.ProposedFilename
            Description        = $policyDefinitionObject.Properties.Description;
            version            = $policyDefinitionObject.Properties.metadata.version;
            category           = $policyDefinitionObject.Properties.metadata.category;
            effect             = $policyDefinitionObject.Properties.PolicyRule.then.effect;
            roleDefinitionIds  = $policyDefinitionObject.Properties.PolicyRule.then.details.roleDefinitionIds;
            parameters         = $policyDefinitionObject.Properties.Parameters  | ConvertTo-Json;
            existenceCondition = $policyDefinitionObject.Properties.PolicyRule.then.details.existenceCondition | ConvertTo-Json;
        })

} 


$Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoSize 
$Logobject |   Sort-Object -Property PolicyName | Export-csv -Path .\Policyinfo.csv 
