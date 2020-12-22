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

    [string]$policyfolderSource = "esSourceSetDiagnostics",

    [string]$policyfolderTarget = "esModifediPoliciesSetDiagnostics2",

    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99",

    [string]$version = "",

    [string]$policyInititiveSourceFileName = "DeployDiagLogAnalyticsInitiative.json",

    [string]$targettype = "subscription"
    

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



$parameffectjson = @"
{
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/contoso/providers/Microsoft.Authorization/policyDefinitions/Proposeddisplayname",
    "policyDefinitionReferenceId": "nametobeaddedfromproposedfilename",
    "parameters": {
        "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
          },
          "effect": {
            "value": "[parameters('WillbereplacesEffect')]"
          },
          "profileName": {
            "value": "[parameters('profileName')]"
          }
    }
}
"@


$AdditionalDiagnosticsMetricsParametersEffect = @"
{
  
        "type": "String",
        "defaultValue": "DeployIfNotExists",
        "allowedValues": [
            "DeployIfNotExists",
            "Disabled"
        ],
        "metadata": {
            "displayName": "Enable all the metrics to LogAnalytics for nameofService",
            "description": "Enable all the metrics to LogAnalytics for nameofService"
        }
  
}
"@

$profileNameParameter =@"
{
    "type": "String",
    "defaultValue": "setbypolicy",
    "metadata": {
      "displayName": "Profile name",
      "description": "The diagnostic settings profile name"
    }
}
"@


$metadata = @"
{
      "version": "0",
      "category": "dummy"
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

If (Test-Path -Path $policyInititiveSourceFile ) {

    $BodyString = Get-Content $policyInititiveSourceFile  | ConvertFrom-Json 
    $NewObject = @()
    $NewObject = [PSObject]$BodyString.Parameters.Input.Value

    $NewObject.PSObject.Properties.Remove('SubscriptionId')
    $Type = $NewObject.ResourceType
    $NewObject.PSObject.Properties.Remove('ResourceType')
    $NewObject.Properties.PolicyDefinitions =@()
    
    #Modify the description of parameters.logAnalytics

    if ($NewObject.Properties.parameters.logAnalytics) {
        $NewObject.Properties.parameters.logAnalytics.metadata.description = "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID."
    }

    #Add profilename Parameter

    $NewObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name "profileName"  -Value (  $profileNameParameter |  ConvertFrom-Json ) -force
   



    foreach ($policy in $polFiles) {


        $BodyString2 = Get-Content $policy  | ConvertFrom-Json 
        $policyDefinitionObject = @()
        $policyDefinitionObject = [PSObject]$BodyString2.Parameters.Input.Value
        
        write-host $Policy.name 

        #Find Policies file with diagnosticsettings

        if (  $policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources) {
            if ($policyDefinitionObject.Properties.PolicyRule.then.details.deployment.properties.template.resources[0].type -match "providers/diagnosticSettings") {
           # Use the proposed values from the excel sheet
                $ProposedValues = $PoliciesExcel | Where-Object { $_.PolicyName -in $Policy.name }

                If ($ProposedValues) {
                    if ($ProposedValues.ShortName) {

                        $NewPolicyDefinition = $parameffectjson |  ConvertFrom-Json 

                        # Set PolicyDefinition ID to Subscription provided as paramaters to test
                        # Need to be replaced with GUID 

                        $NewPolicyDefinition.policyDefinitionReferenceId = "$($ProposedValues.ShortName)DeployDiagnosticLogDeployLogAnalytics" 
                        if ($targettype -eq "subscription") {
                            $NewPolicyDefinition.policyDefinitionId = "/subscriptions/$SubscriptionId/providers/Microsoft.Authorization/policyDefinitions/$($policyDefinitionObject.Name)$($version)" 
  
                        }
                        elseif ($targettype -eq "policyfile") {
                            $NewPolicyDefinition.policyDefinitionId = "[concat(variables('scope'), '/providers/Microsoft.Authorization/policyDefinitions/$($policyDefinitionObject.Name)$($version)')]" 
                        }


       
                        #Create for every Policy File a parameter for effect

                        $effectParameterName = "$($ProposedValues.ShortName)LogAnalyticsEffect"                        
                        $NewParamDefinition = $AdditionalDiagnosticsMetricsParametersEffect |  ConvertFrom-Json 
                        $NewParamDefinition.metadata.description = $ProposedValues.ProposedDescription
                        $NewParamDefinition.metadata.displayName = $ProposedValues.ProposedDisplayname
                        $NewObject.Properties.parameters | Add-Member -MemberType NoteProperty -Name $effectParameterName  -Value ( $NewParamDefinition) -force


                        $NewPolicyDefinition.parameters.effect.value = "[parameters('$effectParameterName')]"

                        $NewObject.Properties.PolicyDefinitions += @($NewPolicyDefinition)
                    }
                }
            }

        }
    } 

    

    


    # Use the proposed values from the excel sheet
    $ProposedValues = $PoliciesExcel | Where-Object { $_.PolicyName -in (get-childitem $policyInititiveSourceFile -file).Name }
    If ($ProposedValues) {
        if ($ProposedValues.ProposedDisplayname) 
        { $NewObject.Properties.DisplayName = $ProposedValues.ProposedDisplayname }
        if ($ProposedValues.Mode -and $NewObject.Properties.Mode) 
        { $NewObject.Properties.Mode = $ProposedValues.Mode }
        if ($ProposedValues.ProposedDescription) 
        { $NewObject.Properties.Description = $ProposedValues.ProposedDescription }
        if ($ProposedValues.Version) {
            if (!$NewObject.Properties.metadata) { $NewObject.Properties | add-member -Name "metadata" -value (Convertfrom-Json $metadata ) -MemberType NoteProperty -Force }
            if (!$NewObject.Properties.metadata.version) { $NewObject.Properties.metadata | Add-Member -MemberType NoteProperty version -Value "A" }
            $NewObject.Properties.metadata.version = $ProposedValues.version
        }
        if ($ProposedValues.category) {
            if (!$NewObject.Properties.metadata) { $NewObject.Properties | add-member -Name "metadata" -value (Convertfrom-Json $metadata ) -MemberType NoteProperty -Force }
            if (!$NewObject.Properties.metadata.category) { $NewObject.Properties.metadata | Add-Member -MemberType NoteProperty category -Value "A" }
            $NewObject.Properties.metadata.category = $ProposedValues.category
        }
        if (($ProposedValues.ProposedRoleID) -and ($NewObject.Properties.PolicyRule.then.details.roleDefinitionIds) ) {
            $ProposedRoleID = ($ProposedValues.ProposedRoleID).Split(",")
            $NewObject.Properties.PolicyRule.then.details.roleDefinitionIds = @($ProposedRoleID) 
        }
    }
    
    $FilePolicy = "$($newFolder)/$($policy.Name)"
    if ($ProposedValues.ProposedFilename) { $FilePolicy = "$($newFolder)/$($ProposedValues.ProposedFilename)" }
    $PolicyObject = [PSCustomObject] @{
        properties = $NewObject.Properties
        id         = "/providers/$($type)/$($NewObject.Name)"
        type       = $NewObject.Type
        name       = $NewObject.Name
    }
    $PolicyObject |  ConvertTo-Json  -Depth 100 | out-file  $FilePolicy
      
    $Logobject += @([PolicyInfo]@{
            PolicyName         = $policy.Name;

            DisplayName        = $NewObject.Properties.DisplayName;
            ProposedFilename   = $ProposedValues.ProposedFilename
            Description        = $NewObject.Properties.Description;
            version            = $NewObject.Properties.metadata.version;
            category           = $NewObject.Properties.metadata.category;
            effect             = $NewObject.Properties.PolicyRule.then.effect;
            roleDefinitionIds  = $NewObject.Properties.PolicyRule.then.details.roleDefinitionIds;
            parameters         = $NewObject.Properties.Parameters  | ConvertTo-Json;
            existenceCondition = $NewObject.Properties.PolicyRule.then.details.existenceCondition | ConvertTo-Json;
        })
    
    
    

    $Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoSize 
    $Logobject |   Sort-Object -Property PolicyName | Export-csv -Path .\Policyinfo.csv 
}
else {
    
    write-host " Error file not found " 
}