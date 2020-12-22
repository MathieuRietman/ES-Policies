[cmdletbinding()] 
Param (



    [string]$ManagementGroupName = "MRIT"

)




$allPolicySetDefinitions = Get-AzPolicySetDefinition -ManagementGroupName $ManagementGroupName -Custom

foreach ($policySet in $allPolicySetDefinitions) {
    if ($policySet.ResourceId -like "*/managementGroups/$($ManagementGroupName)*") {
        $status = Remove-AzPolicyDefinition -ID $policySet.PolicySetDefinitionId -Force
        write-host "deleted definition $($policySet.Name)"
    }
}


$allPolicyDefinitions = Get-AzPolicyDefinition  -ManagementGroupName $ManagementGroupName -Custom

foreach ($policy in $allPolicyDefinitions) {
    if ($policy.ResourceId -like "*/managementGroups/$($ManagementGroupName)*") {
        $status = Remove-AzPolicyDefinition -ID $policy.PolicyDefinitionId -Force
        write-host "deleted definition $($policy.Name)"
    }
}