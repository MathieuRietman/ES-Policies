<#
	.SYNOPSIS
        1. Create Policy File and 



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


$PsRoot = "$PSScriptRoot/"
Invoke-Expression "$PsRoot./0_modifyEsPolicies.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll3"   
Invoke-Expression "$PsRoot./0a_createPolicyDefinitionSetDenyPaas.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll3 -targettype 'policyfile' "   
Invoke-Expression "$PsRoot./0a_createPolicyDefinitionSetDiag.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll3 -targettype 'policyfile' "
Invoke-Expression "$PsRoot./0a_createPolicyDefinitionSetSQL.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll3 -targettype 'policyfile' "   
Invoke-Expression "$PsRoot./Exportpolicyfile.ps1 -policyFolderSource  esPoliciesAll3 -policyFileExport  'expPolicies.json'"   
Invoke-Expression "$PsRoot./expDeployfile.ps1 -topLevelManagementGroupPrefix 'MRIT'  -Location 'WestEurope' -policyFileExport 'expPolicies.json'"   

#Invoke-Expression "$PsRoot./expDeployfile.ps1 -topLevelManagementGroupPrefix 'MRIT'  -Location 'WestEurope' -policyFileExport 'policy.wingtip.json'"  

