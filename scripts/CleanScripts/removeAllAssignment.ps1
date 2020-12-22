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

$allPolicyAssignments = Get-AzPolicyAssignment -Scope $Scope

foreach ($assignment in $allPolicyAssignments){
    $status = Remove-AzPolicyAssignment -ID $assignment.PolicyAssignmentId
    write-host "deleted assignment $($assignment.Name)"
}