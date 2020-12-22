[cmdletbinding()] 
Param (



    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99"

)

$context = Get-AzContext 


if ($context.Subscription.id -ne $SubscriptionId) {
    Try { 
        Set-AzContext -SubscriptionId $SubscriptionId  -ErrorAction Stop
    } 
    catch {
        throw $_
    }
}

$Scope = "/subscriptions/$SubscriptionId"

$allPolicySetDefinitions = Get-AzPolicySetDefinition -SubscriptionId $SubscriptionId -Custom

foreach ($policSet in $allPolicySetDefinitions){
    $status = Remove-AzPolicyDefinition -ID $policSet.PolicySetDefinitionId -Force
    write-host "deleted definition $($policSet.Name)"
}


$allPolicyDefinitions = Get-AzPolicyDefinition -SubscriptionId $SubscriptionId -Custom

foreach ($policy in $allPolicyDefinitions){
    $status = Remove-AzPolicyDefinition -ID $policy.PolicyDefinitionId -Force
    write-host "deleted definition $($policy.Name)"
}