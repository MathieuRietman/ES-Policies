
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

    [string]$policyfolderSource = "esSourcePoliciesDeny",

    [string]$policyfolderTarget = "esModifediPoliciesDeny2",

    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99",

    [string]$version = "",

    [string]$policyInititiveSourceFileName = "DenyPublicEndpointsInitiative.json",

    [string]$targettype = "subscription"


)

$denyPoliciesToAdded = @("Deny-PublicEndpoint-CosmosDB",
    "Deny-PublicEndpoint-MariaDB",
    "Deny-PublicEndpoint-MySQL",
    "Deny-PublicEndpoint-PostgreSql",
    "Deny-PublicEndpoint-KeyVault",
    "Deny-PublicEndpoint-Sql",
    "Deny-PublicEndpoint-Storage",
    "Deny-PublicEndpoint-Aks")


$policyInititiveSourceFile = "$PSScriptRoot/../$policyfolderSource/$policyInititiveSourceFileName"
$policyInititiveTargetFile = "$PSScriptRoot/../$policyfolderTarget/$policyInititiveSourceFileName"
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
    "policyDefinitionReferenceId": "nametobeaddedfromproposedfilename",
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/contoso/providers/Microsoft.Authorization/policyDefinitions/Proposeddisplayname",
    "parameters": {
    
    }
},
"@


$PolicyDefinitionTemplate = @"
{
    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/WillbeReplace",
    "policyDefinitionReferenceId": "WillbeReplace",
    "parameters": {
        "effect": {
            "value": "[parameters('WillbereplacesEffect')]"
          }

      }
 
  }
"@ 

$AdditionalDiagnosticsMetricsParametersEffect = @"
{

    "type": "string",
    "defaultValue": "Deny",
    "allowedValues": [
        "Audit",
        "Deny",
        "Disabled"
    ],
    "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"

 }
}
"@

$metadata = @"
{
      "version": "0",
      "category": "dummy"
} 
"@

$Typeparameter = @"
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

$NewPolicyDefinition = @()

if (!(Test-Path -Path $newFolder )) {
    New-Item -ItemType directory -Path $newFolder
}

If (Test-Path -Path $policyInititiveSourceFile ) {

    $BodyString = Get-Content $policyInititiveSourceFile  | ConvertFrom-Json 
    $NewObject = @()
    $NewObject = [PSObject]$BodyString.Parameters.Input.Value
    # Remove Items
    $NewObject.PSObject.Properties.Remove('SubscriptionId')
    $Type = $NewObject.ResourceType
    $NewObject.PSObject.Properties.Remove('ResourceType')
    
    # Add ProfileName as Parameters

    # Delete Existing Definitions
    $NewObject.Properties.PolicyDefinitions = @()

    foreach ($denyPolicy in $denyPoliciesToAdded ) {

        $ProposedValues = $PoliciesExcel | Where-Object { $_.Name -in $denyPolicy}
        $policyFilename = "$PSScriptRoot/../$policyfolderSource/$($ProposedValues.PolicyName)"
        $BodyString2 = Get-Content $policyFilename  | ConvertFrom-Json 
        $policyDefinitionObject = @()
        $policyDefinitionObject = [PSObject]$BodyString2.Parameters.Input.Value
        if (  $policyDefinitionObject.Properties.PolicyRule.then.effect -eq "Deny") {
                write-host $denyPolicy 
                # if ($policy.FullName -ne (get-childitem $policyInititiveSourceFile -file).FullName) {

                # Use the proposed values from the excel sheet

                If ($ProposedValues) {
                    if ($ProposedValues.ShortName) {
                        $ProposedValues.ShortName
                    
                        $NewPolicyDefinition = $PolicyDefinitionTemplate |  ConvertFrom-Json 

                        # Set PolicyDefinition ID to Subscription provided as paramaters to test
                        # Need to be replaced with GUID 

                        $NewPolicyDefinition.policyDefinitionReferenceId = "$($ProposedValues.ShortName)DenyPaasPublicIP" 
                        if ($targettype -eq "subscription") {
                            $NewPolicyDefinition.policyDefinitionId = "/subscriptions/$SubscriptionId/providers/Microsoft.Authorization/policyDefinitions/$($policyDefinitionObject.Name)$($version)" 
          
                        }
                        elseif ($targettype -eq "policyfile") {
                            $NewPolicyDefinition.policyDefinitionId = "[concat(variables('scope'), '/providers/Microsoft.Authorization/policyDefinitions/$($policyDefinitionObject.Name)$($version)')]" 
                        }


               
                        #Create for every Policy File a parameter for effect
    
                        $effectParameterName = "$($ProposedValues.ShortName)PublicIpDenyEffect"                        
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

    # Use the proposed values from the excel sheet
    $ProposedValues = $PoliciesExcel | Where-Object { $_.PolicyName -in (get-childitem $policyInititiveSourceFile -file).Name }
    If ($ProposedValues) {
        # Changed the proposed values
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
            PolicyName         = $policyInititiveSourceFileName;

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